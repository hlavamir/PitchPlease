#include <WiFi.h>
#include <esp_bt.h>

#include <dmx.h>

#define FASTLED_ALLOW_INTERRUPTS 1     // allow the RMT refill ISR to run so it can't starve mid-strip
#define FASTLED_ESP32_RMT 1
#define FASTLED_RMT_BUILTIN_DRIVER 1   // buffer the whole frame in the RMT driver, removes mid-frame ISR underruns
#include <FastLED.h>


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

const uint8_t TARGET_FPS = 30;

const float GAMMA = 2.2;

// DMX
const uint16_t DMX_START_CHANNEL = 100;

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

portMUX_TYPE mux = portMUX_INITIALIZER_UNLOCKED;

// for monitoring stack heap
UBaseType_t uxHighWaterMark;

uint32_t frameCounter = 0;

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
  xTaskCreatePinnedToCore(loopLED_Task, "FastLED_Task", 4096, NULL, 1, NULL, LED_CORE);
}

void loop(){
  //Serial.println("loop");
  //delay(1); 
}

void loopLED_Task(void *pvParameters){
  TickType_t xLastWakeTime = xTaskGetTickCount();
  const TickType_t xFrequency = 1000 / (TARGET_FPS * portTICK_PERIOD_MS);

  // run LED loop at fixed framerate
  while(true){
    // Update LED logic here
    //Serial.println("LED loop");
    frameUpdateLED();

    // Wait until the next cycle
    vTaskDelayUntil(&xLastWakeTime, xFrequency);
  }
}

void frameUpdateLED(){
  //Serial.print(millis());
  //Serial.print(" LED loop frame");
  //Serial.println();
  
  SyncLEDWithDMX();  
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


void setLED(int id, byte r, byte g, byte b){
  stripCrr = id / NUM_LEDS;
  LEDCrr = id % NUM_LEDS;   

  leds_work[stripCrr][LEDCrr] = CRGB(b, r, g);   
}

void setLED(int strip, int id, byte r, byte g, byte b){
  leds_work[strip][id] = CRGB(b, r, g);
}

void setLED(int strip, int id, float r, float g, float b, float dimmer, bool applyGamma){
  r *= dimmer;
  g *= dimmer;
  b *= dimmer;

  if(applyGamma){
    r = pow(r, GAMMA);
    g = pow(g, GAMMA);
    b = pow(b, GAMMA);
  }

  setLED(strip, id, r * 255, g * 255, b * 255);
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
  FastLED.show();
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

void OnDMXInput(uint16_t channel, uint8_t value){
  //Serial.print("dmx in on core ");
  //Serial.println(xPortGetCoreID());

  if(channel >= DMX_START_CHANNEL && channel < DMX_START_CHANNEL + DMX_CHANNELS_TOTAL){
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