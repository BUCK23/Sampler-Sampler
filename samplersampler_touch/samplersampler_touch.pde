import processing.io.*;
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress supercollider;
int gridSize = 60; //set grid size.
ArrayList<Stitch> stitches = new ArrayList<Stitch>(); // create an empty array list
int started = 0; //sets start point
float prevX = 0.0;
float prevY = 0.0;
Grid grid;      // declare Grid object
Thread thread;  // declare Thread object
Stitch stitch;  // declare Stitch object
Needle needle; // declare Needle object
int debounce; //declare debounce variable
int time;  // decalre timer variable for debounce
int gpioEnable = 0; //NOTE: THIS IS USED TO DISABLE/ENABLE GPIO FUNCTIONALITY TO USE THIS SKETCH ON A LAPTOP, NOT RPI

// Variables for sonifying mouse stitch movement
// When the mouse is pressed down, log the X and Y position to clickedMouseX and clickedMouseY.
// Then enable isMouseAlreadyPressed
// This will then reset itself once 
int clickedMouseX;
int clickedMouseY;
int isMouseAlreadyPressed;
// these are to check if the mouse has been moved
int prevMouseX;
int prevMouseY;
// this sets the ID of the triggered synth
int trigID = int(random(5000));

void setup() {

  fullScreen();
  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
  noFill();
  noCursor();
  grid = new Grid();                  // make initial Grid object
  thread = new Thread();              //make initial Thread object
  needle = new Needle();

  time = millis();    // sets start time to millis for button debounce
  debounce = 200;    // debounce length

  if (gpioEnable == 1) {
    // pinMode set up for buttons
    GPIO.pinMode(12, GPIO.INPUT);    
    GPIO.pinMode(16, GPIO.INPUT);
    GPIO.pinMode(26, GPIO.INPUT);
  }
}

void draw() {
  background(255);      // resets background
  grid.drawGrid();      // draws grid

  // draw all stitches
  for (int i = 0; i < stitches.size(); i++) {
    Stitch stitch = stitches.get(i);
    stitch.drawStitches();
  }

  if (mousePressed == true) {  // draws a dot for finger position, ie the "needle"
    needle.drawNeedle();

    // Grab the mouse position to be used for sonification
    if (isMouseAlreadyPressed == 0) {
      clickedMouseX = mouseX;
      clickedMouseY = mouseY;
      isMouseAlreadyPressed = 1;
      OscMessage oscMousePressed = new OscMessage("/mousePressed");
      oscMousePressed.add(trigID);
      oscP5.send(oscMousePressed, supercollider);
    }

    //if mouse position has changed, send data, just so that superCollider isn't overloaded with OSC
    // NOTE: This needs to be scaled to grid dots, because i'm going to be making this on a very big screen
    if (prevMouseX != mouseX || prevMouseY != mouseY) {
      OscMessage mousePosition = new OscMessage("/mousePosition");
      // I need to not send mouse position here, but send the thread length.
      mousePosition.add(mouseX - clickedMouseX);
      mousePosition.add(mouseY - clickedMouseY);
      mousePosition.add(gridSize);
      mousePosition.add(trigID);
      oscP5.send(mousePosition, supercollider);
      println(stitch.sx1);
    }

    //log previous values of mouse position
    prevMouseX = mouseX;
    prevMouseY = mouseY;
  }

  thread.drawThread();      // draws thread

  if (gpioEnable == 1) {
    // triggers undoButton function 
    if ((GPIO.digitalRead(12) == GPIO.LOW) && (millis() - time >= debounce)) {
      undoButton();
      time = millis();
    }

    // triggers clearScreen function    
    if ((GPIO.digitalRead(16) == GPIO.LOW) && (millis() - time >= debounce)) {
      clearStitches();
      time = millis();
    }

    // triggers sendSample function
    if ((GPIO.digitalRead(26) == GPIO.LOW) && (millis() - time >= debounce)) {
      sendSample();
      time = millis();
    }
  }
}

// sets the stitch from drawn thread
void mouseReleased() {
  thread.tx2 = int(thread.tx2/gridSize)*gridSize;        // gives end points for stitch on mouse release        
  thread.ty2 = int(thread.ty2/gridSize)*gridSize;  
  stitches.add(new Stitch(thread.tx1, thread.ty1, thread.tx2, thread.ty2, thread.threadTop));  // add stitch objects to array
  thread.threadTop = ! thread.threadTop;                                                        // changes stitch colour
  isMouseAlreadyPressed = 0;
  OscMessage oscMousePressed = new OscMessage("/mouseReleased");
  //trigID should send the name of the note so that SuperCollider knows which note to terminate
  oscMousePressed.add(trigID);
  oscP5.send(oscMousePressed, supercollider);
  //adds to the trigID
  trigID = (trigID + 1)%5000 ;
}

// UNDO BUTTON
void undoButton() {
  if (stitches.size() > 0) {
    stitches.remove(stitches.size()-1);
    thread.tx1 = stitch.sx1;            // start position for x thread line
    thread.ty1 = stitch.sy1;            // start position for y thread line
    thread.tx2 = stitch.sx2;            // start position for x thread line
    thread.ty2 = stitch.sy2;            // start position for y thread line
    thread.threadTop = ! thread.threadTop;
  }
}

//CLEAR SCREEN
void clearStitches() {
  prevX = 0.0;
  prevY = 0.0;
  stitches.clear();
  started = 0;
}

// SEND SAMPLE TO SUPERCOLLIDER (AND CLEAR SCREEN)
void sendSample() {

  // not sure what needs to go in here for supercollider 
  //but I've copied the clearStitches function just to make 
  // sure the button works

  //make SuperCollider listen for info
  OscMessage stitchListener = new OscMessage("/stitchListener");
  stitchListener.add(1);
  oscP5.send(stitchListener, supercollider);
  //dump ALL data from Processing to SuperCollider
  for (int i = 0; i < stitches.size(); i++) {
    OscMessage stitchMsg = new OscMessage("/stitchInfo");
    stitchMsg.add((stitches.get(i).sx1/gridSize) - (stitches.get(i).sx2/gridSize));
    stitchMsg.add((stitches.get(i).sy1/gridSize) - (stitches.get(i).sy2/gridSize));
    stitchMsg.add(stitches.get(i).topStitch);
    oscP5.send(stitchMsg, supercollider);
  };
  //make SuperCollider stop listening for info (hopefully it has built a big array by now)
  OscMessage stitchUnlistener = new OscMessage("/stitchListener");
  stitchUnlistener.add(0);
  oscP5.send(stitchUnlistener, supercollider); 
  started = 0;
  stitches.clear();

  prevX = 0.0;
  prevY = 0.0;
  stitches.clear();
  started = 0;
}


void keyPressed() {
  sendSample();
}

// ------------------------------------------------------------------------------------

// SUPERCOLLIDER STUFF!! 

// Sends Sample Button
/*void sendSample() {
 if (GPIO.digitalRead(26) == GPIO.HIGH) {
 //make SuperCollider listen for info
 OscMessage stitchListener = new OscMessage("/stitchListener");
 stitchListener.add(1);
 oscP5.send(stitchListener, supercollider);
 //dump ALL data from Processing to SuperCollider
 for (int i = 0; i < stitches.size(); i++) {
 OscMessage stitchMsg = new OscMessage("/stitchInfo");
 stitchMsg.add((stitches.get(i).sx1/gridSize) - (stitches.get(i).sx2/gridSize));
 stitchMsg.add((stitches.get(i).sy1/gridSize) - (stitches.get(i).sy2/gridSize));
 stitchMsg.add(stitches.get(i).topStitch);
 oscP5.send(stitchMsg, supercollider);
 };
 //make SuperCollider stop listening for info (hopefully it has built a big array by now)
 OscMessage stitchUnlistener = new OscMessage("/stitchListener");
 stitchUnlistener.add(0);
 oscP5.send(stitchUnlistener, supercollider); 
 started = 0;
 stitches.clear();
 }
 }*/

/*void keyPressed(KeyEvent e) {
 //make SuperCollider listen for info
 OscMessage stitchListener = new OscMessage("/stitchListener");
 stitchListener.add(1);
 oscP5.send(stitchListener, supercollider);
 //dump ALL data from Processing to SuperCollider
 for (int i = 0; i < stitches.size(); i++) {
 OscMessage stitchMsg = new OscMessage("/stitchInfo");
 stitchMsg.add((stitches.get(i).sx1/gridSize) - (stitches.get(i).sx2/gridSize));
 stitchMsg.add((stitches.get(i).sy1/gridSize) - (stitches.get(i).sy2/gridSize));
 stitchMsg.add(stitches.get(i).topStitch);
 oscP5.send(stitchMsg, supercollider);
 };
 //make SuperCollider stop listening for info (hopefully it has built a big array by now)
 OscMessage stitchUnlistener = new OscMessage("/stitchListener");
 stitchUnlistener.add(0);
 oscP5.send(stitchUnlistener, supercollider); 
 started = 0;
 stitches.clear();
 }*/