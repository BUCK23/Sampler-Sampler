class Thread {                                              // create new class

                                // create 'stitch' object + add to stitch array
 
 ArrayList<Stitch> stitches = new ArrayList<Stitch>();      // Declaring the ArrayList, note the use of the syntax "<Stitch>" to indicate our intention to fill this ArrayList with Stitch objects
 
 boolean isEven () {
   return (stitches.size()%2 == 0);
 }
 
  void move (int x, int y) {            // method for creating object

     Stitch stitch = new Stitch();      // declare & construct new object
     stitch.x = x;                      // set object variable x
     stitch.y = y;                      // set object variable y
     stitches.add(stitch);              // Objects can be added to an ArrayList with add()
  }

  

                 // thread dirction method

  void up(int n)  {          //  UP = 'e'
    move(0, 0-n);
  }
  
  void down(int n)  {        //  DOWN = 'c'
    move(0, n);
  }
  
  void left(int n)  {        //  LEFT = 's'        // NOT GOING LEFT??
    move(0-n, 0);
  }
  
  void right(int n)  {       //  RIGHT = 'f'
    move(n, 0);
  }
  
  void upLeft(int n)  {      //  UP+LEFT = 'w'
    move(0-n, 0-n);
  }
  
  void upRight(int n) {      //  UP+RIGHT = 'r'
    move(n, 0-n);
  }
  
  void downRight(int n)  {   //  DOWN+RIGHT = 'v'
    move(n, n);
  }
  
  void downLeft(int n)  {    //  DOWN+LEFT = 'x'
    move(0-n, n);
  }
  

              // direction control keys function

  void moveChar(char c, KeyEvent e) {    // Declare variable 'c' of type character
    if (c == 'e') {          // UP = 'e'
      up(e.isAltDown() ? 2 : 1);
  } else if (c == 'c')  {    //  DOWN = 'c'
      down(e.isAltDown() ? 2 : 1);
  } else if (c == 's')  {    //  LEFT = 's'
    left(e.isAltDown() ? 2 : 1);
  } else if (c == 'f')  {    //  RIGHT = 'f'
    right(e.isAltDown() ? 2 : 1);
  }  else if (c == 'w') {    //  UP+LEFT = 'w'
    upLeft(e.isAltDown() ? 2 : 1);
  }  else if (c == 'r') {    //  UP+RIGHT = 'r'
    upRight(e.isAltDown() ? 2 : 1);
  }  else if (c == 'v') {    //  DOWN+RIGHT = 'v'
    downRight(e.isAltDown() ? 2 : 1);
  }  else if (c == 'x') {    //  DOWN+LEFT = 'x'
    downLeft(e.isAltDown() ? 2 : 1);
    }
    
    //SQUARES

    else if (c == 'E') {   // DRAW SQUARE TOP RIGHT
      up(1);
      right(1);
      down(1);
      left(1);
      right(1);
      up(1);
      left(1);
      down(1);
    }  else if (c == 'F') {      // DRAW SQUARE DOWN RIGHT
      down(1);
      right(1);
      up(1);
      left(1);
      right(1);
      down(1);
      left(1);
      up(1);
    }   else if (c == 'C') {   // DRAW SQAURE DOWN LEFT
      down(1);
      left(1);
      up(1);
      right(1);
      left(1);
      down(1);
      right(1);
      up(1);
  }  else if (c == 'S')  {     // DRAW SQUARE UP LEFT
      up(1);
      left(1);
      down(1);
      right(1);
      left(1);
      up(1);
      right(1);
      down(1);
  }  else if (c == 'S')  {     // DRAW SQUARE UP LEFT
    up(1);
    left(1);
    down(1);
    right(1);
    left(1);
    up(1);
    right(1);
    down(1);
}

// CROSSES

else if (c == 'R') {            // CROSS TOP RIGHT
  if (isEven() == false) {
    right(1);
    upLeft(1);
    right(1);
    downLeft(1);
    } else {
      upRight(1);
      left(1);
      downRight(1);
      left(1);
  }
}

else if (c == 'V') {                  // CROSS BOTTOM RIGHT
  if (isEven() == false) {
    right(1);
    downLeft(1);
    right(1);
    upLeft(1);
    } else {
      downRight(1);
      left(1);
      upRight(1);
      left(1);
  }
}

else if (c == 'X') {                  // CROSS BOTTOM LEFT
  if (isEven() == false) {
    left(1);
    downRight(1);
    left(1);
    upRight(1);
    } else {
      downLeft(1);
      right(1);
      upLeft(1);
      right(1);
  }
}

else if (c == 'W') {                  // CROSS TOP LEFT
  if (isEven() == false) {
    left(1);
    upRight(1);
    left(1);
    downRight(1);
    } else {
      upLeft(1);
      right(1);
      downLeft(1);
      right(1);
  }
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