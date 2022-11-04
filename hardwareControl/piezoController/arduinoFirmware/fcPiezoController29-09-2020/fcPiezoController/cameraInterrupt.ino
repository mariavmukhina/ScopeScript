#define interruptPin 2

void setupInterrupt(){
  holdPositionBF();
  pinMode(interruptPin,INPUT_PULLUP);
}

void holdPositionBF(){
  writePassThroughLCD();
  attachInterrupt(interruptPin,passThroughModeBF,CHANGE); 
  turnOffGreenLED();
  turnOffRedLED();
  turnOnBlueLED();
  resetInterruptState();
}

void holdPositionEpi(){
  writePassThroughLCD();
  attachInterrupt(interruptPin,passThroughModeEpi,CHANGE); 
  turnOffGreenLED();
  turnOffRedLED();
  turnOnBlueLED();
  resetInterruptState();
}

void constantPassThrough(){
  turnOffInterrupt(); 
  turnOnAllLights();
  turnOnAllLEDs();
  writeConstantThroughLCD();
}

void triggerPassThrough(){
  attachInterrupt(interruptPin,triggerPassThroughMode,CHANGE); 
  turnOffAllLights();
  turnOffAllLEDs();
  writeTriggerThroughLCD();
  resetInterruptState();
}

void turnOffInterrupt(){
  attachInterrupt(interruptPin,doNothing,CHANGE);  
}

void turnOnZStackInterrupt(){
  writeZStackLCD();
  attachInterrupt(interruptPin,doZStep,CHANGE);
  resetInterruptState();
}

void doNothing(){

}






