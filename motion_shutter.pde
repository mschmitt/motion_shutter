/*

Sketch to control camera shutter based on motion detection

Status: Work in progress

Arduino has to run on 12V or at least 9V from DC for the PIR sensor 
to work. The sensor datasheet says otherwise, but don't waste your time
trying to run it on 5V.
 
PIR sensor SE-10 (Sparkfun) is connected:
- Brown wire: GND
- Red wire: Vin (12V)
- Black Wire: Digital 12

Digital 4 controls the camera via 4N35 optocoupler:
- Digital 4 -> 220R -> 4N35 Pin 1
- GND -> 4N35 Pin 2
- Camera Shutter+Focus -> 4N35 Pin 5
- Camera GND -> 4N35 Pin 4

Variable names are a bit rough here. Read "warn_" as "shutter_".

As usual, this is written without the use of delay() for timing actions.
Have fun. ;-)

*/

const int sensorPin = 12;
const int ledPin = 13;
const int shutterPin = 4;
const int warn_enable_for = 1000; // How long the shutter shall be pressed

int warn_want_state = 0;
int warn_state = 0;
long warn_enabled_since = millis();

void setup(){
  pinMode(ledPin, OUTPUT);
  pinMode(shutterPin, OUTPUT);
  pinMode(sensorPin, INPUT);
  // Activate pull-up resistor on sensor input
  digitalWrite(sensorPin, HIGH);
  Serial.begin(9600);
  delay(1000);
}

void loop(){
  int sensorState = digitalRead(sensorPin);
  // Sensor goes LOW when motion detected
  // Serial.println(sensorState);
  if (LOW == sensorState){
    warn_want_state = 1;
    warn_enabled_since = millis();
  }else{
    warn_want_state = 0;
  }
  // Shutter should be turned off
  if ((1 == warn_state) and (0 == warn_want_state)){
    // But was it on for long enough?
    if (millis() - warn_enabled_since > warn_enable_for){
      digitalWrite(ledPin, LOW);
      digitalWrite(shutterPin, LOW);
      Serial.println("OFF");
      warn_state = 0;
    }
  }
  /// Shutter should be turned on
  if ((0 == warn_state) and (1 == warn_want_state)){
    digitalWrite(ledPin, HIGH);
    digitalWrite(shutterPin, HIGH);
    Serial.println("ON");
    warn_state = 1;
  }
  delay(200);
}

/*
Copyright (c) 2011, Martin Schmitt < mas at scsy dot de >

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
