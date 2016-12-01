#include <Mouse.h>
#include <Keyboard.h>

int button2Press = 0;
int button3Press = 0;
int button4Press = 0;
int button5Press = 0;
int button6Press = 0;
int button7Press = 0;
int button8Press = 0;
int button9Press = 0;
int button10Press = 0;
int button11Press = 0;
int button12Press = 0;


void setup() {
  Serial.begin(9600);

  pinMode(10,INPUT);
  pinMode(11,INPUT);
pinMode(2, INPUT_PULLUP);   // 'e'
pinMode(3, INPUT_PULLUP);   // 'r'
pinMode(4, INPUT_PULLUP);   // 'f'
pinMode(5, INPUT_PULLUP);   // 'v'
pinMode(6, INPUT_PULLUP);   // 'c'
pinMode(7, INPUT_PULLUP);   // 'x'
pinMode(8, INPUT_PULLUP);   // 's'
pinMode(9, INPUT_PULLUP);   // 'w'
pinMode(10, INPUT_PULLUP);   // 'Alt'
pinMode(11, INPUT_PULLUP);   // 'Shift'
pinMode(12, INPUT_PULLUP);   // 'MousePressed'
pinMode(13, INPUT_PULLUP);   // 'ON/OFF'
}

void loop() {


if(digitalRead(12)==LOW){
Keyboard.begin();
Mouse.begin();


if(digitalRead(2)==LOW && button2Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.write('e');
button2Press = 1;
}
if(digitalRead(2) != LOW && button2Press == 1){      //  'e' = Up Stich & UpRight SQUARE
button2Press = 0;
}

if(digitalRead(3)==LOW && button3Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.write('r');
button3Press = 1;
}
if(digitalRead(3) != LOW && button3Press == 1){      //  'e' = Up Stich & UpRight SQUARE
button3Press = 0;
}

if(digitalRead(4)==LOW && button4Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.write('f');
button4Press = 1;
}
if(digitalRead(4) != LOW && button4Press == 1){      //  'e' = Up Stich & UpRight SQUARE
button4Press = 0;
}

if(digitalRead(5)==LOW && button5Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.write('v');
button5Press = 1;
}
if(digitalRead(5) != LOW && button5Press == 1){      //  'e' = Up Stich & UpRight SQUARE
button5Press = 0;
}

if(digitalRead(6)==LOW && button6Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.write('c');
button6Press = 1;
}
if(digitalRead(6) != LOW && button6Press == 1){      //  'e' = Up Stich & UpRight SQUARE
button6Press = 0;
}

if(digitalRead(7)==LOW && button7Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.write('x');
button7Press = 1;
}
if(digitalRead(7) != LOW && button7Press == 1){      //  'e' = Up Stich & UpRight SQUARE
button7Press = 0;
}

if(digitalRead(8)==LOW && button8Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.write('s');
button8Press = 1;
}
if(digitalRead(8) != LOW && button8Press == 1){      //  'e' = Up Stich & UpRight SQUARE
button8Press = 0;
}

if(digitalRead(9)==LOW && button9Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.write('w');
button9Press = 1;
}
if(digitalRead(9) != LOW && button9Press == 1){      //  'e' = Up Stich & UpRight SQUARE
button9Press = 0;
}

//alt holds but does not release, shift does not work

if(digitalRead(10)==LOW && button10Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.press(KEY_LEFT_ALT);
button10Press = 1;
}
if(digitalRead(10) != LOW && button10Press == 1){      //  'e' = Up Stich & UpRight SQUARE
  Keyboard.release(KEY_LEFT_ALT);
button10Press = 0;
}

if(digitalRead(11)==LOW && button11Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.press(KEY_LEFT_SHIFT);
button11Press = 1;
}
if(digitalRead(11) != LOW && button11Press == 1){      //  'e' = Up Stich & UpRight SQUARE
Keyboard.release(KEY_LEFT_SHIFT);
button11Press = 0;
}



if(digitalRead(13)==LOW && button12Press == 0){      //  'e' = Up Stich & UpRight SQUARE
Mouse.press();
button12Press = 1;
}
if(digitalRead(13) != LOW && button12Press == 1){      //  'e' = Up Stich & UpRight SQUARE
  Mouse.release();
button12Press = 0;
}

} else {
Keyboard.end();
}

}
