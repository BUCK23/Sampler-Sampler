class Thread {
  float tx1;
  float ty1;
  float tx2;
  float ty2;
  boolean threadTop;

  void drawThread() {

    for (int i = 0; i < stitches.size(); i++) {    // stitch array counter
      stitch = stitches.get(i);
    }

     if (started != 0) {
    thread.tx1 = stitch.sx2;            // start position for x thread line
    thread.ty1 = stitch.sy2;            // start position for y thread line
     }

    if (mousePressed) {    
      if (started == 0) {    // sets first stitch start point
        stitches.add(new Stitch((mouseX/gridSize)*gridSize, (mouseY/gridSize)*gridSize, (mouseX/gridSize)*gridSize, (mouseY/gridSize)*gridSize, thread.threadTop));
        started = 1;
      };
      
      tx2 = (mouseX/gridSize)*gridSize;
      ty2 = (mouseY/gridSize)*gridSize;
    } else {
      tx2 = int(tx2/gridSize)*gridSize;
      ty2 = int(ty2/gridSize)*gridSize;
    }

//sets thread colour top/bottom
       if (threadTop == true) {
      stroke(0, 250);
    } else {
      stroke(200, 80);
    }

    // draws thread line
    strokeWeight(3);
    line(tx1, ty1, tx2, ty2);
  }
}