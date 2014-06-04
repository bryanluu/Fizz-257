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
const int sampleRate = 1000;
const double maxResistorTemp = 80.0;
const int mosfetPin = 13;

boolean experimentFinished = false;


unsigned long startTime = 0;

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
  
  // Will overflow after 50 days
  startTime = millis();
  
  pinMode(mosfetPin, OUTPUT);
}

void loop() {         
  
  // print the results to the serial monitor: time, (sensorValue, volts), ... 
  // To add sensors, just add a sensorValue and volt value pair in commas.
  Serial.print(elapsedTime());
  Serial.print(", ");
  
  // Insert sensors here:

  double resistorTemp = sampleThermocoupleAt(A0);
  sampleThermocoupleAt(A1);
  sampleThermocoupleAt(A2);
  sampleThermocoupleAt(A3);
  // A4 is attached to Power Resistor
  sampleTMPAt(A4);
  sampleTMPAt(A5);
  Serial.print("\n");
  // If resistor temp is too high, turn off MOSFET and disable power.
  if(experimentFinished == false)
  {
     digitalWrite(mosfetPin, HIGH);
     if(resistorTemp > maxResistorTemp)
     {
        experimentFinished = true;
     } 
  }
  else
  {
    digitalWrite(mosfetPin, LOW);
  }
  
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
	Reads and returns the value at the specified analog input (analogInPin), converts it to temperature,
	then prints it to the Serial stream as a comma combo: sensorValue, tempValue
	*/
double sampleThermocoupleAt(int analogInPin)
{
	int sensorValue = analogRead(analogInPin);
	double tempValue = getThermocoupleTemperature(analogInPin);

	// Output to Serial. Note that this will truncate the voltValue to a set number of decimal places
	Serial.print(sensorValue);
	Serial.print(", ");
	Serial.print(tempValue, 6);
	Serial.print(", ");

        return tempValue;
}

/*
	Reads and returns at the specified analog input (analogInPin), converts it to temperature,
	then prints it to the Serial stream as a comma combo: sensorValue, tempValue
	*/
double sampleTMPAt(int analogInPin)
{
	int sensorValue = analogRead(analogInPin);
	double tempValue = getTMPTemperature(analogInPin);

	// Output to Serial. Note that this will truncate the voltValue to a set number of decimal places
	Serial.print(sensorValue);
	Serial.print(", ");
	Serial.print(tempValue, 6);
	Serial.print(", ");

        return tempValue;
}

double getTMPTemperature(int analogInPin)
{
    int sensorValue = analogRead(analogInPin);
    double voltage = toVolts(sensorValue);
    
    return voltage*100.0;
}

// Returns the temperature, calculated from the voltage of the thermocouple located at the specified pin
double getThermocoupleTemperature(int analogInPin)
{
  int sensorValue = analogRead(analogInPin);
  double voltage = toVolts(sensorValue);
  
  switch (analogInPin)
  {
    case A0:
      return tempFunc(voltage, 23.928, 18.0404, 1.37);
    case A1:
      return tempFunc(voltage, 24.115, 18.0482, 1.37);
    case A2:
      return tempFunc(voltage, 23.658, 21.45, 1.37);
    case A3:  
      return tempFunc(voltage, 23.107, 21.45, 1.37); //23.913 
  }
}

double tempFunc(double voltage, double A, double B, double C)
{
  return (A*(voltage-C) + B);
}
