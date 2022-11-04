#define myBaudRate 115200 
void setupSerialInterface(){
  // setup communication with PC
  Serial.begin(myBaudRate); 
}

/* 
 states:
 b - hold stage position, BF trigger is constant, PL is ttl triggered
 f - hold stage position, PL triggers are constant, BF is ttl triggered
 c - hold position and keep everything on
 t - hold position, but TTL trigger everything
 o - turn off all leds
 r - resetZstack, zstack ready
 a - reset ZStack to zero
 p - print the programmed arrays 
 w - writing to z arrays that program the DAC and TTL controls
 the format for writing is as follows:
 w(zIndex=i),(zFunc[i]),(zWavelength[i]),(kickItUpDelay[i]),(kickItUpDelta[i]),(slowItDownDelay[i]),(slowItDownDelta[i])
 s - set starting and ending index of zstack program 
 s(zStart),(zEnd), then update DAC to zFunc[zStart]
 */

void pollSerialInterface(){
  while (Serial.available() >0){
    char state = Serial.read();
    switch(state) {
    case 'c':
      constantPassThrough();
      break;
    case 'r':
      resetZstack();
      sendConfirmation();
      break;
    case 'a':
      resetZstackToZero();
      sendConfirmation();
      break;
    case 'p':
      printZData();
      break;    
    case 's':
      setZStartingEndingIndex();
      break;
    case 't':
      triggerPassThrough();
      break;
    case 'w':
      parseZData();
      break;
	case 'b':
	  holdPositionBF();
      break;
	case 'f':
	  holdPositionEpi();
	  break;
	case 'o':
	  turnOffAllLights();
	  break;
    case 'z':
	  testAllLights();
	  break;
    }
  }
}

void sendConfirmation(){
  Serial.print(F("ok\n")); 
}
