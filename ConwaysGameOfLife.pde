/*============DEBUGGING==============*/
static boolean DEBUG = true;

void printDebug(String msg)
{
  if (DEBUG)
    println(msg);
}
/*===================================*/

Cell[][] grid;
int[][] buffer;
RadioButton[] rBtns;
int rows, cols;
float cell_w, cell_h;
color dead, alive;
float boardHeight, boardWidth;
float buttonAreaHeight, buttonAreaWidth;
int interval, lastTime;
boolean paused;
String selected="";

void setup()
{
  size(580, 700);
  paused = true;
  buttonAreaHeight = height / 5;
  buttonAreaWidth = width;
  boardHeight = height - buttonAreaHeight;
  boardWidth = width;
  background(50);
  interval = 100; 
  rows = 75;
  cols = 75;
  cell_w = width / (float)cols;
  cell_h = boardHeight / rows;


  printDebug("Cell width = " + cell_w);
  printDebug("Cell height = " + cell_h); 

  rBtns = new RadioButton[5];
  rBtns[0] = new RadioButton("Glider");
  rBtns[1] = new RadioButton("Beacon");
  rBtns[2] = new RadioButton("Toad");
  rBtns[3] = new RadioButton("Gosper Glider Gun");
  rBtns[4] = new RadioButton("Lightweight Spaceship");
  drawButtons(rBtns);
  initConwaysGameOfLife(color(255, 255, 255), color(0), 10);
}

void draw()
{
  drawButtons(rBtns);
  for (int i = 0; i < cols; i++ ) 
  {     
    for (int j = 0; j < rows; j++ ) 
    {
      updateGrid(i, j);
      grid[i][j].display();
    }
  }

  if (millis()-lastTime>interval) 
  {
    if (!paused) 
    {
      applyRules();
      lastTime = millis();
    }
  }
}

void initConwaysGameOfLife(color d, color a, int chance)
{
  dead = d;
  alive = a;
  grid = new Cell[rows][cols];
  buffer = new int[rows][cols];
  int b_w; 
  color col;
  int count = 1;
  for (int i = 0; i < rows; i++)
  {
    for (int j = 0; j < cols; j++)
    {
      b_w = int(random(chance)); // 1/chance possibility of cell being alive
      if (b_w > 0)
      {
        col =  dead;
        buffer[i][j] = 0;
      }     
      else
      {
        col = alive;
        buffer[i][j] = 1;
      }
      grid[i][j] = new Cell(i * (boardWidth/cols), j * (boardHeight/rows), (boardWidth/cols), (boardHeight/rows), col);
    }
  }
}


color getColor(int x, int y)
{
  return grid[x][y].col;
}

void setColor(int x, int y, color c)
{
  grid[x][y].col = c;
}

void updateGrid(int x, int y)
{
  if (buffer[x][y] == 0)
    setColor(x, y, dead);
  else
    setColor(x, y, alive);
}
void saveGrid()
{
  for (int i = 0; i < cols; i++ ) 
  {     
    for (int j = 0; j < rows; j++ ) 
    {
      if (buffer[i][j] == 0)
        setColor(i, j, dead);
      else
        setColor(i, j, alive);
    }
  }
}
void applyRules()
{
  saveGrid();
  for (int i = 0; i < cols; i++ ) 
  {     
    for (int j = 0; j < rows; j++ ) 
    {
      applyLiveRules(i, j);
      applyDeadRules(i, j);
    }
  }
}


void applyLiveRules(int x, int y)
{
  int neighbors = countNeighbors(x, y);
  if (neighbors < 2) //death by under-population
    buffer[x][y] = 0;
  else if (neighbors > 3)// death by crowding
    buffer[x][y] = 0;
}

void applyDeadRules(int x, int y)
{
  if (countNeighbors(x, y) == 3) //life via reproduction
    buffer[x][y] = 1;
}

int countNeighbors(int x, int y)
{
  int neighbors = 0;

  for (int xx=x-1; xx<=x+1;xx++) 
  {
    for (int yy=y-1; yy<=y+1;yy++) 
    {  
      if (!((xx==x)&&(yy==y)))  
      { 
        int tx = xx < 0 ? cols - 1 : xx % cols;
        int ty = yy < 0 ? rows - 1 : yy % rows; 
        if (grid[tx][ty].col == alive)
          neighbors++;
      }
    }
  } 
  return neighbors;
}

void keyPressed()
{
  if (key == ' ')
    paused = !paused;
  else if (key == 'c')
    clearGrid();
  else if (key == 'q')
    exit();
  else if (key == 'r' || key == 'R')
    initConwaysGameOfLife(color(255, 255, 255), color(0), 25);

  selected = "";
  for (int i = 0; i < rBtns.length; i++)
  {
    rBtns[i].checked = false;
    rBtns[i].display();
  }
}

void mouseClicked()
{
  drawButtons(rBtns); 
  if (paused)
  {
    if (mouseY > boardHeight)
    {
      for (int i = 0; i < rBtns.length; i++)
      {
        if (rBtns[i].isInButton(mouseX, mouseY))
        {
          rBtns[i].checked = !rBtns[i].checked;
          if (rBtns[i].checked)
            selected = rBtns[i].text;
          else
            selected = "";
          for (int j =0; j < rBtns.length; j++)
          {
            if (j != i)
            {
              rBtns[j].checked = false;
              rBtns[j].display();
            }
          }
        }
        rBtns[i].display();
      }
    }
    else
    {
      int xCellOver = int(map(mouseX, 0, boardWidth, 0, boardWidth/cell_w));
      xCellOver = (int)constrain(xCellOver, 0, boardWidth/cell_w-1);
      int yCellOver = int(map(mouseY, 0, boardHeight, 0, boardHeight/cell_h));
      yCellOver = (int)constrain(yCellOver, 0, boardHeight/cell_h-1);

      if (selected.equals(""))
      {
        if (grid[xCellOver][yCellOver].col == alive) 
        { 
          buffer[xCellOver][yCellOver] = 0;
          grid[xCellOver][yCellOver].col = dead; // Kill
          grid[xCellOver][yCellOver].display();
        }
        else 
        { 
          buffer[xCellOver][yCellOver] = 1;
          grid[xCellOver][yCellOver].col = alive;
          grid[xCellOver][yCellOver].display();
        }
      }
      else
      {

        Organism org = null;
        buffer[xCellOver][yCellOver] = 0;
        grid[xCellOver][yCellOver].col = dead;
        grid[xCellOver][yCellOver].display();

        if (selected.equals("Glider"))
          org = Glider(xCellOver, yCellOver);
        else if (selected.equals("Beacon"))
          org = Beacon(xCellOver, yCellOver);
        else if (selected.equals("Toad"))
          org = Toad(xCellOver, yCellOver);       
        else if (selected.equals("Gosper Glider Gun"))
          org = GosperGun(xCellOver, yCellOver);
        else if (selected.equals("Lightweight Spaceship"))
          org = LWSS(xCellOver, yCellOver);

        if (org.xMin < 0 || Math.ceil(org.xMax) >= cols || org.yMin < 0 || Math.ceil(org.yMax) >= rows)
        {
          Error(buttonAreaWidth/2, buttonAreaHeight / 2 + boardHeight, "Cannot create organism inbounds.");
          return;
        } 

        for (int i = 0; i < org.cells.size(); i++)
        {
          int cX = (int)org.cells.get(i).x;
          int cY = (int)org.cells.get(i).y;

          buffer[cX][cY] = 1;
          grid[cX][cY].col = alive;
          grid[cX][cY].display();
        }
      }
    }
  }
}

void clearGrid()
{
  for (int i = 0; i < cols; i++ ) 
  {     
    for (int j = 0; j < rows; j++ ) 
    {
      buffer[i][j] = 0;
    }
  }
}

void drawButtons(RadioButton[] btns)
{
  float currX = RadioButton.size;
  float currY = boardHeight + 20;
  fill(20);
  rect(-1, boardHeight, boardWidth, buttonAreaHeight+1);

  for (int i = 0; i < btns.length; i++)
  {
    if (currY >= height)
    {
      currY = boardHeight + 20;
      currX = currX + RadioButton.size + int(textWidth(btns[i].text)) + 15;
    }
    btns[i].x = currX;
    btns[i].y = currY;
    currY = currY + RadioButton.size + 10;
    btns[i].textColor = color(255);
    btns[i].display();
  }
}

void Error(float x, float y, String msg)
{
  fill(255, 0, 0);
  text(msg, x, y);
}

Organism Glider(int x, int y)
{
  Organism glider = new Organism(x, y, "glider.csv", cell_w, cell_h, alive);
  return glider;
}

Organism Beacon(int x, int y)
{
  Organism beacon = new Organism(x, y, "beacon.csv", cell_w, cell_h, alive);
  return beacon;
}

Organism Toad(int x, int y)
{
  Organism toad = new Organism(x, y, "toad.csv", cell_w, cell_h, alive);
  return toad;
}

Organism LWSS(int x, int y)
{
  Organism lwss = new Organism(x, y, "lwss.csv", cell_w, cell_h, alive);
  return lwss;
}

Organism GosperGun(int x, int y)
{
  Organism gosper = new Organism(x, y, "gospergun.csv", cell_w, cell_h, alive);
  return gosper;
}

