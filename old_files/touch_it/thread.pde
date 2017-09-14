class Thread {
  float tx1;
  float ty1;
  float tx2;
  float ty2;
  
void drawThread(){
 
 for (int i = 0; i < stitches.size(); i++) {    // stitch array counter
         stitch = stitches.get(i);
  }

    tx1 = stitch.sx2;            // start position for x thread line
    ty1 = stitch.sy2;            // start position for y thread line
    
    if (mousePressed) {
    tx2 = mouseX;
    ty2 = mouseY;
  } else {
    tx2 = int(tx2/gridSize)*gridSize;
    ty2 = int(ty2/gridSize)*gridSize;
    stitches.add(new Stitch(tx1, ty1, tx2, ty2));
  }
  
  // draws thread line
      strokeWeight(3);
      stroke(0);
      line(tx1, ty1, tx2, ty2);
     }
  
  

}