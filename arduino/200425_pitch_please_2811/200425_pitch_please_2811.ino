// designed to work with WS2811 12V LED strip
#include "FastLED.h"
#define NUM_STRIPS 2
#define NUM_LEDS 38
#define NUM_LED_TOTAL NUM_STRIPS * NUM_LEDS

#define NUM_LEDS_RECEIVE 10 // since the patterns are symmetrical, only receiving half of the data

#define DATA_PIN_0 2
#define DATA_PIN_1 3

CRGB leds[NUM_STRIPS][NUM_LEDS];

// monitoring
static float          fpsNow      = 0;
static float          fpsAvg      = 0;
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

void setup() {
  Serial.begin(57600);

  // setup LED strips
  FastLED.addLeds<WS2811, DATA_PIN_0>(leds[0], NUM_LEDS);
  FastLED.addLeds<WS2811, DATA_PIN_1>(leds[1], NUM_LEDS);

  testRGB(); 

  for(int i = 0; i < incomingColorBufferSize; i++) incomingColorBuffer[i] = 0;
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
    
    FastLED.show();  
    incomingColorBuffer[incomingColorBufferSize - 1] = 0;

    LEDWriteEnd = micros();
    processFps();
  }  
}

void processFps(){
  timeNow = millis();
  
  if(timeNow - timeLF > 0){
    fpsNow = 1000.0 / (timeNow - timeLF);
    fpsAvg = (0.99 * fpsAvg) + (0.01 * fpsNow);
  }
  
  if(fpsLastMsg + fpsInterval <= timeNow){
    Serial.print("fps ");
    Serial.print(fpsAvg);
    fpsLastMsg += fpsInterval;

    Serial.print("/ LED ");
    Serial.println(LEDWriteEnd - LEDWriteStart);
  }

  timeLF = timeNow;
}

void loop() {
  //testRGB(); // for debugging hardware problems
  
  processIncoming();
  updateLEDs();  
}
