class Thread {                                              // create new class

                                // create 'stitch' object + add to stitch array
 
 ArrayList<Stitch> stitches = new ArrayList<Stitch>();      // Declaring the ArrayList, note the use of the syntax "<Stitch>" to indicate our intention to fill this ArrayList with Stitch objects
 
  void move (int x, int y) {            // method for creating object

     Stitch stitch = new Stitch();      // declare & construct new object
     stitch.x = x;                      // set object variable x
     stitch.y = y;                      // set object variable y
     stitches.add(stitch);              // Objects can be added to an ArrayList with add()
  }

                 // thread dirction method

  void up()  {          //  UP = 'e'
    move(0, -1);
    //send relevant OSC message to SuperCollider
    OscMessage stitchMsg = new OscMessage("/stitch");
    stitchMsg.add("UP");
    oscP5.send(stitchMsg,supercollider);
  }
  
  void down()  {        //  DOWN = 'c'
    move(0, 1);
    //send releant OSC message to SuperCollider
    OscMessage stitchMsg = new OscMessage("/stitch");
    stitchMsg.add("DOWN");
    oscP5.send(stitchMsg,supercollider);
  }
  
  void left()  {        //  LEFT = 's'
    move(-1, 0);
    //send releant OSC message to SuperCollider
    OscMessage stitchMsg = new OscMessage("/stitch");
    stitchMsg.add("LEFT");
    oscP5.send(stitchMsg,supercollider);
  }
  
  void right()  {       //  RIGHT = 'f'
    move(1, 0);
        //send releant OSC message to SuperCollider
    OscMessage stitchMsg = new OscMessage("/stitch");
    stitchMsg.add("RIGHT");
    oscP5.send(stitchMsg,supercollider);
  }
  
  void upLeft()  {      //  UP+LEFT = 'w'
    move(-1, -1);
        //send releant OSC message to SuperCollider
    OscMessage stitchMsg = new OscMessage("/stitch");
    stitchMsg.add("UPLEFT");
    oscP5.send(stitchMsg,supercollider);
  }
  
  void upRight() {      //  UP+RIGHT = 'r'
    move(1, -1);
        //send releant OSC message to SuperCollider
    OscMessage stitchMsg = new OscMessage("/stitch");
    stitchMsg.add("UPRIGHT");
    oscP5.send(stitchMsg,supercollider);
  }
  
  void downRight()  {   //  DOWN+RIGHT = 'v'
        //send releant OSC message to SuperCollider
    OscMessage stitchMsg = new OscMessage("/stitch");
    stitchMsg.add("DOWNRIGHT");
    oscP5.send(stitchMsg,supercollider);
    move(1, 1);
  }
  
  void downLeft()  {    //  DOWN+LEFT = 'x'
    move(-1, 1);
        //send releant OSC message to SuperCollider
    OscMessage stitchMsg = new OscMessage("/stitch");
    stitchMsg.add("DOWNLEFT");
    oscP5.send(stitchMsg,supercollider);
  }
  

              // direction control keys function

  void moveChar(char c) {    // Declare variable 'c' of type character
    if (c == 'e') {
      up();
  } else if (c == 'c')  {    //  DOWN = 'c'
      down();
  } else if (c == 's')  {    //  LEFT = 's'
    left();
  } else if (c == 'f')  {    //  RIGHT = 'f'
    right();
  }  else if (c == 'w') {    //  UP+LEFT = 'w'
    upLeft();
  }  else if (c == 'r') {    //  UP+RIGHT = 'r'
    upRight();
  }  else if (c == 'v') {    //  DOWN+RIGHT = 'v'
    downRight();
  }  else if (c == 'x') {    //  DOWN+LEFT = 'x'
    downLeft();
    }
  }

                // draw thread function

  void draw() {
    boolean up = true;                        // is this a top thread?
    int x = 0;                                // declare & set x pos
    int y = 0;                                // declare & set y pos
    strokeWeight(0.1);                        // set stroke weight
    for (Stitch stitch: stitches) {           // for loop - for (init; test; update) - calling from stitch array
      int newX = x + stitch.x;                // decaler var newX (line endpoint) x pos + values from move function (see stitch object arguments)
      int newY = y + stitch.y;                // decaler var newY (line endpoint) y pos + values from move function (see stitch object arguments)
      stroke(up ? color(0, 250) : color(200, 20));     // set stroke colour depending on boolean up true/false
                                                // result = test ? expression1 : expression2
                                                // is equivalent to this structure: 
                                                              /*  if (test) {
                                                                    result = expression1                                                               
                                                                      } else {                        
                                                                    result = expression2 
                                                                   }                          */
      line(x, y, newX, newY);                  // draw stitch
      x = newX;                                // makes stitch end start point x for next stitch
      y = newY;                                // makes stitch end start point x for next stitch
      up = ! up;                               // makes boolean up opposite for next stitch
    }
  }

}