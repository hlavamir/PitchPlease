// designed to work with WS2811 12V LED strip
#include "FastLED.h"
#define NUM_STRIPS 2
#define NUM_LEDS 38
#define NUM_LED_TOTAL NUM_STRIPS * NUM_LEDS

#define NUM_LEDS_RECEIVE 10 // since the patterns are symmetrical, only receiving half of the data

#define DATA_PIN_0 9
#define DATA_PIN_1 10
#define DATA_PIN_2 11
#define DATA_PIN_3 12

CRGB leds[NUM_STRIPS][NUM_LEDS];

// monitoring
static float          fpsNow                = 0;
static float          fpsAvg                = 0;

static float          calculatedCurrent     = 0;
static float          maxCalculatedCurrent  = 0;

static unsigned long  timeNow     = 0;
static unsigned long  timeLF      = 0;
static unsigned long  LEDWriteStart = 0;
static unsigned long  LEDWriteEnd   = 0;

static unsigned long  fpsLastMsg  = 0;
static int            fpsInterval = 2000;

// set LED variables
static int stripCrr = 0;
static int LEDCrr   = 0;
static int modeCrr  = 0;

#define incomingColorBufferSize (NUM_STRIPS * NUM_LEDS_RECEIVE * 3) + 2 // +2 is mode switch byte and a confirmation byte (255)
static byte incomingColorBuffer[incomingColorBufferSize];
static int  incomingColorPos = 0;

static unsigned long incomingLastTime = 0;

// standalone mode variables
static float idleHue[2];
static float idleHueOffset = 0.1;

static int idleSaturation = 192;
static int idleBrightness = 255;
static int idlePeriod = 600; // seconds

void setup() {
  Serial.begin(57600);

  // setup LED strips
  FastLED.addLeds<WS2811, DATA_PIN_0>(leds[0], NUM_LEDS);
  FastLED.addLeds<WS2811, DATA_PIN_1>(leds[1], NUM_LEDS);
  FastLED.addLeds<WS2811, DATA_PIN_2>(leds[1], NUM_LEDS);
  FastLED.addLeds<WS2811, DATA_PIN_3>(leds[0], NUM_LEDS);

  testRGB(); 

  for(int i = 0; i < incomingColorBufferSize; i++) incomingColorBuffer[i] = 0;

  idleHue[0] = 0;
  idleHue[1] = idleHueOffset;
}

void testRGB(){
  for(int i = 0; i < NUM_STRIPS * NUM_LEDS_RECEIVE; i++) setLED(i, 255,   0,   0);
  FastLED.show(); 
  delay(1000);

  for(int i = 0; i < NUM_STRIPS * NUM_LEDS_RECEIVE; i++) setLED(i,   0, 255,   0);
  FastLED.show(); 
  delay(1000);

  for(int i = 0; i < NUM_STRIPS * NUM_LEDS_RECEIVE; i++) setLED(i,   0,   0, 255);
  FastLED.show(); 
  delay(1000);

  for(int i = 0; i < NUM_STRIPS * NUM_LEDS_RECEIVE; i++) setLED(i,   0,   0,   0);
  FastLED.show(); 
}

void processIncoming(){
  while(Serial.available() > 0){
    incomingLastTime = timeNow;
    incomingColorBuffer[incomingColorPos] = byte(Serial.read());

    if(incomingColorBuffer[incomingColorPos] == 255){
      incomingColorPos = 0;
    } else {    
      incomingColorPos++;
      if(incomingColorPos >= incomingColorBufferSize){ 
        incomingColorPos = 0;
      }
    }
  }
}

void outputLED(){
  // calculate power consumption
  calculatedCurrent = 0;
  for(int stripCrr = 0; stripCrr < NUM_STRIPS; stripCrr++){
    for(int LEDCrr = 0; LEDCrr < NUM_LEDS; LEDCrr++){
      calculatedCurrent += leds[stripCrr][LEDCrr].r;
      calculatedCurrent += leds[stripCrr][LEDCrr].g;
      calculatedCurrent += leds[stripCrr][LEDCrr].b;
    } 
  }

  calculatedCurrent = (calculatedCurrent / 255) * (3 * 0.1 / 12); // 12 V strip using 0.1 w per LED, 3 LEDs per segment
  maxCalculatedCurrent = max(maxCalculatedCurrent, calculatedCurrent);

  FastLED.show(); 
}

void setLED(int id, int r, int g, int b){
  if(modeCrr == 1){
    for(stripCrr = 0; stripCrr < NUM_STRIPS; stripCrr++){
      leds[stripCrr][id] = CRGB(b, r, g);
      leds[stripCrr][NUM_LEDS - id - 1] = leds[stripCrr][id];  
    }    
  } else {
    stripCrr = floor(float(id) / NUM_LEDS_RECEIVE);
    LEDCrr = id % NUM_LEDS_RECEIVE;   

    // double symmetry pattern
    leds[stripCrr][LEDCrr] = CRGB(b, r, g);  
    leds[stripCrr][(NUM_LEDS / 2) - LEDCrr - 1] = leds[stripCrr][LEDCrr];
    leds[stripCrr][(NUM_LEDS / 2) + LEDCrr] = leds[stripCrr][LEDCrr];
    leds[stripCrr][NUM_LEDS - LEDCrr - 1] = leds[stripCrr][LEDCrr];
  }
}

/*void setLED(){
  stripCrr = floor(float(id) / NUM_LEDS);
  LEDCrr = id % NUM_LEDS;

  leds[stripCrr][LEDCrr] = CRGB(b, r, g);  
}*/

void setLEDs(){
  for(int i = 0; i < NUM_STRIPS * NUM_LEDS_RECEIVE; i++){
    //stripCrr = floor(float(i) / NUM_LEDS_RECEIVE);
    //LEDCrr = i % NUM_LEDS_RECEIVE;  

    setLED(i, incomingColorBuffer[i * 3], incomingColorBuffer[(i * 3) + 1], incomingColorBuffer[(i * 3) + 2]);
  }
}

void updateLEDs(){
  if(incomingColorBuffer[incomingColorBufferSize - 1] == 255){    
    LEDWriteStart = micros();

    modeCrr = incomingColorBuffer[incomingColorBufferSize - 2];
    setLEDs();
    
    outputLED();
    incomingColorBuffer[incomingColorBufferSize - 1] = 0;

    LEDWriteEnd = micros();
    
  }  
}

void processFps(){  
  if(timeNow - timeLF > 0){
    fpsNow = 1000.0 / (timeNow - timeLF);
    fpsAvg = (0.99 * fpsAvg) + (0.01 * fpsNow);
  }
  
  if(fpsLastMsg + fpsInterval <= timeNow){
    Serial.print("fps ");
    Serial.print(fpsAvg);
    fpsLastMsg += fpsInterval;

    Serial.print("/ LED ");
    Serial.print(LEDWriteEnd - LEDWriteStart);

    Serial.print("/ Current ");
    Serial.println(maxCalculatedCurrent);

    maxCalculatedCurrent = 0;
  }
}

void standaloneBehaviour(){
  idleHue[0] = (idleHue[0] / 255) + (((timeNow - timeLF) / 1000.0) / idlePeriod);
  idleHue[1] = idleHue[0] + idleHueOffset;

  for(int i = 0; i < NUM_STRIPS; i++){
    if(idleHue[i] >= 1) idleHue[i] -= 1;

    idleHue[i] *= 255;
    
    for(int j = 0; j < NUM_LEDS; j++){
      leds[i][j] = CHSV(idleHue[i],  idleSaturation, idleBrightness);
    }
  }

  outputLED(); 
}

void loop() {
  timeNow = millis();
  
  //testRGB(); // for debugging hardware problems
  
  processIncoming();
  updateLEDs();  
  

  if(timeNow - incomingLastTime >= 10000 || incomingLastTime == 0){
    standaloneBehaviour();
  }

  processFps();
  timeLF = timeNow;
}
