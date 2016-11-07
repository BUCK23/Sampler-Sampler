Thread thread = new Thread();

int grid = 32;

void setup() {

  size(1000, 1000);

// draw plain background
  background(255);
 
// set grid % 
  scale(grid);

// dot grid
  for(int i = 0; i <= width/grid; i ++) {
  for(int j = 0; j <= height/grid; j ++){
    noStroke();
    fill(150);
    ellipse(i, j, 0.1, 0.1);
    }
  }
}

      // draw method
void draw(){
  
 scale(grid);       // set thread scale

  thread.draw();    
}

      // key press event
void keyPressed() {
  thread.moveChar(key);
  
}