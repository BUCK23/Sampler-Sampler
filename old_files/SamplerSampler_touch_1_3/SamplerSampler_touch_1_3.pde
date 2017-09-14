import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress supercollider;

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
    stitchMsg.add(stitches.get(i).sx1);
    stitchMsg.add(stitches.get(i).sx2);
    stitchMsg.add(stitches.get(i).sy1);
    stitchMsg.add(stitches.get(i).sy2);
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
    //check the message is the right format, and if so log it to an array
    if (theOscMessage.typetag().contains("ffffi") == true){
      float[] direction = new float[5];
      //this would be done with a for loop but as the final value is a bool being transformed to an int i'll just leave it like this
      direction[0] = theOscMessage.get(0).floatValue();
      direction[1] = theOscMessage.get(1).floatValue();
      direction[2] = theOscMessage.get(2).floatValue();
      direction[3] = theOscMessage.get(3).floatValue();
      direction[4] = float(theOscMessage.get(4).intValue());
      println(direction);
    }
  }
}