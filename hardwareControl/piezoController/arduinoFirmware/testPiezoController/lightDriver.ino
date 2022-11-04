void setupLights(){
  DDRF = B11111111; 
  PORTF = B01000000;
}

void setupLEDs(){
  DDRB = B01110000; 
}
void turnOnRedLED(){
  PORTB |= B01000000;
}

void turnOffRedLED(){
  PORTB &= B10111111;
}

void turnOnGreenLED(){
  PORTB |= B00100000;
}
void turnOffGreenLED(){
  PORTB &= B11011111;
}

void turnOnYellowLED(){
  PORTB |= B00010000;
}
void turnOffYellowLED(){
  PORTB &= B11101111;
}

void turnOnAllLEDs(){
  PORTB |= B01110000;
}

void turnOffAllLEDs(){
  PORTB &= B10001111;
}

void turnOnAllLights(){
  PORTF = B01111111;
}

void turnOffAllLights(){
  PORTF = B0000000;
}
