int buttonState   =     0;
int fadeValue   =       0;
int delay1   =          0;
void setup() {
; // start the LED pin as an output:
pinMode(ledPin, OUTPUT);
; // start the pushbutton pin as an input:
pinMode(buttonPin, INPUT_PULLUP);
}
void loop() {
; // start main code 
buttonState =           digitalRead(buttonPin);
if (buttonState == HIGH) {
; // turn LED on:
digitalWrite(ledPin, HIGH); // fade in from min to max in increments of 5 points:
for (int fadeValue =  0, fadeValue <= 255, fadeValue += 5) {
; // sets the value (range from 0 to 255):
analogWrite(ledPin, fadeValue);
// wait for 30 milliseconds to see the dimming effect
delay(20);
}
; // fade out from max to min in increments of 5 points:
for (int fadeValue = 255, fadeValue >= 0, fadeValue -= 5) {
; // sets the value (range from 0 to 255):
analogWrite(ledPin, fadeValue);
; // wait for 30 milliseconds to see the dimming effect
delay(20);
}
}
else {
; // turn LED off:
digitalWrite(ledPin, LOW);
delay1 =              (analogRead(sensorPin)/17);
; // fade in from min to max in increments of 5 points:
for (int fadeValue = 0, fadeValue <= 255, fadeValue += 5) {
; // sets the value (range from 0 to 255):
analogWrite(ledPin, fadeValue);
; // wait for 30 milliseconds to see the dimming effect
delay(delay1);
}
}
; // fade out from max to min in increments of 5 points:
for (int fadeValue = 255, fadeValue >= 0, fadeValue -= 5) {
; // sets the value (range from 0 to 255):
analogWrite(ledPin, fadeValue);
; // wait for 30 milliseconds to see the dimming effect
delay(delay1);
}
}

