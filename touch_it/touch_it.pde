int gridSize = 50; //set grid size.
ArrayList<Stitch> stitches = new ArrayList<Stitch>(); // create an empty array list.// declare Stitch ArryList


Grid grid;      // declare Grid object
Thread thread;  // declare Thread object
Stitch stitch;  // declare Stitch object


void setup() {
  
  fullScreen();
  noFill();

  grid = new Grid();                  // make initial Grid object
  thread = new Thread();    //make initial Thread object
  stitch = new Stitch(0, 0, 0, 0);    // make initial Stitch object

}

void draw() {
  background(255);      // resets background
  
  grid.drawGrid();      // draws grid
      
// draw all stitches
  for (int i = 0; i < stitches.size(); i++) {
    Stitch stitch = stitches.get(i);
    stitch.drawStitches();
  }

  thread.drawThread();      // draws thread

}