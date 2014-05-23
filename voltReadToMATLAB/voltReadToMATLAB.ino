/*
  Analog input, analog output, serial output
 
 Reads an analog input pin, maps the result to a range from 0 to 255
 and uses the result to set the pulsewidth modulation (PWM) of an output pin.
 Also prints the results to the serial monitor.
 
 The circuit:
 * potentiometer connected to analog pin 0.
   Center pin of the potentiometer goes to the analog pin.
   side pins of the potentiometer go to +5V and ground
 * LED connected from digital pin 9 to ground
 
 created 29 Dec. 2008
 modified 9 Apr 2012
 by Tom Igoe
 
 This example code is in the public domain.
 
 */

// These constants won't change.  They're used to give names
// to the pins used:
const int analogInPin = A0;  // Analog input pin that the potentiometer is attached to

// In milliseconds
const int sampleRate = 500;

int sensorValue = 0;        // value read from the pot
unsigned long startTime = 0;

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
  
  // Will overflow after 50 days
  startTime = millis();
}

void loop() {
  // read the analog in value:
  sensorValue = analogRead(analogInPin);              
  
  // print the results to the serial monitor:  
  Serial.print(sensorValue);
  Serial.print(", ");
  Serial.print(toVolts(sensorValue), 6);
  Serial.print(", ");
  Serial.print(elapsedTime());
  Serial.print('\n');

  // wait 2 milliseconds before the next loop
  // for the analog-to-digital converter to settle
  // after the last reading:
  delay(sampleRate);                     
}

// Returns a voltage from 0 to 5V based on an analog signal from 0 to 1023 bits
double toVolts(int analogInput)
{
  return 5.0*((analogInput)/1023.0);
}

long elapsedTime()
{
   return (millis() - startTime); 
}

