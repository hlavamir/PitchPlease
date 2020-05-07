// LED
float ledCrr[6];
int ledPin[] = {3, 5, 6, 9, 10, 11};

// serial receive
int incommingBuffer[8];
int incommingBufferPos = 0;

bool receivingCC = false;

// status LED
int statusLEDPin = 8;
bool statusLED = true;

unsigned long messageLast = 0;
int messageInterval = 250;

void setup() {
  Serial.begin(57600);

  for(int i = 0; i < 6; i++)  ledCrr[i] = 0;
  
  testRGB();  
}

void testRGB(){
  analogWrite( ledPin[0], 255); analogWrite( ledPin[1],   0); analogWrite( ledPin[2],   0);
  analogWrite( ledPin[3], 255); analogWrite( ledPin[4],   0); analogWrite( ledPin[5],   0);
  delay(1000);

  analogWrite( ledPin[0],   0); analogWrite( ledPin[1], 255); analogWrite( ledPin[2],   0);
  analogWrite( ledPin[3],   0); analogWrite( ledPin[4], 255); analogWrite( ledPin[5],   0);
  delay(1000);

  analogWrite( ledPin[0],   0); analogWrite( ledPin[1],   0); analogWrite( ledPin[2], 255);
  analogWrite( ledPin[3],   0); analogWrite( ledPin[4],   0); analogWrite( ledPin[5], 255);
  delay(1000);
}

void readMsg(){  
  switch(incommingBuffer[0]){
    case 0: // set LED absolute
      float newValues[6];
      for(int i = 0; i < 6; i++){
        newValues[i] = incommingBuffer[i+1];
      }
      setLEDAbsolute(newValues);
    break;
  }
}

void processIncoming(){  
  if(Serial.available() > 0){
    bool reset = false;

    // read the incoming bytes
    incommingBuffer[incommingBufferPos] = Serial.read();

    // check if current byte is a confirmation byte
    if(incommingBuffer[incommingBufferPos] == 255){

      // check if it's at the correct position
      if(incommingBufferPos >= 7){

        // message fully arrived, process it
        readMsg();
        receivingCC = true;
      }

      // reset buffer
      reset = true;
      
    } else if(incommingBufferPos >= 7){
      // buffer is full but the last byte is not the confirmation byte -> reset buffer
      reset = true;
    }

    incommingBufferPos++;

    if(reset){
      incommingBufferPos = 0;
      
    }
  }
}

void setLEDAbsolute(float values[6]){
  bool change = false;

  if(values[0] > 127 && !statusLED){
    digitalWrite(statusLEDPin, HIGH);
    statusLED = !statusLED;
  } else if(values[0] <= 127 && statusLED){
    digitalWrite(statusLEDPin, LOW);
    statusLED = !statusLED;
  }
  
  for(int i = 0; i < 6; i++){
    //ledTar[i] = values[i];

    if(abs(ledCrr[i] - values[i]) > 0.01){
      ledCrr[i] = values[i];
      change = true;
    }
  }

  if(change){
    for(int i = 0; i < 6; i++){
      analogWrite(ledPin[i], ledCrr[i]);
    }
  }
}

void setLEDAbsoluteHsv(float hue, float saturation, float value, int ledPanel){
  hue /= 60.0;
  saturation /= 255.0;
  value /= 255.0;
    
  int h = (int)hue;
  float f = hue - h;
  float p = value * (1 - saturation);
  float q = value * (1 - f * saturation);
  float t = value * (1 - (1 - f) * saturation);

  float result[3] = {0, 0, 0};

  switch (h) {
      case 0:   result[0] = value * 255;  result[1] = t * 255;      result[2] = p * 255;        break;
      case 1:   result[0] = q * 255;      result[1] = value * 255;  result[2] = p * 255;        break;
      case 2:   result[0] = p * 255;      result[1] = value * 255;  result[2] = t * 255;        break;
      case 3:   result[0] = p * 255;      result[1] = q * 255;      result[2] = value * 255;    break;
      case 4:   result[0] = t * 255;      result[1] = p * 255;      result[2] = value * 255;    break;
      case 5:   result[0] = value * 255;  result[1] = p * 255;      result[2] = q * 25;         break;
  }

  int off = min(max(ledPanel, 0), 1) * 3;
  
  for(int i = 0; i < 3; i++){
    ledCrr[off + i] = result[i];  
    analogWrite(ledPin[off + i], ledCrr[off + i]);
  }
}

void standaloneBehaviour(){
  setLEDAbsoluteHsv(((millis() / 1000) +   0) % 360, 255, 255, 0);
  setLEDAbsoluteHsv(((millis() / 1000) +  90) % 360, 255, 255, 1);
}

void setStatusLED(){
  while(messageLast + messageInterval <= millis()){
    if(statusLED){
      digitalWrite(statusLEDPin, HIGH);
    } else {
      digitalWrite(statusLEDPin, LOW);
    }
    
    statusLED = !statusLED;
    messageLast += messageInterval;
  }
}

void loop() {
  processIncoming();

  if(!receivingCC){
    standaloneBehaviour();
  }

  //setStatusLED();
}
