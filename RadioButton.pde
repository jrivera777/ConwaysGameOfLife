class RadioButton
{
  static final int size = 20;
  color edgeColor = color(137, 135, 134);
  color baseColor = color (239, 239, 239);
  color checkColor = color (60, 60, 60);
  color textColor = color(0);
  int x, y;
  boolean checked;
  String text;
  
  RadioButton(String txt)
  {
    this(-1, -1, txt);
  }
  RadioButton(int xLoc, int yLoc, String txt)
  {
    this(xLoc, yLoc, txt, false);
  }
  RadioButton(int xLoc, int yLoc, String txt, boolean defChk)
  {
    text = txt;
    x = xLoc;
    y = yLoc;
    checked = defChk;
  }
  
  void display()
  {
    stroke(edgeColor);
    fill(baseColor);
    ellipse(x, y, size, size);
  
    if(checked)
    {
      noStroke();
      fill(checkColor);
      ellipse(x, y, size/2, size/2);
    }  
    
    fill(textColor);
    text(text, x + size + 5, y + 5);
  }
  
  boolean isInButton(int xLoc, int yLoc)
  {
    float disX = x - xLoc;
    float disY = y - yLoc;
    return sqrt(sq(disX) + sq(disY)) < (size / 2);
  }

}


