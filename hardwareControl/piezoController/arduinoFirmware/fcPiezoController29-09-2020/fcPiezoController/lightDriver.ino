// setup LED
void setupLights(){
  DDRF = B11111111; 
  PORTF = B01000000;
}

// setup LEDs on the board
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

void turnOnBlueLED(){
  PORTB |= B00010000;
}
void turnOffBlueLED(){
  PORTB &= B11101111;
}

void turnOnAllLEDs(){
  PORTB |= B01110000;
}

void turnOffAllLEDs(){
  PORTB &= B10001111;
}

void turnOnBrightFieldLED(){
  PORTF = B01000000;
}

void turnOnAllEpiLED(){
  PORTF = B00000001;
}

void turnOnAllLights(){
  PORTF = B01000001;
}

void turnOffAllLights(){
  PORTF = B00000000;
}

void testAllLights(){
  PORTF = B01011111;
}
