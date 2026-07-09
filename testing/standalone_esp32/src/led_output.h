#define FASTLED_INTERRUPT_RETRY_COUNT 0
#define FASTLED_ALLOW_INTERRUPTS 0

#include "FastLED.h"

#define LEDs_PER_STRIP 19
#define LED_NUM_STRIPS 4

#define LED_PIN_0 21
#define LED_PIN_1 22
#define LED_PIN_2 19
#define LED_PIN_3 23

bool ledUpdateRequested = false;

CRGB leds[LED_NUM_STRIPS][LEDs_PER_STRIP * 2];

void updateLEDs(){
    FastLED.show();
    ledUpdateRequested = false;
}

bool checkLEDsUpdateRequest(){
    if(ledUpdateRequested){
        updateLEDs();
        return true;
    }

    return false;
}

void setLED(uint8_t strip_id, uint8_t led_id, CRGB color){
    leds[strip_id][led_id] = color; 
    leds[strip_id][LEDs_PER_STRIP - led_id - 1] = color;  
    ledUpdateRequested = true;
}

void setLEDStrip(uint8_t strip_id, CRGB color){
    for(uint8_t led_id = 0; led_id < LEDs_PER_STRIP; led_id++) setLED(strip_id, led_id, color);
}

void setLEDStrips(CRGB color){
    for(uint8_t strip_id = 0; strip_id < LED_NUM_STRIPS; strip_id++) setLEDStrip(strip_id, color);
}

void testRGB(){
    setLEDStrips(0xFF0000);    FastLED.show();     delay(1000);     // red    
    setLEDStrips(0x00FF00);    FastLED.show();     delay(1000);     // green
    setLEDStrips(0x0000FF);    FastLED.show();     delay(1000);     // blue
    setLEDStrips(0x000000);    FastLED.show();                      // off
}

void initLED(){
    FastLED.addLeds<WS2811, LED_PIN_0>(leds[0], LEDs_PER_STRIP * 2);
    FastLED.addLeds<WS2811, LED_PIN_1>(leds[1], LEDs_PER_STRIP * 2);
    FastLED.addLeds<WS2811, LED_PIN_2>(leds[2], LEDs_PER_STRIP * 2);
    FastLED.addLeds<WS2811, LED_PIN_3>(leds[3], LEDs_PER_STRIP * 2);

    testRGB(); 
}