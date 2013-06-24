class RadioButton
{
  static final int size = 20;
  color edgeColor = color(137, 135, 134);
  color baseColor = color (239, 239, 239);
  color checkColor = color (60, 60, 60);
  color textColor = color(0);
  float x, y;
  boolean checked;
  String text;

  RadioButton(String txt)
  {
    this(-1, -1, txt);
  }
  RadioButton(float xLoc, float yLoc, String txt)
  {
    this(xLoc, yLoc, txt, false);
  }
  RadioButton(float xLoc, float yLoc, String txt, boolean defChk)
  {
    text = txt;
    x = xLoc;
    y = yLoc;
    checked = defChk;
  }

  void displayGradient()
  {
    noStroke();
    float red= red(baseColor);
    float green= green(baseColor);
    float blue= blue(baseColor);
    for (int r = size; r > 0; --r) 
    {
      fill(red, green, blue);
      red -=2;
      green -=2;
      blue -=2;
      ellipse(x, y, r, r);
    }
  }

  void display()
  {
    displayGradient();
    if (checked)
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

