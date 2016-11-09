Thread thread = new Thread();

int grid = 32;


void setup() {

  size(1000, 1000);

}

void draw(){
  
  // draw plain background
  background(255);
  
scale(grid);


// dot grid
  for(int i = 0; i <= width/grid; i ++) {
  for(int j = 0; j <= height/grid; j ++){
    noStroke();
    fill(150);
    ellipse(i, j, 0.1, 0.1);
    }
  }
  
    thread.draw();      // Multiple calls of draw thread create generative patterns - ADD OR DELETE AS MANY AS YOU LIKE! IT'S FUN!
    thread.draw();
        thread.draw();
    thread.draw();

}

void keyPressed() {
  thread.moveChar(key);
  
}