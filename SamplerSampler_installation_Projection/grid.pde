class Grid{
  
// draws grid
  void drawGrid(){

    for (int i = 0; i <= width/gridSize; i ++) {
    for (int j = 0; j <= height/gridSize; j ++) {
      noStroke();
      fill(150);
      ellipse(i*gridSize, j*gridSize, 4, 4);
    }
  }

}
}