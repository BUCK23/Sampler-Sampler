#include <Mouse.h>
#include <Keyboard.h>

int button4Press = 0;   // 'w'
int button5Press = 0;   // 's'
int button6Press = 0;   // 'c'
int button7Press = 0;   // 'x'
int button8Press = 0;   // 'Shift'
int button9Press = 0;   // 'ON/OFF'
int button10Press = 0;  // 'Alt'
int button16Press = 0;  // 'MousePressed'
int button14Press = 0;  // 'v'
int button15Press = 0;  // 'a'
int button18Press = 0;  // 'f'
int button19Press = 0;  // 'e'
int button20Press = 0;  // 'r'

//values for debouncing switch
unsigned long lastDebounceTime = 0;
int debounceDelay = 50;
int bounced = 0;
int readState = 0;

void setup() {
  Serial.begin(9600);
pinMode(4, INPUT_PULLUP);   // 'w'
pinMode(5, INPUT_PULLUP);   // 's'
pinMode(6, INPUT_PULLUP);   // 'c'
pinMode(7, INPUT_PULLUP);   // 'x'
pinMode(8, INPUT_PULLUP);   // 'Shift'
pinMode(9, INPUT_PULLUP);   // 'ON/OFF'
pinMode(10, INPUT_PULLUP);   // 'ALT'
pinMode(16, INPUT_PULLUP);   // 'MousePressed'
pinMode(14, INPUT_PULLUP);   // 'v'
pinMode(15, INPUT_PULLUP);   // 'a'
pinMode(18, INPUT_PULLUP);   // 'f'
pinMode(19, INPUT_PULLUP);   // 'e'
pinMode(20, INPUT_PULLUP);   // 'r'

lastDebounceTime = millis();

}

void loop() {

Serial.println("the loop is running, but you haven't done it properly");

if ((millis() - lastDebounceTime) > debounceDelay) {

  bounced = 0;

if(digitalRead(9)==LOW){    // ON/OFF
Keyboard.begin();
Mouse.begin();

  if(digitalRead(4)==LOW && button4Press == 0){      // 'w'
  Keyboard.write('w');
  button4Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(4) != LOW && button4Press == 1){
  button4Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(5)==LOW && button5Press == 0){      // 's'
  Keyboard.write('s');
  button5Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(5) != LOW && button5Press == 1){
  button5Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(6)==LOW && button6Press == 0){      //  'c'
  Keyboard.write('c');
  button6Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(6) != LOW && button6Press == 1){
  button6Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(7)==LOW && button7Press == 0){      // 'x'
  Keyboard.write('x');
  button7Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(7) != LOW && button7Press == 1){
  button7Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(14)==LOW && button14Press == 0){   // 'v'
  Keyboard.write('v');
  button14Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(14) != LOW && button14Press == 1){
  button14Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(15)==LOW && button15Press == 0){      // 'a'
  Keyboard.write('a');
  button15Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(15) != LOW && button15Press == 1){
  button15Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(18)==LOW && button18Press == 0){      //  'f'
  Keyboard.write('f');
  button18Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(18) != LOW && button18Press == 1){
  button18Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(19)==LOW && button19Press == 0){      // 'e'
  Keyboard.write('e');
  button19Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(19) != LOW && button19Press == 1){
  button19Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(20)==LOW && button20Press == 0){      // 'r'
  Keyboard.write('r');
  button20Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(20) != LOW && button20Press == 1){
  button20Press = 0;
  lastDebounceTime = millis();
  }

// alt, shift, MousePressed

  if(digitalRead(10)==LOW && button10Press == 0){      //  'alt'
  Keyboard.press(KEY_LEFT_ALT);
  button10Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(10) != LOW && button10Press == 1){
    Keyboard.release(KEY_LEFT_ALT);
  button10Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(8)==LOW && button8Press == 0){      //  'Shift'
  Keyboard.press(KEY_LEFT_SHIFT);
  button8Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(8) != LOW && button8Press == 1){
  Keyboard.release(KEY_LEFT_SHIFT);
  button8Press = 0;
  lastDebounceTime = millis();
  }

  if(digitalRead(16)==LOW && button16Press == 0){      // 'MousePressed'
  Mouse.press();
  button16Press = 1;
  lastDebounceTime = millis();
  }
  if(digitalRead(16) != LOW && button16Press == 1){
    Mouse.release();
  button16Press = 0;
  lastDebounceTime = millis();
  }

} else {
Keyboard.end();
Mouse.end();
}
}

}
