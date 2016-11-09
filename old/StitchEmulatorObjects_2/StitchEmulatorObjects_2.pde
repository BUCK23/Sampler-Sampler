//import relevant OSC goodies
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress supercollider;

Thread thread = new Thread();

int grid = 32;

void setup() {

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

  scale(grid);       // set thread scale

  thread.draw();
}

// key press event
void keyPressed() {
  thread.moveChar(key);
}

//handler for OSC messages. will be used to recieve stitching information from SuperCollider
void oscEvent(OscMessage theOscMessage) {
  //checks if the message is being recieved from SuperCollider using the address
  if (theOscMessage.checkAddrPattern("/stitchSC")==true) {
    //using the direction as a local variable so as not to compute it multiple times
    String direction = theOscMessage.get(0).stringValue();

    //check if the message contains relevant characters and send the relevant direction messages
    if ( direction.equals("UP") ) {
      thread.moveChar('e');
    }

    if ( direction.equals("DOWN") ) {
      thread.moveChar('c');
    }

    if ( direction.equals("LEFT") ) {
      thread.moveChar('s');
    }

    if ( direction.equals("RIGHT") ) {
      thread.moveChar('f');
    }

    if ( direction.equals("UPLEFT")) {
      thread.moveChar('w');
    }

    if ( direction.equals("UPRIGHT")) {
      thread.moveChar('r');
    }

    if ( direction.equals("DOWNLEFT")) {
      thread.moveChar('x');
    }

    if ( direction.equals("DOWNRIGHT")) {
      thread.moveChar('v');
    }
  }
}