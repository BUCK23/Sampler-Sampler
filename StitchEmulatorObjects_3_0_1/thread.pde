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
  }
  
  void down()  {        //  DOWN = 'c'
    move(0, 1);
  }
  
  void left()  {        //  LEFT = 's'
    move(-1, 0);
  }
  
  void right()  {       //  RIGHT = 'f'
    move(1, 0);
  }
  
  void upLeft()  {      //  UP+LEFT = 'w'
    move(-1, -1);
  }
  
  void upRight() {      //  UP+RIGHT = 'r'
    move(1, -1);
  }
  
  void downRight()  {   //  DOWN+RIGHT = 'v'
    move(1, 1);
  }
  
  void downLeft()  {    //  DOWN+LEFT = 'x'
    move(-1, 1);
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
                
                // ALTERNATIVE USING TRANSLATE TO REPOSITION X,Y POSITION

void draw() {
  boolean up = true;
  //int x = 0;
  //int y = 0;
  strokeWeight(0.1);
  for (Stitch stitch: stitches) {
   // int newX = x + stitch.x;
    // int newY = y + stitch.y;
    stroke(up ? color(0, 250) : color(100, 50));
   line(0, 0, stitch.x, stitch.y);
   
   translate(stitch.x, stitch.y);
   
   //line(x, y, newX, newY);
   // x = newX;
    //y = newY;
    up = ! up;
  }

}

}