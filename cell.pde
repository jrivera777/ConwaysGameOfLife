class Cell 
{
  int x,y;   
  int w,h;   
  color col;     
  
  Cell(int tempX, int tempY, int tempW, int tempH, color tempC) 
  {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    col = tempC;
  }
  
  void display() 
  {
    fill(col);
    stroke(200);
    rect(x,y,w,h);
  }
}
