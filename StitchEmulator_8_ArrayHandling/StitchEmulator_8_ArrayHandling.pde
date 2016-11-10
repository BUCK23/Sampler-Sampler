//import relevant OSC goodies
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress supercollider;

Thread thread = new Thread();

int grid = 10;

void setup() {

  frameRate(30);
  size(1000, 1000);

  //start relevant OSC goodies
  //starting reciever on port 12000
  oscP5 = new OscP5(this, 12000);
  //starting sender to sclang's default port
  supercollider = new NetAddress("127.0.0.1", 57120);

  // draw plain background
  background(255);

  // set grid % 
  scale(grid);

  // dot grid
  for (int i = 0; i <= width/grid; i ++) {
    for (int j = 0; j <= height/grid; j ++) {
      noStroke();
      fill(150);
      ellipse(i, j, 0.1, 0.1);
    }
  }
}

// draw method
void draw() {
  background(255);

  scale(grid);       // set thread scale

  //draw grid because reasons
  for (int i = 0; i <= width/grid; i ++) {
    for (int j = 0; j <= height/grid; j ++) {
      noStroke();
      fill(150);
      ellipse(i, j, 0.1, 0.1);
    }
  }

  thread.draw();
}

// key press event
void keyPressed(KeyEvent e) {
  thread.moveChar(key, e);
}

void clearScreen() {
  synchronized(thread.stitches) {
    thread.stitches.clear();
    for (int i = 0; i <= width/grid; i ++) {
      for (int j = 0; j <= height/grid; j ++) {
        noStroke();
        fill(150);
        ellipse(i, j, 0.1, 0.1);
      }
    }
  }
}

void mousePressed() {
  clearScreen();
}

//handler for OSC messages. will be used to recieve stitching information from SuperCollider
//it would be nice if this could take an array to do more complex modifiers
void oscEvent(OscMessage theOscMessage) {
  //checks if the message is being recieved from SuperCollider using the address
  if (theOscMessage.checkAddrPattern("/stitchSC")==true) {
    
    //make an arrayList to hold the instructions to be sent to the stitch emulator
    ArrayList<String> instructions = new ArrayList<String>();
    String direction = "";
    
    //Handler for STRINGS
    //if the typetag is a string, add the information to the first index of the arrayList
    if (theOscMessage.typetag().equals("s")) {
    //using the direction as a local variable so as not to compute it multiple times
    instructions.add(theOscMessage.get(0).stringValue());
    //check if the message contains relevant characters and send the relevant direction messages
    direction = instructions.get(0);
    if ( direction.equals("UP") ) {
      thread.up(1);
    }
    if ( direction.equals("DOWN") ) {
      thread.down(1);
    }

    if ( direction.equals("LEFT") ) {
      thread.left(1);
    }

    if ( direction.equals("RIGHT") ) {
      thread.right(1);
    }

    if ( direction.equals("UPLEFT")) {
      thread.upLeft(1);
    }

    if ( direction.equals("UPRIGHT")) {
      thread.upRight(1);
    }

    if ( direction.equals("DOWNLEFT")) {
      thread.downLeft(1);
    }

    if ( direction.equals("DOWNRIGHT")) {
      thread.downRight(1);
    }
    if ( direction.equals("CLEAR")) {
      clearScreen();
    }
   
    
    
    }
    
    ////MAKE A HANDLER FOR ARRAYS
     if (theOscMessage.typetag().equals("b")) {
      print(theOscMessage.get(0));
    }
    
  }
}