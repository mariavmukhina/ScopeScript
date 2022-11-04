#include <MemoryFree.h>

void printFreeMemory(){
  Serial.println(F("Free Memory"));
  Serial.println(freeMemory()); 
}

