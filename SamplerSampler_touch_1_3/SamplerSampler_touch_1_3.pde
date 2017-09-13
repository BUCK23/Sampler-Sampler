int gridSize = 32; //set grid size.
ArrayList<Stitch> stitches = new ArrayList<Stitch>(); // create an empty array list

Grid grid;      // declare Grid object
Thread thread;  // declare Thread object
Stitch stitch;  // declare Stitch object


void setup() {

  fullScreen();
  noFill();
  noCursor();
  grid = new Grid();                  // make initial Grid object
  thread = new Thread();    //make initial Thread object
  stitch = new Stitch(0, 0, 0, 0, true);    // make initial Stitch object
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

void mouseReleased() {
  thread.tx2 = int(thread.tx2/gridSize)*gridSize;        // gives end points for stitch on mouse release        
  thread.ty2 = int(thread.ty2/gridSize)*gridSize;  
  stitches.add(new Stitch(thread.tx1, thread.ty1, thread.tx2, thread.ty2, thread.threadTop));  // add stitch objects to array
  thread.threadTop = ! thread.threadTop;                                                        // changes stitch colour
}