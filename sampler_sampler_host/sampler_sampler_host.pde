/*
Sampler-Sampler 1.0

Blackwok Stitching Emulator - processing sketch

See the README.md file of the master directory for more detailed information about the project

SETUP:

Switch between 'client' and 'host' mode using the variables before setup:
mode = "client"
or
mode = "host"

The IP address of the host can be changed by changing the hostIP variable

HOW TO USE:

When the sketch is started, keyboard keys are used to create blackwork stitches on the processing window. The keys used for movement are in a circle:

e = UP
c = DOWN
f = RIGHT
s = LEFT
w = UPLEFT
r = UPRIGHT
v = DOWNRIGHT
x = DOWNLEFT

There are also two modifier keys that can be used for creating alternate stitching patterns:

ALT + direction key = draw a long stitch, where a stitch will remain on the same 'side' of the canvas for a double distance

SHIFT + direction key = draw squares (UP, DOWN, LEFT, RIGHT) and crosses (UPLEFT, UPRIGHT, DOWNLEFT, DOWNRIGHT) in one button press. This speeds up the creation of patterns that may contain multiple complex units.

SONIFICATION & SAMPLING:

Note that this processing sketch is one half of Sampler-Sampler, which is designed to be run in tandem with the SuperCollider live coding microlanguage also in this repo. Please see the SuperCollider folder for instructions on how to use this.
*/



//import relevant OSC goodies
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress supercollider;

//choose betweeen "client" or "host" here
String mode = "client";

Thread thread = new Thread();

String hostIP = "192.168.1.2";
int hostPort = 57120;

String clientIP = "127.0.0.1";
int clientPort = 57120;

int grid = 32;

void setup() {

  frameRate(30);
  //size(1000, 1000);
  fullScreen();
  //start relevant OSC goodies
  //starting reciever on port 12000
  oscP5 = new OscP5(this, 12000);
  //starting sender to sclang's default port
  if (mode == "client"){
  supercollider = new NetAddress(clientIP, clientPort);
  } else if (mode == "host"){
  supercollider = new NetAddress(hostIP, hostPort);  
  }

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

  //draw grid
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

//function to clear screen and re-scale acording to set scaler
void clearScreen(int scaler) {
  background(255);
  grid = scaler;
  scale(scaler);
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
  OscMessage stitchMsg = new OscMessage("/screenCleared");
  stitchMsg.add("CLEAR!");
  oscP5.send(stitchMsg, supercollider);
}

//function to clear screen and re-scale acording to set scaler
//a separate function to work with SuperCollider function so as not to feed back.
void clearScreenSC(int scaler) {
  background(255);
  grid = scaler;
  scale(scaler);
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
  clearScreen(grid);
  OscMessage stitchMsg = new OscMessage("/hostClearArray");
  stitchMsg.add("CLEARING CURRENT PATTERN");
  oscP5.send(stitchMsg, supercollider);
}

//handler for OSC messages. will be used to recieve stitching information from SuperCollider
//it would be nice if this could take an array to do more complex modifiers
void oscEvent(OscMessage theOscMessage) {
  //checks if the message is being recieved from SuperCollider using the address
  if (theOscMessage.checkAddrPattern("/stitchSC")==true) {

    //make an arrayList to hold the instructions to be sent to the stitch emulator
    ArrayList<String> instructions =   new ArrayList<String>();
    String direction = "";

    //Handler for STRINGS
    //if the typetag is a string, add the information to the first index of the arrayList
    //this could do with a regular expression to check that it only contains strings, but i cannot be bothered to write one right now
    //instead I will use the legnth of the typetag of the string


    //I NEED TO MAKE THIS SO THAT IT DOES NOT PASS SI AS ARGUMENT BECAUSE IT BREAKS
    if (theOscMessage.typetag().contains("s") && theOscMessage.typetag().contains("i") == false) {
      for (int i = 0; i < theOscMessage.typetag().length(); i++) {
        /*
    //THIS MAY NOT BE NEEDED
         //using the direction as a local variable so as not to compute it multiple times
         instructions.add(theOscMessage.get(i).stringValue());
         //check if the message contains relevant characters and send the relevant direction messages
         direction = instructions.get(i);
         */

        direction = theOscMessage.get(i).stringValue();

        if ( direction.equals("UP") ) {
          thread.up(1, 1);
        }
        if ( direction.equals("DOWN") ) {
          thread.down(1, 1);
        }

        if ( direction.equals("LEFT") ) {
          thread.left(1, 1);
        }

        if ( direction.equals("RIGHT") ) {
          thread.right(1, 1);
        }

        if ( direction.equals("UPLEFT")) {
          thread.upLeft(1, 1);
        }

        if ( direction.equals("UPRIGHT")) {
          thread.upRight(1, 1);
        }

        if ( direction.equals("DOWNLEFT")) {
          thread.downLeft(1, 1);
        }

        if ( direction.equals("DOWNRIGHT")) {
          thread.downRight(1, 1);
        }

        if ( direction.equals("UPLONG") ) {
          thread.up(2, 1);
        }
        if ( direction.equals("DOWNLONG") ) {
          thread.down(2, 1);
        }

        if ( direction.equals("LEFTLONG") ) {
          thread.left(2, 1);
        }

        if ( direction.equals("RIGHTLONG") ) {
          thread.right(2, 1);
        }

        if ( direction.equals("UPLEFTLONG")) {
          thread.upLeft(2, 1);
        }

        if ( direction.equals("UPRIGHTLONG")) {
          thread.upRight(2, 1);
        }

        if ( direction.equals("DOWNLEFTLONG")) {
          thread.downLeft(2, 1);
        }

        if ( direction.equals("DOWNRIGHTLONG")) {
          thread.downRight(2, 1);
        }
      }
    }

    if (theOscMessage.typetag().contains("si")) {
      if (theOscMessage.get(0).stringValue().equals("CLEAR")) {
        int size = theOscMessage.get(1).intValue();
        //sends to SuperCollider version to avoid feedback
        clearScreenSC(size);
      }
    }
  }
}