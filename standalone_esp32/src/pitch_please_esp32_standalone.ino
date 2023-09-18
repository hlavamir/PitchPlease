// https://github.com/pschatzmann/arduino-audio-tools
// https://pschatzmann.github.io/arduino-audio-tools/classaudio__tools_1_1_audio_kit_stream.html
// https://pschatzmann.github.io/arduino-audio-tools/classaudio__tools_1_1_audio_kit_stream_config.html

// board setup
//#include "soc/rtc_wdt.h"

// audio input and fft
#define AUDIOKIT_BOARD 5
#define WORKAROUND_MIC_LINEIN_MIXED true
#define ES8388_DEFAULT_MIC_GAIN 0
#define ES8388_DEFAULT_INPUT_GAIN 25
#define WORKAROUND_ES8388_LINE1_GAIN 25
#define AI_THINKER_ES8388_VOLUME_HACK 0

#define AUDIOKIT_CHANNELS 2
#define AUDIOKIT_SAMPLES_PER_SECOND 44100
#define AUDIOKIT_BITS_PER_SAMPLE 16

#define BUFFER_SIZE 512
#define FFT_BINS 512

#include "AudioTools.h"
#include "AudioLibs/AudioKit.h"
#include "AudioLibs/AudioRealFFT.h"

#include "webserver.h"
#include "led_output.h"
#include "utilities.h"

// Control server
const char *networkCredentials[][2] = {
	{"nsynk", "boysintown"},
	{"Doppelfiggo", "waslaberschdu???"},
	{"Miro's iPhone", "87654321"}};

// audiokit
AudioKitStream kit;
AudioRealFFT fft;

StreamCopy stream_fft(fft, kit);
StreamCopy stream_monitor(kit, kit);

// FFT & signal processing
float fftmax = 0;
bool fft_result_available = false;

float tmp = 0;
int tmpID = 0;

unsigned long fft_timelast = 0;
unsigned long fft_timecurr = 0;

#define SIGNAL_BUFFER_SIZE LEDs_PER_STRIP * LED_NUM_STRIPS

float 	buff_fftmags	[SIGNAL_BUFFER_SIZE];
float 	buff_fftmax		[SIGNAL_BUFFER_SIZE];
float 	buff_normalized	[SIGNAL_BUFFER_SIZE];
bool  	buff_peak		[SIGNAL_BUFFER_SIZE];
float 	buff_peakscore	[SIGNAL_BUFFER_SIZE];
float 	buff_brightness	[SIGNAL_BUFFER_SIZE];

float deltaTime = 0;

bool peak = false;
bool blink = false;

float timeSinceLastPeak = 0;
float blinkPhase = 0;
float idlePhase = 0;

// other
TaskHandle_t loop2_task;
const bool previewLEDsInSerialMonitor = false;

void processOutput()
{
	static float blinkDecay;
	static float blinkBrightness;
	static float idleAttack;
	static float idleBrightness;
	static float peakscore;

	static bool nextPeakAllowed;
	static bool peakDetected;

	static uint8_t hueOut;
	static uint8_t satOut;

	timeSinceLastPeak += deltaTime;
	peak = false;

	blinkDecay = lerp(0.1, 2.0, cc[0]);
	idleAttack = lerp(0.1, 20.0, cc[1]);

	// calculate global peak score
	peakscore = 0;
	for (int i = 0; i < SIGNAL_BUFFER_SIZE; i++)
	{
		if (buff_peak[i])
			peakscore += 1;
	}

	peakscore /= SIGNAL_BUFFER_SIZE;

	// find out, if next peak is allowed and above sensitivity treshold
	nextPeakAllowed = timeSinceLastPeak > lerp(10.0, 0.5, cc[7]);
	peakDetected = peakscore > pow(1 - (cc[7]), 2);

	if (peakDetected && nextPeakAllowed)
	{
		peak = true;
		blink = true;
		timeSinceLastPeak = 0;
	}

	// calculate phases
	blinkPhase = saturate(timeSinceLastPeak / blinkDecay);
	idlePhase = saturate((timeSinceLastPeak - blinkDecay) / idleAttack);
	if (timeSinceLastPeak > blinkDecay)
		blink = false;

	// calculate brightnesses
	blinkBrightness = cc[4] * pow(1 - blinkPhase, 2);
	idleBrightness = cc[5] * idlePhase;

	// saturation
	if(blink != (cc[8] > 0.5))	satOut = 0;
	else						satOut = 255;

	// hue
	hueOut = round(cc[2] * 255);

	if (blink)
	{
		// blink behaviour
		for (int i = 0; i < SIGNAL_BUFFER_SIZE; i++)
		{
			buff_brightness[i] = blinkBrightness;
		}
	}
	else
	{
		// idle behaviour
		for (int i = 0; i < SIGNAL_BUFFER_SIZE; i++)
		{
			if(cc[9] >= 0.5){
				buff_brightness[i] = idleBrightness;
			} else {
				buff_brightness[i] = idleBrightness * buff_peak[i];
			}			
		}
	}

	// quick outputting LEDs test
	for(int i = 0; i < LED_NUM_STRIPS; i++)
	{
		for (int j = 0; j < LEDs_PER_STRIP; j++)
		{
			tmpID = (j * LED_NUM_STRIPS) + i;
			setLED(i, j, CHSV(0, 255, trunc(buff_brightness[tmpID] * 255)));
		}
	}

	// preview in serial monitor
	if(previewLEDsInSerialMonitor)
	{	
		for (int i = 0; i < LED_NUM_STRIPS; i++)
		{
			Serial.print("|");
			for (int j = 0; j < LEDs_PER_STRIP; j++)
			{
				tmpID = (j * LED_NUM_STRIPS) + i;

				if (buff_brightness[tmpID] > 0.9)
					Serial.print("■");
				else if (buff_brightness[tmpID] > 0.8)
					Serial.print("□");
				else if (buff_brightness[tmpID] > 0.6)
					Serial.print("*");
				else if (buff_brightness[tmpID] > 0.3)
					Serial.print("·");
				else
					Serial.print(" ");
			}
			Serial.print("| ");
		}
	}

	Serial.print(deltaTime, 3);
	Serial.print(" ");
	Serial.print(xPortGetCoreID());
	Serial.println();
}

// this gets called every time fft finishes analyzing
// the current sampleblock
void processFFT()
{
	fft_timelast = fft_timecurr;
	fft_timecurr = millis();
	deltaTime = (fft_timecurr - fft_timelast) / float(1000);

	// update signal buffers
	for (int i = 0; i < SIGNAL_BUFFER_SIZE; i++)
	{
		buff_fftmax[i] = max(buff_fftmax[i], buff_fftmags[i]);
		fftmax = max(fftmax, buff_fftmags[i]);

		tmp = min(max((buff_fftmags[i] - 20000) / buff_fftmax[i], (float)0), (float)1);

		if (tmp > buff_normalized[i] * 1.25)
		{
			buff_peak[i] = true;
			buff_peakscore[i] = tmp - buff_normalized[i];
			buff_normalized[i] = tmp;
		}
		else
		{
			buff_peak[i] = false;
			buff_normalized[i] *= 0.95;
		}
	}

	// decay fft max buffer
	for (int i = 0; i < LEDs_PER_STRIP * LED_NUM_STRIPS; i++)
	{
		buff_fftmax[i] = max(buff_fftmax[i] * 0.995, 5000.0);
	}

	// blur neighbour fft max values
	for (int i = 1; i < LEDs_PER_STRIP - 1; i++)
	{
		buff_fftmax[i] = (buff_fftmax[i - 1] + buff_fftmax[i] + buff_fftmax[i + 1]) * 0.333;
	}

	fftmax = max(fftmax * 0.995, 5000.0);

	processOutput();
}

// callback function for when fft finishes analyzing
// the current audio sample
void fftResult(AudioFFTBase &fft)
{
	static float *mags;

	lockSemaphore();

	mags = fft.magnitudes();
	for(int i = 0; i < SIGNAL_BUFFER_SIZE; i++) buff_fftmags[i] = mags[i];
	fft_result_available = true;
	//processFFT();

	unlockSemaphore();
}

void setup()
{
	Serial.begin(115200);

	//rtc_wdt_protect_off();
	//rtc_wdt_disable();

	AudioLogger::instance().begin(Serial, AudioLogger::Warning);

	// setup Audiokit
	auto cfg = kit.defaultConfig(RXTX_MODE);
	cfg.sd_active = false;
	cfg.input_device = AUDIO_HAL_ADC_INPUT_LINE2;
	cfg.output_device = AUDIO_HAL_DAC_OUTPUT_ALL; // AUDIO_HAL_DAC_OUTPUT_LINE1

	cfg.channels = AUDIOKIT_CHANNELS;
	cfg.sample_rate = AUDIOKIT_SAMPLES_PER_SECOND;
	cfg.bits_per_sample = AUDIOKIT_BITS_PER_SAMPLE;
	cfg.buffer_size = BUFFER_SIZE;

	// kit.setVolume(0); // disable microphone
	kit.begin(cfg);

	// Setup FFT
	auto tcfg = fft.defaultConfig();
	tcfg.length = FFT_BINS;
	tcfg.channels = AUDIOKIT_CHANNELS;
	tcfg.sample_rate = AUDIOKIT_SAMPLES_PER_SECOND;
	tcfg.bits_per_sample = AUDIOKIT_BITS_PER_SAMPLE;
	tcfg.callback = &fftResult;
	fft.begin(tcfg);

	for (int i = 0; i < SIGNAL_BUFFER_SIZE; i++)
	{
		buff_fftmax[i] = 0;
		buff_normalized[i] = 0;
	}

	// initialize LED output
	initLED();
	/*
	// try to connect to the wifi and start the control server
	if (!initWebserver(networkCredentials))
		Serial.println("Connecting to WiFi failed...");
	else
		Serial.println("Successfully connected to WiFi.");
	

	Serial.print("Setup finished on core ");
	Serial.print(xPortGetCoreID());
	Serial.println();

	// initialize second core
	Serial.println("Starting second thread");
	createSemaphore();
	xTaskCreatePinnedToCore(
		loop2,		  		// Task function
		"loop2_task", 		// name of task
		10000,		  		// Stack size of task
		NULL,		  		// parameter of the task
		1,  				// priority of the task		// tskIDLE_PRIORITY
		&loop2_task,  		// Task handle to keep track of created task
		0);			  		// pin task to core 0 or 1 (1 is the main core)*/
}

void loop()
{
	

	/*
	if(input_available){
		parseInputMessage();
		input_available = false;
	}
	
	if(fft_result_available)
	{
		lockSemaphore();
		processFFT();
		fft_result_available = false;		
		unlockSemaphore();
	}

	checkLEDsUpdateRequest();*/

	testRGB();
		
	vTaskDelay(5);
}

void loop2(void *pvParameters)
{
	while (1)
	{
		// stream to fft
		stream_fft.copy();

		// stream to headphones out
		//stream_monitor.copy();
		
		//vTaskDelay(1);
	}
}