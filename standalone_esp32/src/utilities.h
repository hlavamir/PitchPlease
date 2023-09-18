#include "Arduino.h"

SemaphoreHandle_t xSemaphore;
void createSemaphore(){
    xSemaphore = xSemaphoreCreateMutex();
    xSemaphoreGive( ( xSemaphore) );
}

// Lock the variable indefinietly. ( wait for it to be accessible )
void lockSemaphore(){
    xSemaphoreTake(xSemaphore, 5000); // portMAX_DELAY
}

// give back the semaphore.
void unlockSemaphore(){
    xSemaphoreGive(xSemaphore);
}

float lerp(float a, float b, float t)
{
	return (a * (1 - t)) + (b * t);
}

float saturate(float a)
{
	return min(max(a, float(0)), float(1));
}