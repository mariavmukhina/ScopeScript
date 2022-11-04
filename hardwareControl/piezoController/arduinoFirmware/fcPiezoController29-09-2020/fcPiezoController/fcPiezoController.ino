

void setup(){
  setupSerialInterface();
  setupLCD();
  setupDac();
  setupPiezo();
  setupLights();
  setupInterrupt();
  setupLEDs();
  fillUpArrays();
}

void loop(){
  pollSerialInterface();
}




