class Stitch {

  float sx1;
  float sy1;
  float sx2;
  float sy2;  
  
 Stitch (float tempsx1, float tempsy1, float tempsx2, float tempsy2){
    
        sx1 = tempsx1;
        sy1 = tempsy1;
        sx2 = tempsx2;
        sy2 = tempsy2;
  }

// draw method
    void drawStitches(){

        strokeWeight(3);
        stroke(204, 102, 0);
        line (sx1, sy1, sx2, sy2);
      }
}