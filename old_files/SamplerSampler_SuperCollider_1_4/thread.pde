class Thread {
  float tx1;
  float ty1;
  float tx2;
  float ty2;
  boolean threadTop;
  
void drawThread(){
 
 for (int i = 0; i < stitches.size(); i++) {    // stitch array counter
         stitch = stitches.get(i);
    }

  if (threadTop == true){
      stroke(0, 250);
    } else {
      stroke(200, 80);
    }
    
    tx1 = stitch.sx2;            // start position for x thread line
    ty1 = stitch.sy2;            // start position for y thread line
    
    if (mousePressed) {
    tx2 = mouseX;
    ty2 = mouseY;
    } else {
    tx2 = int(tx2/gridSize)*gridSize;
    ty2 = int(ty2/gridSize)*gridSize;          
    }
    
  // draws thread line
      strokeWeight(3);
      line(tx1, ty1, tx2, ty2);
  }
}