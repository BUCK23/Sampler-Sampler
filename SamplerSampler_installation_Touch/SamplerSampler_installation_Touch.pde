import processing.io.*;
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress supercollider;
int gridSize = 60; //set grid size.
ArrayList<Stitch> stitches = new ArrayList<Stitch>(); // create an empty array list
int started = 0; //sets start point

Grid grid;      // declare Grid object
Thread thread;  // declare Thread object
Stitch stitch;  // declare Stitch object
Needle needle; // declare Needle object

void setup() {

  fullScreen();
  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("192.168.0.80", 57120);
  noFill();
  noCursor();
  grid = new Grid();                  // make initial Grid object
  thread = new Thread();              //make initial Thread object
  needle = new Needle();
  
  //GPIO.pinMode(4, GPIO.INPUT);    // initalise GPIO pins for buttons (need to check button set up on raspberry pi)
  //GPIO.pinMode(5, GPIO.INPUT);
}

void draw() {
  background(255);      // resets background
  grid.drawGrid();      // draws grid


  // draw all stitches
  for (int i = 0; i < stitches.size(); i++) {
    Stitch stitch = stitches.get(i);
    stitch.drawStitches();
  }
  
  if (mousePressed == true){
      needle.drawNeedle();
  }
  
  thread.drawThread();      // draws thread
}

void mouseReleased() {
  thread.tx2 = int(thread.tx2/gridSize)*gridSize;        // gives end points for stitch on mouse release        
  thread.ty2 = int(thread.ty2/gridSize)*gridSize;  
  stitches.add(new Stitch(thread.tx1, thread.ty1, thread.tx2, thread.ty2, thread.threadTop));  // add stitch objects to array
  thread.threadTop = ! thread.threadTop;                                                        // changes stitch colour
}

// ------------------------------------------------------------------------------------

// SEND AND CLEAR BUTTONS

// Sends Sample Button
//void sendSample(){
 //if (GPIO.digitalRead(4) == GPIO.HIGH) {
    //SEND SAMPLE SUPERCOLIDER 
   // stitches.clear();
    //}
//}


// clear screen button press
//void clearButton(){
 //if (GPIO.digitalRead(5) == GPIO.HIGH) {
   // stitches.clear();
    //}
//}

void keyPressed(KeyEvent e) {
  //make SuperCollider listen for info
  OscMessage stitchListener = new OscMessage("/stitchListener");
  stitchListener.add(1);
  oscP5.send(stitchListener, supercollider);
  //dump ALL data from Processing to SuperCollider
  for (int i = 0; i < stitches.size(); i++) {
    OscMessage stitchMsg = new OscMessage("/stitchInfo");
    stitchMsg.add(stitches.get(i).sx1/gridSize);
    stitchMsg.add(stitches.get(i).sy1/gridSize);
    stitchMsg.add(stitches.get(i).sx2/gridSize);
    stitchMsg.add(stitches.get(i).sy2/gridSize);
    stitchMsg.add(stitches.get(i).topStitch);
    oscP5.send(stitchMsg, supercollider);
  };
  //make SuperCollider stop listening for info (hopefully it has built a big array by now)
  OscMessage stitchUnlistener = new OscMessage("/stitchListener");
  stitchUnlistener.add(0);
  oscP5.send(stitchUnlistener, supercollider); 
  stitches.clear();// create an empty array list
  started = 0;
}