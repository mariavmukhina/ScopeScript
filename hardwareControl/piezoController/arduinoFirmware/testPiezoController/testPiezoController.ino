 int value;
int state;
int incr;
void setup(){
  //setupSerialInterface();
  setupLCD();
  setupDac();
  //setupPiezo();
  setupLights();
  //setupInterrupt();
  setupLEDs();
  //fillUpArrays();
  value = 0;
  state = 0;
  PORTF = B01111111;
  Serial1.print(F("testingMode"));
}

void loop(){
  write2Dac(value);
  value = value + 1;
  turnOffAllLEDs();
  if (value > 1 && value < 3000){
    turnOnRedLED();
  }
  
  if (value > 3000 && value < 6000){
    turnOnGreenLED();
  }
  
  if (value > 6000 && value < 9000){
    turnOnYellowLED();
  }
}


