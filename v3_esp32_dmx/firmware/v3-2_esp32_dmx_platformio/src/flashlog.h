// Mini log in the ESP32's internal flash (LittleFS on the 1.4 MB "spiffs" data partition).
//
// Lines survive power-off and firmware updates over USB, so measurements taken while the LEDs are
// powered (no USB allowed then) can be read back later with USB only. Each line starts with the
// boot number and the seconds since that boot: "#12 t=345 dmx lost".
//
// Two files of up to FLASHLOG_MAX_BYTES each (log.txt, rotated to log.1.txt), so the log never
// grows past ~128 KB. Writing is open-append-close per line: safe against power loss, but slow
// (milliseconds) -- never log per frame, only events and periodic summaries.
//
// Over USB serial (115200): the last lines are printed at boot; then send
//   l = whole log   t = last 40 lines   c = clear   h = help
#pragma once

#include <Arduino.h>

#define FLASHLOG_MAX_BYTES (64 * 1024)

void flashLogBegin();                        // mount (formats the partition on first use), count the boot
void flashLog(const char *fmt, ...);         // append one line (thread-safe; not from an ISR)
void flashLogPrint(size_t lastLines = 0);    // print over Serial; 0 = everything
void flashLogClear();
uint32_t flashLogBootCount();
void flashLogSerialCommands();               // call from loop()
