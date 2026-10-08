#include "flashlog.h"

#include <FS.h>
#include <LittleFS.h>
#include <stdarg.h>

static const char *LOG_PATH = "/log.txt";
static const char *LOG_OLD_PATH = "/log.1.txt";
static const char *BOOT_PATH = "/boot";

static SemaphoreHandle_t logMutex = NULL;
static bool mounted = false;
static uint32_t bootCount = 0;

static void rotateIfFull() {
  File f = LittleFS.open(LOG_PATH, "r");
  if (!f) return;
  size_t size = f.size();
  f.close();
  if (size < FLASHLOG_MAX_BYTES) return;
  LittleFS.remove(LOG_OLD_PATH);
  LittleFS.rename(LOG_PATH, LOG_OLD_PATH);
}

void flashLogBegin() {
  logMutex = xSemaphoreCreateMutex();
  // formatOnFail: the data partition is unformatted until the first boot with this firmware
  mounted = LittleFS.begin(true);
  if (!mounted) {
    Serial.println("flash log: cannot mount LittleFS");
    return;
  }
  File f = LittleFS.open(BOOT_PATH, "r");
  if (f) {
    bootCount = f.parseInt();
    f.close();
  }
  bootCount++;
  f = LittleFS.open(BOOT_PATH, "w");
  if (f) {
    f.print(bootCount);
    f.close();
  }
}

uint32_t flashLogBootCount() { return bootCount; }

void flashLog(const char *fmt, ...) {
  if (!mounted) return;
  char text[200];
  va_list args;
  va_start(args, fmt);
  vsnprintf(text, sizeof(text), fmt, args);
  va_end(args);

  xSemaphoreTake(logMutex, portMAX_DELAY);
  rotateIfFull();
  File f = LittleFS.open(LOG_PATH, "a");
  if (f) {
    f.printf("#%lu t=%lu %s\n", (unsigned long)bootCount, (unsigned long)(millis() / 1000), text);
    f.close();
  }
  xSemaphoreGive(logMutex);
  Serial.printf("[log] %s\n", text);
}

static size_t countLines(const char *path) {
  File f = LittleFS.open(path, "r");
  if (!f) return 0;
  size_t n = 0;
  while (f.available()) {
    if (f.read() == '\n') n++;
  }
  f.close();
  return n;
}

// print the lines of one file from line index `skip` on
static void printFile(const char *path, size_t skip) {
  File f = LittleFS.open(path, "r");
  if (!f) return;
  size_t line = 0;
  while (f.available()) {
    int c = f.read();
    if (line >= skip) Serial.write((uint8_t)c);
    if (c == '\n') line++;
  }
  f.close();
}

void flashLogPrint(size_t lastLines) {
  if (!mounted) {
    Serial.println("flash log: not mounted");
    return;
  }
  xSemaphoreTake(logMutex, portMAX_DELAY);
  size_t oldLines = countLines(LOG_OLD_PATH);
  size_t newLines = countLines(LOG_PATH);
  size_t total = oldLines + newLines;
  size_t skip = (lastLines == 0 || lastLines >= total) ? 0 : total - lastLines;
  Serial.printf("--- flash log: %u lines (%u KB used of %u KB), boot #%lu ---\n", (unsigned)total,
                (unsigned)(LittleFS.usedBytes() / 1024), (unsigned)(LittleFS.totalBytes() / 1024),
                (unsigned long)bootCount);
  if (skip < oldLines) {
    printFile(LOG_OLD_PATH, skip);
    printFile(LOG_PATH, 0);
  } else {
    printFile(LOG_PATH, skip - oldLines);
  }
  Serial.println("--- end of flash log (send h for commands) ---");
  xSemaphoreGive(logMutex);
}

void flashLogClear() {
  if (!mounted) return;
  xSemaphoreTake(logMutex, portMAX_DELAY);
  LittleFS.remove(LOG_PATH);
  LittleFS.remove(LOG_OLD_PATH);
  xSemaphoreGive(logMutex);
  Serial.println("flash log cleared");
}

void flashLogSerialCommands() {
  while (Serial.available() > 0) {
    switch (Serial.read()) {
      case 'l': flashLogPrint(0); break;
      case 't': flashLogPrint(40); break;
      case 'c': flashLogClear(); break;
      case 'h':
        Serial.println("flash log commands: l = whole log, t = last 40 lines, c = clear, h = help");
        break;
      default: break;  // ignore line endings and anything else
    }
  }
}
