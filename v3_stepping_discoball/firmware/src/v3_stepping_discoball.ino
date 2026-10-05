// PitchPls! discoball -- RAW diagnostic test (temporary)
//
// Bypasses TMCStepper/UART/AccelStepper entirely -- plain digitalWrite STEP
// pulses, one fixed direction. Purpose: isolate whether the motor "clicks in
// place instead of spinning" symptom is a basic STEP/DIR/EN/motor/power wiring
// problem, independent of UART (known NOT RESPONDING -- see wiki/discoball.md
// and the chat log for the full debugging history).
//
// The driver runs on its power-on-default config here (no current/microstep
// setup applied via software), which is fine for this test -- TMC2209 works
// as a plain STEP/DIR/EN driver with zero UART involvement, same as an A4988.
// MS1/MS2 are wired to GND/GND on the board itself (the only combination of
// the 4 that produced any movement when tested) -- empirically ~16 microsteps
// per full step, confirmed via a slow one-pulse-every-2s test that clicked a
// dominant step every ~16 pulses, insensitive to the current-limit trimpot.
//
// At continuous ~100 steps/sec this produced a periodic "there and back"
// oscillation (DIR is never touched by this code -- confirmed no software
// direction change), which is consistent with stepper motor resonance /
// mid-range instability: a real electromechanical phenomenon where certain
// step rates excite the rotor's natural oscillation, especially on a lightly
// loaded/unloaded shaft (exactly our bench-test condition right now). It's
// usually confined to a narrow speed band -- speeding up or slowing down past
// it typically clears it. So instead of one fixed rate, this sweeps through
// several speeds automatically and reports which one is active, to find
// whether there's a band where it runs clean.
//
// This REPLACES the sine-sweep motion-profile firmware for now. That version
// is backed up at dev_notes/v3_stepping_discoball.sine_sweep.ino.bak (not
// built by PlatformIO -- outside src/) and will be restored once continuous
// rotation is confirmed smooth and reliable.
//
// Wiring assumed (see wiki/discoball.md):
//   STEP -> GPIO27   DIR -> GPIO26   EN -> GPIO19 (active LOW)
//   MS1 -> GND   MS2 -> GND (on the board, not ESP32-controlled)
//   VM + motor GND -> external 12V PSU (USB alone won't power the motor)

#include <Arduino.h>

constexpr uint8_t STEP_PIN = 27;
constexpr uint8_t DIR_PIN  = 26;
constexpr uint8_t EN_PIN   = 19;   // active LOW

// Speeds to sweep through, in steps/sec -- low to high. ~5s spent at each.
constexpr uint32_t TEST_SPEEDS[] = {20, 50, 100, 200, 400, 700};
constexpr uint8_t  NUM_SPEEDS = sizeof(TEST_SPEEDS) / sizeof(TEST_SPEEDS[0]);
constexpr uint32_t SECONDS_PER_SPEED = 5;

void setup() {
  pinMode(STEP_PIN, OUTPUT);
  pinMode(DIR_PIN, OUTPUT);
  pinMode(EN_PIN, OUTPUT);

  digitalWrite(DIR_PIN, HIGH);  // pick one direction
  digitalWrite(EN_PIN, LOW);    // enable driver (active LOW)

  Serial.begin(115200);
  delay(500);
  Serial.println();
  Serial.println("--- Raw STEP/DIR test -- sweeping speeds, looking for a resonance-free band ---");
}

uint8_t  speedIndex = 0;
uint32_t speedStartedMs = 0;
bool     announced = false;

void loop() {
  uint32_t now = millis();

  if (!announced || now - speedStartedMs >= SECONDS_PER_SPEED * 1000) {
    speedIndex = announced ? (speedIndex + 1) % NUM_SPEEDS : 0;
    speedStartedMs = now;
    announced = true;
    Serial.print(">>> Now testing: ");
    Serial.print(TEST_SPEEDS[speedIndex]);
    Serial.println(" steps/sec");
  }

  digitalWrite(STEP_PIN, HIGH);
  delayMicroseconds(20);
  digitalWrite(STEP_PIN, LOW);

  uint32_t intervalUs = 1000000UL / TEST_SPEEDS[speedIndex];
  delayMicroseconds(intervalUs > 20 ? intervalUs - 20 : intervalUs);
}
