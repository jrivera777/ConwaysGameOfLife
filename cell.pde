class Cell 
{
  float x, y;   
  float w, h;   
  color col;     

  Cell(float tempX, float tempY, float tempW, float tempH, color tempC) 
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
    rect(x, y, w, h);
  }
}

