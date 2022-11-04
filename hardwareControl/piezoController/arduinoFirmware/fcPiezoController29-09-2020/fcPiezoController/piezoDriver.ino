/* parse serial input to update z step parameters 
 using convention of letter, number then ending non-number character e.g. 'a10*' to set dz = 10 
 
 to program this circuit you want to think about the following parameters that affect a zstack
 
 numLeadingBlackFrames  // defines how many frames to throw away (not provide light) in the beg of seq
 numLaggingBlackFrames  // defines how many frames to throw away (not provide light) in the end of seq
 dz                     // step size in 16bit dac units, can be positive or negative to control direction
 zRest                  // resting Z starting point in 16bit dac units
 z0                     // position of the first zStack in 16bit dac units
 kickItUpDelta          // the boost in voltage (in 16bit dac units) added to accelerate the stage
 kickItUpDelay          // the length of time for the boost
 slowItDownDelta        // the retard in voltage (in 16bit dac units) added to slow down the stage
 slowItDownDelay        // the length of time for the retard
 
 
 1      2      3      4   <--zIndex being updated after zstage settles    
 |______|______|______|    
 
 __----___----___----___    <--Camera Integration TTL output
 |
 on the rising edge, the piezo controller will trigger,
 aligned with the TTL camera integrating input, the wavelength output
 defined at zWavelength[zindez]
 |
 on the downard edge the piezo controller will accelerate the zStage, 
 1) DAC voltage = zFunc[zIndex] + kickItUpDelta[zIndex]
 2) delay(kickItUpDelay[zIndex])
 |
 now we need to bleed off the accleration of the zStage so it can settle,
 1) DAC voltage = zFunc[zIndex] + slowItDownDelta[zIndex]
 2) delay(slowItDownDelay[zIndex])
 |
 now issue the true position 
 1) DAC voltage = zFunc[zIndex]
 2) zIndex++ 
 
 */

#define maxSteps 256                   // maximum number of programmed z positions
volatile unsigned int zIndex;          // zStep state index, interrupt controlled.
volatile boolean interruptState;       // edge type {0:rising,1:falling} state, interrupt controlled
int zFunc[maxSteps];                   // DAC outputs per zIndex
byte zWavelength[maxSteps];            // Wavelength Output per zIndex
byte kickItUpDelay[maxSteps];          // accelerating stage delay
byte slowItDownDelay[maxSteps];        // decelerating stage
int kickItUpDelta[maxSteps];           // accelerating stage additional voltage
int slowItDownDelta[maxSteps];         // decelerating stage additional voltage
unsigned int zStart = 0;               // Zstep program start index
unsigned int zEnd   = 0;               // Zstep program ending index

//////////PIEZO INTERRUPT FUNCTIONS////////////////////////////////////////////////////////////////////////////////
void resetInterruptState(){
  interruptState = 0;
}

/* passThroughMode toggles the channel on and off when triggered by the camera */
void passThroughModeBF(){
  PORTF = B00000000;				
  PORTB = B00000000;
  /* falling edge */
  if (interruptState > 0){
     turnOffRedLED();
  }
  else{
    /* rising edge */
    PORTF = B01000000;
    turnOnRedLED();
  }
  interruptState = !interruptState;
}

void passThroughModeEpi(){
  PORTF = B00000000;
  PORTB = B00000000;
  /* falling edge */
  if (interruptState > 0){
     turnOffRedLED();
  }
  else{
    /* rising edge */
    PORTF = B00000001;
    turnOnRedLED();
  }
  interruptState = !interruptState;
}



/* triggerPassThrough() toggles everything on and off */
void triggerPassThroughMode(){
  PORTF = B00000000;
  PORTB = B00000000;
  /* falling edge */
  if (interruptState > 0){
    turnOffRedLED();
    turnOffBlueLED();
  }
  else{
    /* rising edge */
    PORTF = B01111111;
    turnOnRedLED();
    turnOnBlueLED();
  }
  interruptState = !interruptState;  
}

/*
==CONTROLLER STATEMACHINE=========================================================
 triggering rules
 1) reset circuit to z0 = zFunc[zEnd], start and end of stream is the same
 3) on rising edge: turn on specified zWavelength[zIndex]
 4) on falling edge: 
 i) turn off all lights on PORTF, 
 ii) DAC(zStep[zIndex] + kickItUpDelta[zIndex]) 
 delay(kickItUpDelay[zIndex]), 
 DAC(zStep[zIndex] + slowItDownDelta[zIndex])
 delay(slowItDownDelay[zIndex]),
 DAC(zStep[zIndex])
 zIndex++
 zIndex = max(zStart,(zIndex) % (zEnd+1));  zIndex goes from zStart to zEnd
 */

void doZStep(){
  // turn off everything
  PORTF = B00000000;
  PORTB = B00000000;
  /* falling edge */
  if (interruptState > 0){
    // accelerate stage
    write2Dac(zFunc[zIndex] + kickItUpDelta[zIndex]);
    delay(kickItUpDelay[zIndex]);
    // decelerate stage
    write2Dac(zFunc[zIndex] + slowItDownDelta[zIndex]);
    delay(slowItDownDelay[zIndex]);
    // actuate zstack at zIndex, this should be true zFunc value for this zstep
    write2Dac(zFunc[zIndex]);
    zIndex++;
    // wrap around zIndex from zStart and zEnd
    zIndex = max(zStart,(zIndex)% (zEnd+1));
    if (zIndex==zStart){
      turnOnGreenLED(); 
    }
  }
  else{
    /* rising edge */
    PORTF = zWavelength[zIndex];
    if (PORTF == B01000000){
      turnOnBlueLED();
    }else{
      turnOnRedLED(); 
    }
  }
  interruptState = !interruptState;
}


//////////HELPER FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////
void setupPiezo(){
  write2Dac(0);
}

void resetZstack(){
  turnOffInterrupt();
  PORTF = B00000000;
  if (zEnd == 0){
    write2Dac(0);
    
  }
  else{
    write2Dac(zFunc[zEnd]);
  }
  zIndex = zStart;
  turnOnGreenLED();
  turnOnZStackInterrupt();
}

void resetZstackToZero(){
  turnOffInterrupt();
  PORTF = B00000000;
  write2Dac(0);
}

/* this fills up arrays so i can check how much sram i have left */
void fillUpArrays(){
  for (int i = 0; i < maxSteps; i++){
    zFunc[i] = 0;
    zWavelength[i] = 0 % 8;
    kickItUpDelay[i] = 0 % 8;
    slowItDownDelay[i] = 0 % 8;
    kickItUpDelta[i] = 0;
    slowItDownDelta[i] = 0;
  } 
}


/////////SERIAL INTERFACE TO PIEZO//////////////////////////////////////////////////////////////////////////////////////
/* 
 s - set starting and ending index of zstack program 
 s(zStart),(zEnd)
 */
void setZStartingEndingIndex(){
  turnOffInterrupt();
  zStart = Serial.parseInt();
  zEnd = Serial.parseInt();
  holdPositionBF();
}

/*  
 w - writing to z arrays that program the DAC and TTL controls
 the format for writing is as follows:
 w(zIndex=i),(zFunc[i]),(zWavelength[i]),(kickItUpDelay[i]),(kickItUpDelta[i]),(slowItDownDelay[i]),(slowItDownDelta[i])
 */
void parseZData(){
  turnOffInterrupt();
  int intIndex = 1;
  while (intIndex <= 7) {
    int currInt = Serial.parseInt();
    switch (intIndex) {
    case 1:
      zIndex = currInt;
      break;
    case 2:
      zFunc[zIndex] = currInt;
      break;
    case 3:
      zWavelength[zIndex] = currInt;
      break;
    case 4:
      kickItUpDelay[zIndex] = currInt;
      break;
    case 5:
      kickItUpDelta[zIndex] = currInt;
      break;
    case 6:
      slowItDownDelay[zIndex] = currInt;
      break;
    case 7:
      slowItDownDelta[zIndex] = currInt;
      break;
    default:
      break; 
    }
    intIndex++;
  }
}

void printZData(){
  turnOffInterrupt();
  writePrintingLCD();
  Serial.print("startingZIndex " + String(zStart) + " endingZIndex " + String(zEnd) + "\n");
  Serial.print(F("(zIndex=i),(zFunc[i]),(zWavelength[i]),(kickItUpDelay[i]),(kickItUpDelta[i]),(slowItDownDelay[i]),(slowItDownDelta[i])\n"));
  for(int i = 0; i < maxSteps;i++){
    Serial.print(String(i) + "," + String(zFunc[i]) + "," + String(zWavelength[i]) + "," + String(kickItUpDelay[i]) + "," + String(kickItUpDelta[i]) + "," + String(slowItDownDelay[i]) + "," + String(slowItDownDelta[i]) + "\n");
  }
  Serial.print("EOT\n");  // end of transmission
  holdPositionBF();
}











