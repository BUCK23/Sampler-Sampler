import processing.io.*;
int gridSize = 60; //set grid size.
ArrayList<Stitch> stitches = new ArrayList<Stitch>(); // create an empty array list
int started = 0; //sets start point

Grid grid;      // declare Grid object
Thread thread;  // declare Thread object
Stitch stitch;  // declare Stitch object
Needle needle; // declare Needle object

void setup() {

  fullScreen();
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

void keyPressed() {
      stitches.clear(); // clears array
      started = 0; //resets start point
    }