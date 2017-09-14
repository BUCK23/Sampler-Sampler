class Grid{
  
// draws grid
  void drawGrid(){
    stroke(0);
    strokeWeight(0.1);
    for (int i = 0; i < width/gridSize; i++)
      line(i*gridSize, 0, i*gridSize, height);  // vertical
    for (int i = 0; i < height/gridSize; i++)
      line(0, i*gridSize, width, i*gridSize);    // horizontal}}
      }
}