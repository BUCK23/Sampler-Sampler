/*

This version created to work in accordance with a SuperCollider sampling setup

*/

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress supercollider;
// maybe this don't have to be global, but this is the previous x and y co-ordinates
float prevX = 0.0;
float prevY = 0.0;


int gridSize = 32; //set grid size.
ArrayList<Stitch> stitches = new ArrayList<Stitch>(); // create an empty array list

Grid grid;      // declare Grid object
Thread thread;  // declare Thread object
Stitch stitch;  // declare Stitch object


void setup() {

  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1",57120);
  
  fullScreen();
  noFill();
  noCursor();
  grid = new Grid();                  // make initial Grid object
  thread = new Thread();    //make initial Thread object
  stitch = new Stitch(0, 0, 0, 0, true);    // make initial Stitch object
}

void draw() {
  background(255);      // resets background
  grid.drawGrid();      // draws grid

  // draw all stitches
  for (int i = 0; i < stitches.size(); i++) {
    Stitch stitch = stitches.get(i);
    stitch.drawStitches();
  }
  thread.drawThread();      // draws thread
}

void mouseReleased() {
  thread.tx2 = int(thread.tx2/gridSize)*gridSize;        // gives end points for stitch on mouse release        
  thread.ty2 = int(thread.ty2/gridSize)*gridSize;  
  stitches.add(new Stitch(thread.tx1, thread.ty1, thread.tx2, thread.ty2, thread.threadTop));  // add stitch objects to array
  thread.threadTop = ! thread.threadTop;                                                        // changes stitch colour
}


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//NEW STUFF GOES HERE!!!!!////////////////////////////////////////
//////////////////////////////////////////////////////////////////



void keyPressed(KeyEvent e) {
  //make SuperCollider listen for info
  OscMessage stitchListener = new OscMessage("/stitchListener");
  stitchListener.add(1);
  oscP5.send(stitchListener, supercollider);
  //dump ALL data from Processing to SuperCollider
  for (int i = 0; i < stitches.size(); i++){
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
}

/*
//NOW ADD;

An OSCMessage receiver which can take individual stitch arrays and turn them into stitch events on the canvas.

Then a two-way communication protocol with SuperCollider

*/

void oscEvent(OscMessage theOscMessage) {
  //checks if the message is being recieved from SuperCollider using the address
  if (theOscMessage.checkAddrPattern("/stitchSC")==true) {
    //check the message is the right format, and if so stitch it!
    if (theOscMessage.typetag().equals("ffffi") == true){
      stitches.add(new Stitch(
      //adding the previous X and Y co-ordinates in order to 
      (theOscMessage.get(0).floatValue()+prevX)*gridSize, 
      (theOscMessage.get(1).floatValue()+prevY)*gridSize, 
      (theOscMessage.get(2).floatValue()+prevX)*gridSize, 
      (theOscMessage.get(3).floatValue()+prevY)*gridSize, 
      boolean(theOscMessage.get(4).intValue())
      ));  // add stitch objects to array
      //save the final set of co-ordinates to be used later for 'tiling' stitches
    }
    if (theOscMessage.typetag().equals("ffffii") == true){
      stitches.add(new Stitch(
      (theOscMessage.get(0).floatValue()+prevX)*gridSize, 
      (theOscMessage.get(1).floatValue()+prevY)*gridSize, 
      (theOscMessage.get(2).floatValue()+prevX)*gridSize, 
      (theOscMessage.get(3).floatValue()+prevY)*gridSize, 
      boolean(theOscMessage.get(4).intValue())
      ));
      //if there's another int (meaning this is the last index), re-start the prevX value?
      //THIS IS NOT RIGHT. This needs to be the last X and Y values of the final stitch that has been made.
      prevX = (stitches.get(stitches.size()-1).sx2)/gridSize;
      prevY = (stitches.get(stitches.size()-1).sy2)/gridSize;
    }
  }
}