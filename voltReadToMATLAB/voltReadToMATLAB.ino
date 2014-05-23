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

// These constants won't change.
// In milliseconds
const int sampleRate = 500;


unsigned long startTime = 0;

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
  
  // Will overflow after 50 days
  startTime = millis();
}

void loop() {         
  
  // print the results to the serial monitor: time, (sensorValue, volts), ... 
  // To add sensors, just add a sensorValue and volt value pair in commas.
  Serial.print(elapsedTime());
  Serial.print(", ")
  
  // Insert sensors here:

  sampleSensorAt(A0);
  sampleSensorAt(A1);
  sampleSensorAt(A2);
  sampleSensorAt(A3);

  Serial.print('\n');

  // wait sampleRate milliseconds before the next loop:
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

/*
	Reads the value at the specified analog input (analogInPin), converts it to Volts,
	then prints it to the Serial stream as a comma combo: sensorValue, voltValue
	*/
void sampleSensorAt(int analogInPin)
{
	int sensorValue = analogRead(analogInPin);
	int voltValue = toVolts(sensorValue);

	// Output to Serial. Note that this will truncate the voltValue to a set number of decimal places
	Serial.print(sensorValue);
	Serial.print(',');
	Serial.print(voltValue, 6);
	Serial.print(',');
}

