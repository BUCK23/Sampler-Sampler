class Stitch {

  float sx1;
  float sy1;
  float sx2;
  float sy2;  
  boolean topStitch;
  
 Stitch (float tempsx1, float tempsy1, float tempsx2, float tempsy2, boolean temptopStitch){
    
        sx1 = tempsx1;
        sy1 = tempsy1;
        sx2 = tempsx2;
        sy2 = tempsy2;
        topStitch = temptopStitch;
  }

// draw method
    void drawStitches(){

  if (topStitch == true){
      stroke(0, 250);
    } else {
      stroke(200, 80);
    }
    
    strokeWeight(3);
    // this works
    line ((sx2)*gridSize, (sy2)*gridSize, ((sx2)+(sx1))*gridSize, ((sy2)+(sy1))*gridSize);
    //line (((sx2)+(sx1))*gridSize, ((sy2)+(sy1))*gridSize, (sx2)*gridSize, (sy2)*gridSize);
   //println("line = "+((sx1)*gridSize) + "   " + ((sy1)*gridSize) + "   "+ ((sx2)*gridSize) + "   "+ ((sy2)*gridSize));
    
    }
}