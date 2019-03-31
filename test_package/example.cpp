#include <Arduino.h>
#include <stdint.h>
// LED connected to digital pin 13
const int16_t PIN13 = 13;
void setup()
{
    pinMode(PIN13, OUTPUT);
}

void loop()
{    
    // Set LED on, wait a second, turn LED off
    // then wait one more second
    digitalWrite(PIN13, HIGH);
    delay(1000);
    digitalWrite(PIN13, LOW);
    delay(1000);
}
 