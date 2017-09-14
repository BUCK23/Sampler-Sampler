/*
This sketch is an attempt to get the stitching system working with only changes in direction rather than absolute co-ordinates



*/


import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress supercollider;
// maybe this don't have to be global, but this is the previous x and y co-ordinates
float startPrevX = 0.0;
float startPrevY = 0.0;
float endPrevX = 0.0;
float endPrevY = 0.0;
float prevX = 0.0;
float prevY = 0.0;
import processing.io.*;
int gridSize = 40; //set grid size.
ArrayList<Stitch> stitches = new ArrayList<Stitch>(); // create an empty array list
int started = 0; //sets start point
Grid grid;      // declare Grid object
Thread thread;  // declare Thread object
Stitch stitch;  // declare Stitch object

void setup() {
  oscP5 = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
  fullScreen();
  noFill();
  noCursor();
  grid = new Grid();                  // make initial Grid object
  thread = new Thread();              //make initial Thread object
  //GPIO.pinMode(4, GPIO.INPUT);    // initalise GPIO pins for buttons (need to check button set up on raspberry pi)
  //GPIO.pinMode(5, GPIO.INPUT);
  thread.tx1 = (width/gridSize)/2;
  thread.ty1 = (height/gridSize)/2;
  prevX = (width/gridSize)/2;
  prevY = (height/gridSize)/2;
}

void draw() {
  background(255);      // resets background
  grid.drawGrid();      // draws grid
  // draw all stitches
  for (int i = 0; i < stitches.size(); i++) {
    Stitch stitch = stitches.get(i);
    stitch.drawStitches();
  }
  //thread.drawThread();      // draws thread
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

void clearScreen() {
  //clear the array (which clears the screen)
  stitches.clear();
  //center the current stitch
  thread.tx1 = (width/gridSize)/2;
  thread.ty1 = (height/gridSize)/2;
  prevX = (width/gridSize)/2;
  prevY = (height/gridSize)/2;
}

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
  clearScreen();
  started = 0;
}

/*
//NOW ADD;
 
 An OSCMessage receiver which can take individual stitch arrays and turn them into stitch events on the canvas.
 
 Then a two-way communication protocol with SuperCollider
 
 */

void oscEvent(OscMessage theOscMessage) {
  //print(theOscMessage.typetag());
  //checks if the message is being recieved from SuperCollider using the address
  if (theOscMessage.checkAddrPattern("/stitchSC")==true) {
    started = 1;
    //if the stitch is going to be outside the boundary of the screen, then reset it and clear the screen.
    if ((theOscMessage.get(0).floatValue()+(prevX))*gridSize < 0 || (theOscMessage.get(0).floatValue()+(prevX))*gridSize > width)
    {
      clearScreen();
    }
    if ((theOscMessage.get(1).floatValue()+(prevY))*gridSize < 0 || (theOscMessage.get(1).floatValue()+(prevY))*gridSize > height)
    {
      clearScreen();
    }
    //check the message is the right format, and if so stitch it!
    if (theOscMessage.typetag().equals("ffffi") == true) {
      //Add a new stitch to the array based on OSCMessages
      stitches.add(new Stitch(
        //adding the previous X and Y co-ordinates in order to 
        (theOscMessage.get(0).floatValue()+(prevX))*gridSize, 
        (theOscMessage.get(1).floatValue()+(prevY))*gridSize, 
        (theOscMessage.get(2).floatValue()+(prevX))*gridSize, 
        (theOscMessage.get(3).floatValue()+(prevY))*gridSize, 
        boolean(theOscMessage.get(4).intValue())
        ));  // add stitch objects to array
      //save the final set of co-ordinates to be used later for 'tiling' stitches
    }
    if (theOscMessage.typetag().equals("ffffis") == true) {
      //println(theOscMessage.get(5).stringValue());
      stitches.add(new Stitch(
        (theOscMessage.get(0).floatValue()+(prevX))*gridSize, 
        (theOscMessage.get(1).floatValue()+(prevY))*gridSize, 
        (theOscMessage.get(2).floatValue()+(prevX))*gridSize, 
        (theOscMessage.get(3).floatValue()+(prevY))*gridSize, 
        boolean(theOscMessage.get(4).intValue())
        ));
      //calculate the start and end points of the stitch, working out the difference, then assigning that to 'prevX' and 'prevY'
      if (theOscMessage.get(5).stringValue().equals("start") == true) {
        startPrevX = theOscMessage.get(0).floatValue() + (prevX); 
        startPrevY = theOscMessage.get(1).floatValue() + (prevY);
      } else if (theOscMessage.get(5).stringValue().equals("end") == true) {
        endPrevX = theOscMessage.get(2).floatValue() + (prevX);
        endPrevY = theOscMessage.get(3).floatValue() + (prevY);   
        //iterate the prevX
        prevX = (endPrevX - startPrevX) + (prevX);
        prevY = (endPrevY - startPrevY) + (prevY);
        println(prevX);
      }
    }
  }
}