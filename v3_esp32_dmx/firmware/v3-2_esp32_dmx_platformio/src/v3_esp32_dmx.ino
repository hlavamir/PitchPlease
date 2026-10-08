#include <WiFi.h>
#include <esp_bt.h>

#include <dmx.h>
#include <esp_system.h>
#include "flashlog.h"

#define FASTLED_ALLOW_INTERRUPTS 1     // allow the RMT refill ISR to run so it can't starve mid-strip
#define FASTLED_ESP32_RMT 1
#define FASTLED_RMT_BUILTIN_DRIVER 1   // buffer the whole frame in the RMT driver, removes mid-frame ISR underruns
#include <FastLED.h>


// Measurement build: at boot, time FastLED.show() for 3 s with FastLED's 400 Hz cap and 3 s
// without it, write the results to the flash log, and show the uncapped rate as a green bar for
// 5 s (one lit pixel per 50 Hz). Off in the normal firmware.
#ifndef MEASURE_REFRESH
#define MEASURE_REFRESH 0
#endif

// LEDs
#define LED_CORE 1

const uint8_t PSU_VOLTS = 12;
const uint32_t PSU_MILLIAMPS = 10000;

const uint8_t NUM_STRIPS = 4;
const uint8_t NUM_LEDS = 24;
const uint16_t NUM_LEDS_TOTAL = NUM_STRIPS * NUM_LEDS;

const uint8_t DATA_PIN_0 = 27 /*14*/;
const uint8_t DATA_PIN_1 = 26 /*27*/;
const uint8_t DATA_PIN_2 = 19 /*26*/;
const uint8_t DATA_PIN_3 = 21 /*25*/;

const float GAMMA = 2.2;

// Idle "breathing" animation (runs until the first DMX frame arrives)
const uint16_t IDLE_ANIM_PERIOD_MS = 8000;  // full breathe cycle length
const uint8_t  IDLE_ANIM_FPS = 50;          // idle animation refresh rate
const float    IDLE_ANIM_MIN_LEVEL = 0.10;  // floor so the breathe never fully dims

// DMX
// Set per device at flash time via -DDMX_START_CHANNEL_VALUE (firmware-flasher.command); 100 is the default
#ifndef DMX_START_CHANNEL_VALUE
#define DMX_START_CHANNEL_VALUE 100
#endif
const uint16_t DMX_START_CHANNEL = DMX_START_CHANNEL_VALUE;

const uint16_t DMX_HEADER_CHANNELS = NUM_STRIPS + 2; // master dimmer, mode, 1 dimmer per strip

const uint16_t DMX_GROUP_A_CHANNELS = NUM_LEDS * 3;
const uint16_t DMX_GROUP_B_CHANNELS = 3;

const uint16_t DMX_CHANNELS_TOTAL = DMX_HEADER_CHANNELS + DMX_GROUP_A_CHANNELS + DMX_GROUP_B_CHANNELS;

const uint16_t DMX_MODE_CHANNEL = DMX_START_CHANNEL + 1;

//CRGB leds[NUM_STRIPS][NUM_LEDS];
CRGB leds_A[NUM_STRIPS][NUM_LEDS];
CRGB leds_B[NUM_STRIPS][NUM_LEDS];

CRGB (*leds)[NUM_LEDS]      = leds_A;
CRGB (*leds_work)[NUM_LEDS] = leds_B;
CRGB (*leds_swp)[NUM_LEDS]  = leds_B;

int stripCrr = 0;
int LEDCrr   = 0;

DMX dmx_in;
bool dmxValid = false;
uint16_t dmxLocalizedChannel = 0;
uint8_t dmxMode = 0;
float dmxDimmerMaster = 1;
float dmxDimmers[NUM_STRIPS] = {1};
float dmxBufferGroupA[DMX_GROUP_A_CHANNELS] = {0};
float dmxBufferGroupB[DMX_GROUP_B_CHANNELS] = {0};

SemaphoreHandle_t sync_DMX_LED_Buffers;

// handle to the LED task so the DMX task can wake it when a frame completes
TaskHandle_t ledTaskHandle = NULL;

// set true when a DMX value inside our channel block changes; the LED task is
// only woken on frame completion if something actually changed. Touched only
// from the DMX task (OnDMXInput sets, OnDMXFrameComplete clears), so no lock.
bool dmxFrameDirty = false;

// latched true on the first received DMX frame; once set, the idle breathing
// animation is replaced for good by DMX-driven output. Written by the DMX task,
// read by the LED task, so volatile for cross-core visibility.
volatile bool dmxActive = false;

void idleAnimationFrame();   // forward decl (used by loopLED_Task)

portMUX_TYPE mux = portMUX_INITIALIZER_UNLOCKED;

// for monitoring stack heap
UBaseType_t uxHighWaterMark;

uint32_t frameCounter = 0;

// monitoring for the flash log (heartbeat every HEARTBEAT_MS, DMX loss / return)
const uint32_t HEARTBEAT_MS = 10UL * 60UL * 1000UL;
const uint32_t DMX_LOST_MS = 2000;
volatile uint32_t dmxFramesTotal = 0;   // every completed DMX frame (DMX task)
uint32_t showMicrosSum = 0, showMicrosMax = 0, showCount = 0;   // FastLED.show() (LED task)
uint32_t syncMicrosSum = 0, syncMicrosMax = 0;                  // DMX -> pixels incl. gamma (LED task)

const char *resetReasonText(){
  switch(esp_reset_reason()){
    case ESP_RST_POWERON:  return "power on";
    case ESP_RST_SW:       return "software restart";
    case ESP_RST_PANIC:    return "crash (panic)";
    case ESP_RST_INT_WDT:  return "interrupt watchdog";
    case ESP_RST_TASK_WDT: return "task watchdog";
    case ESP_RST_WDT:      return "other watchdog";
    case ESP_RST_BROWNOUT: return "brownout (supply voltage dropped)";
    case ESP_RST_EXT:      return "external reset pin";
    case ESP_RST_DEEPSLEEP:return "deep sleep wake";
    default:               return "unknown";
  }
}

void setup(){
  //setCpuFrequencyMhz(240);
  WiFi.mode(WIFI_OFF); // Disable WIFI
  btStop();  // Disable Bluetooth
  dmx_in.DisableDuringSetup();

  Serial.begin(115200);

  Serial.println();
  Serial.println();
  Serial.println("--- PitchPls! v3 ---");
  Serial.println();

  // mini log in flash: show the recent history, then record this boot
  flashLogBegin();
  flashLogPrint(30);
  flashLog("boot: %s, firmware %s %s, DMX start %u, free heap %u", resetReasonText(), __DATE__, __TIME__,
           (unsigned)DMX_START_CHANNEL, (unsigned)ESP.getFreeHeap());

  sync_DMX_LED_Buffers = xSemaphoreCreateMutex();

  // setup LED strips
  FastLED.addLeds<WS2811, DATA_PIN_0>(leds[0], NUM_LEDS);
  FastLED.addLeds<WS2811, DATA_PIN_1>(leds[1], NUM_LEDS);
  FastLED.addLeds<WS2811, DATA_PIN_2>(leds[2], NUM_LEDS);
  FastLED.addLeds<WS2811, DATA_PIN_3>(leds[3], NUM_LEDS);

  //FastLED.setMaxPowerInVoltsAndMilliamps(PSU_VOLTS, PSU_MILLIAMPS); // Adjust as per your PSU
  FastLED.setBrightness(255);

  testRGB();
  
  // setup DMX
  Serial.println("Initializing DMX");
  dmx_in.Initialize(input);
/*
  if(dmx_in.IsHealthy()){
    //Serial.println("DMX in -> OK");
    dmxValid = true;
  } else {
    //Serial.println("DMX in -> ERROR");
    dmxValid = false;
  }*/ 

  // create and pin LED loop to core 1
  Serial.println("Starting LED loop");
  xTaskCreatePinnedToCore(loopLED_Task, "FastLED_Task", 4096, NULL, 2, &ledTaskHandle, LED_CORE);
}

void loop(){
  flashLogSerialCommands();   // l / t / c / h over USB serial
  delay(20);
}

// once per pass of the LED task: DMX loss / return and the periodic heartbeat
void monitorForLog(){
  static uint32_t lastFrames = 0, lastFrameChange = 0, lastHeartbeat = 0, heartbeatFrames = 0, heartbeatRenders = 0;
  static bool seenDmx = false, lost = false;
  uint32_t now = millis();
  uint32_t frames = dmxFramesTotal;

  if(frames != lastFrames){
    if(!seenDmx){
      seenDmx = true;
      flashLog("dmx: first frame after %lu s", (unsigned long)(now / 1000));
    } else if(lost){
      lost = false;
      flashLog("dmx back after %lu s without frames", (unsigned long)((now - lastFrameChange) / 1000));
    }
    lastFrames = frames;
    lastFrameChange = now;
  } else if(seenDmx && !lost && now - lastFrameChange > DMX_LOST_MS){
    lost = true;
    flashLog("dmx lost (no frame for %lu ms)", (unsigned long)DMX_LOST_MS);
  }

  if(now - lastHeartbeat >= HEARTBEAT_MS){
    float minutes = (now - lastHeartbeat) / 60000.0f;
    float seconds = minutes * 60.0f;
    uint32_t renders = frameCounter - heartbeatRenders;
    flashLog("alive %lu min: dmx %.1f fps, redraws %.1f/s, show %lu us avg / %lu max, render %lu us avg / %lu max",
             (unsigned long)(now / 60000), (frames - heartbeatFrames) / seconds, renders / seconds,
             (unsigned long)(showCount ? showMicrosSum / showCount : 0), (unsigned long)showMicrosMax,
             (unsigned long)(renders ? syncMicrosSum / renders : 0), (unsigned long)syncMicrosMax);
    lastHeartbeat = now;
    heartbeatFrames = frames;
    heartbeatRenders = frameCounter;
    showMicrosSum = showMicrosMax = showCount = syncMicrosSum = syncMicrosMax = 0;
  }
}

#if MEASURE_REFRESH
// FastLED.show() back to back for `ms`; returns the number of shows, the slowest one in maxUs
uint32_t runShows(uint32_t ms, uint32_t &maxUs){
  uint32_t count = 0;
  maxUs = 0;
  uint32_t start = millis();
  while(millis() - start < ms){
    uint32_t t0 = micros();
    FastLED.show();
    uint32_t dt = micros() - t0;
    if(dt > maxUs) maxUs = dt;
    count++;
  }
  return count;
}

void measureRefresh(){
  // dark frame: the WS2811 timing doesn't depend on the colours
  for(int i = 0; i < NUM_LEDS_TOTAL; i++) setLED(i, 0, 0, 0);
  outputLED();

  const uint32_t MS = 3000;
  uint32_t framesBefore = dmxFramesTotal;
  uint32_t maxCapped, maxFree;
  uint32_t capped = runShows(MS, maxCapped);   // FastLED's own cap for the ESP32 RMT driver (400 Hz)
  FastLED.setMaxRefreshRate(0, false);         // no cap
  uint32_t uncapped = runShows(MS, maxFree);
  FastLED.setMaxRefreshRate(400, false);       // back to the driver default
  float hzCapped = capped * 1000.0f / MS, hzFree = uncapped * 1000.0f / MS;
  flashLog("measure: show() with FastLED cap %.0f Hz (slowest %lu us), uncapped %.0f Hz (slowest %lu us); %u strips x %u LEDs; DMX %s during the test",
           hzCapped, (unsigned long)maxCapped, hzFree, (unsigned long)maxFree, (unsigned)NUM_STRIPS, (unsigned)NUM_LEDS,
           dmxFramesTotal != framesBefore ? "running" : "not connected");

  // the uncapped rate as a green bar on every strip: one lit pixel per 50 Hz, for 5 s
  int lit = min((int)NUM_LEDS, (int)(hzFree / 50.0f + 0.5f));
  for(int strip = 0; strip < NUM_STRIPS; strip++){
    for(int i = 0; i < NUM_LEDS; i++){
      setLED(strip, i, (byte)0, (byte)(i < lit ? 80 : 0), (byte)0);
    }
  }
  outputLED();
  delay(5000);
}
#endif

void loopLED_Task(void *pvParameters){
  // Before any DMX is seen we play the idle breathing animation as a liveness
  // indicator. The first DMX frame latches dmxActive (see OnDMXFrameComplete)
  // and from then on output is driven by the DMX frame rate: one render per
  // completed (changed) frame, with a slow fallback refresh as a heartbeat /
  // self-heal so a stale or corrupted frame can't stick forever.
  const TickType_t idleRefresh = pdMS_TO_TICKS(1000);
  const TickType_t animFrame   = pdMS_TO_TICKS(1000 / IDLE_ANIM_FPS);

#if MEASURE_REFRESH
  measureRefresh();
#endif

  while(true){
    monitorForLog();
    if(dmxActive){
      // DMX is driving: wake on each completed frame, fall back occasionally
      ulTaskNotifyTake(pdTRUE, idleRefresh);
      frameUpdateLED();
    } else {
      // No DMX yet: render the breathing animation at a smooth rate, but wake
      // immediately if a DMX frame arrives so we can hand over without delay
      if(ulTaskNotifyTake(pdTRUE, animFrame) > 0){
        frameUpdateLED();      // first DMX frame just arrived; show it now
      } else {
        idleAnimationFrame();  // timeout: draw the next breathing frame
      }
    }
  }
}

void frameUpdateLED(){
  //Serial.print(millis());
  //Serial.print(" LED loop frame");
  //Serial.println();
  
  uint32_t t0 = micros();
  SyncLEDWithDMX();  
  uint32_t dt = micros() - t0;
  syncMicrosSum += dt;
  if(dt > syncMicrosMax) syncMicrosMax = dt;
  delayMicroseconds(50);   

  outputLED();
  delayMicroseconds(50);   

  frameCounter++;

  if(frameCounter % 300 == 0){ 
    //testFreeze();
    Serial.print("Still alive... ");  
    Serial.println(frameCounter);

    uxHighWaterMark = uxTaskGetStackHighWaterMark(NULL); 
    Serial.println(uxHighWaterMark); // Minimum free stack words left
  }

  //printTaskInfo();  
}

void testFreeze(){
  for(int i = 0; i < NUM_LEDS_TOTAL; i++) setLED(i, 0, 255, 0); 
  outputLED();
  delay(250);
}

void testRGB(){
  Serial.println("Testing RED");
  for(int i = 0; i < NUM_LEDS_TOTAL; i++) setLED(i, 255,   0,   0);
  //FastLED.show(); 
  outputLED();
  delay(1000);

  Serial.println("Testing GREEN");
  for(int i = 0; i < NUM_LEDS_TOTAL; i++) setLED(i,   0, 255,   0);
  //FastLED.show(); 
  outputLED();
  delay(1000);

  Serial.println("Testing BLUE");
  for(int i = 0; i < NUM_LEDS_TOTAL; i++) setLED(i,   0,   0, 255);
  //FastLED.show(); 
  outputLED();
  delay(1000);

  Serial.println("RGB test finished");
  for(int i = 0; i < NUM_LEDS_TOTAL; i++) setLED(i,   0,   0,   0);
  //FastLED.show(); 
  outputLED();
}


// breathing pure red driven by a sine, full cycle every IDLE_ANIM_PERIOD_MS.
// runs only until the first DMX frame arrives (see loopLED_Task).
void idleAnimationFrame(){
  float phase = (millis() % IDLE_ANIM_PERIOD_MS) / (float)IDLE_ANIM_PERIOD_MS; // 0..1
  // (1 - cos)/2 gives a smooth 0..1..0 breathe that starts dark
  float level = (1.0f - cosf(2.0f * PI * phase)) * 0.5f;
  // gamma-correct so the breathe is perceptually even, matching the DMX path,
  // then lift the floor so it never reaches the steppy bottom few PWM steps
  float out = powf(level, GAMMA);
  out = IDLE_ANIM_MIN_LEVEL + (1.0f - IDLE_ANIM_MIN_LEVEL) * out;
  uint8_t r = (uint8_t)(out * 255.0f + 0.5f);

  for(int i = 0; i < NUM_LEDS_TOTAL; i++){
    setLED(i, r, 0, 0);   // pure red, same channel mapping as testRGB
  }
  outputLED();
}

void setLED(int id, byte r, byte g, byte b){
  stripCrr = id / NUM_LEDS;
  LEDCrr = id % NUM_LEDS;   

  leds_work[stripCrr][LEDCrr] = CRGB(b, r, g);   
}

void setLED(int strip, int id, byte r, byte g, byte b){
  leds_work[strip][id] = CRGB(b, r, g);
}

// DMX values are perceptual (equal steps look like equal brightness steps, as sent by PitchControl);
// the LEDs dim by PWM duty, so each channel is decoded with GAMMA after the dimmers are applied.
void setLED(int strip, int id, float r, float g, float b, float dimmer, bool applyGamma){
  r *= dimmer;
  g *= dimmer;
  b *= dimmer;

  if(applyGamma){
    r = powf(r, GAMMA);
    g = powf(g, GAMMA);
    b = powf(b, GAMMA);
  }

  // round, not truncate: truncating darkened every value and cut off more of the dark end
  setLED(strip, id, (byte)(r * 255.0f + 0.5f), (byte)(g * 255.0f + 0.5f), (byte)(b * 255.0f + 0.5f));
}

void outputLED(){
  xSemaphoreTake(sync_DMX_LED_Buffers, portMAX_DELAY);  

  // enter critical mode to block other tasks while outputing LEDs
  //portENTER_CRITICAL(&mux);  

  // swap working and outputing buffers
  /*leds_swp = leds_work;
  leds_work = leds;
  leds = leds_swp;*/

  // manually copy the buffer instead of just swapping pointers
  for(int i = 0; i < NUM_STRIPS; i++){
    for(int j = 0; j < NUM_LEDS; j++){
      leds[i][j] = leds_work[i][j];
      //leds[i][j].r = (leds[i][j].r / 2) + (leds_work[i][j].r / 2);
      //leds[i][j].g = (leds[i][j].g / 2) + (leds_work[i][j].g / 2);
      //leds[i][j].b = (leds[i][j].b / 2) + (leds_work[i][j].b / 2);
    }
  }

  //portEXIT_CRITICAL(&mux);  
  xSemaphoreGive(sync_DMX_LED_Buffers);

  // output LEDs
  uint32_t t0 = micros();
  FastLED.show();
  uint32_t dt = micros() - t0;
  showMicrosSum += dt;
  showCount++;
  if(dt > showMicrosMax) showMicrosMax = dt;
}

void SyncLEDWithDMX(){
  for(int strip = 0; strip < NUM_STRIPS; strip++){
    // by default dmxMode is 0, following will write any strip with index lass than dmxMode into the B group
    // higher dmxMode value will switch more strips into the B group

    if(strip < dmxMode){      
      // group B strips behaviour comes here
      xSemaphoreTake(sync_DMX_LED_Buffers, portMAX_DELAY);  
      setLED(strip, 0, dmxBufferGroupB[0], dmxBufferGroupB[1], dmxBufferGroupB[2], dmxDimmers[strip] * dmxDimmerMaster, true);
      xSemaphoreGive(sync_DMX_LED_Buffers);

      for(int i = 1; i < NUM_LEDS; i++){ 
        leds_work[strip][i] = leds_work[strip][0];
      }

    } else {
      // group A strips behaviour comes here      
      for(int i = 0; i < NUM_LEDS; i++){
        xSemaphoreTake(sync_DMX_LED_Buffers, portMAX_DELAY);  
        setLED(strip, i, dmxBufferGroupA[i*3], dmxBufferGroupA[i*3+1], dmxBufferGroupA[i*3+2], dmxDimmers[strip] * dmxDimmerMaster, true);
        xSemaphoreGive(sync_DMX_LED_Buffers);
      }
    }
  }  
}

// called from the DMX task (core 0) once a full DMX frame has arrived;
// wake the LED task (core 1) so rendering is synced to the DMX frame rate
void OnDMXFrameComplete(){
  bool firstFrame = !dmxActive;
  dmxActive = true;   // a DMX frame arrived; leave the idle animation for good
  dmxFramesTotal++;

  // notify the LED task on the first frame (to hand over from the animation),
  // and thereafter only when an in-block channel actually changed
  if(ledTaskHandle != NULL && (firstFrame || dmxFrameDirty)){
    dmxFrameDirty = false;
    xTaskNotifyGive(ledTaskHandle);
  }
}

void OnDMXInput(uint16_t channel, uint8_t value){
  //Serial.print("dmx in on core ");
  //Serial.println(xPortGetCoreID());

  if(channel >= DMX_START_CHANNEL && channel < DMX_START_CHANNEL + DMX_CHANNELS_TOTAL){
    dmxFrameDirty = true;
    dmxLocalizedChannel = channel - DMX_START_CHANNEL;

    xSemaphoreTake(sync_DMX_LED_Buffers, portMAX_DELAY);
    if(dmxLocalizedChannel == 0){
      // master dimmer change
      dmxDimmerMaster = value / 255.0;         
          
    } else if(dmxLocalizedChannel == 1){
      // mode change
      dmxMode = value;      

    } else if(dmxLocalizedChannel >= 2 && dmxLocalizedChannel < 2 + NUM_STRIPS){
      // per strip dimmer change
      dmxDimmers[dmxLocalizedChannel - 2] = value / 255.0;         

    } else if(dmxLocalizedChannel >= DMX_HEADER_CHANNELS + DMX_GROUP_A_CHANNELS){
      // data group B change
      dmxBufferGroupB[dmxLocalizedChannel - DMX_HEADER_CHANNELS - DMX_GROUP_A_CHANNELS] = value / 255.0;
    
    //} else if(dmxLocalizedChannel >= DMX_HEADER_CHANNELS && dmxLocalizedChannel < DMX_HEADER_CHANNELS + DMX_GROUP_A_CHANNELS){
    } else {
      // data group A change
      dmxBufferGroupA[dmxLocalizedChannel - DMX_HEADER_CHANNELS] = value / 255.0; 
    }

    xSemaphoreGive(sync_DMX_LED_Buffers); 
  }  
  
  /*
  Serial.print("On data channel ");
  Serial.print(channel);
  Serial.print(" val ");
  Serial.print(value);
  Serial.print(" core ");
  Serial.print(xPortGetCoreID());
  Serial.println();*/  
}