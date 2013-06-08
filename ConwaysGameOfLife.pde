Cell[][] grid;
int[][] buffer;
int rows, cols;
int cell_w, cell_h;
color dead, alive;
int boardHeight, boardWidth;
int buttonAreaHeight, buttonAreaWidth;
int interval, lastTime;
boolean paused;
void setup()
{
  size(500, 700);
  paused = true;
  buttonAreaHeight = 200;
  buttonAreaWidth = width;
  boardHeight = height - buttonAreaHeight;
  boardWidth = width;
  background(50);
  interval = 100; 
  rows = 50;
  cols = 50;
  cell_w = width/cols;
  cell_h = boardHeight/rows;
  initConwaysGameOfLife(color(255,255,255), color(0), 10);  
}

void draw()
{

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
  for(int i = 0; i < rows; i++)
  {
    for(int j = 0; j < cols; j++)
    {
      b_w = int(random(chance)); // 1/chance possibility of cell being alive
      if(b_w > 0)
      {
        col =  dead;
        buffer[i][j] = 0;
      }     
      else
      {
        col = alive;
        buffer[i][j] = 1;
      }
      grid[i][j] = new Cell(i * (width/cols), j * (boardHeight/rows), (width/cols), (boardHeight/rows), col);
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
  if(buffer[x][y] == 0)
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
      if(buffer[i][j] == 0)
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


void applyLiveRules(int x ,int y)
{
  int neighbors = countNeighbors(x, y);
  if(neighbors < 2) //death by under-population
    buffer[x][y] = 0;
  else if(neighbors > 3)// death by crowding
    buffer[x][y] = 0;
}

void applyDeadRules(int x, int y)
{
  if(countNeighbors(x, y) == 3) //life via reproduction
    buffer[x][y] = 1;
}

int countNeighbors(int x, int y)
{
  int neighbors = 0;

  for (int xx=x-1; xx<=x+1;xx++) 
  {
   for (int yy=y-1; yy<=y+1;yy++) 
   {  
     if (((xx>=0)&&(xx<cols))&&((yy>=0)&&(yy<rows))) 
     { 
       if (!((xx==x)&&(yy==y)))  
       { 
         if (grid[xx][yy].col == alive)
           neighbors++;
       } 
     }
   }
  } 
  if(neighbors > 0)
    println("<" + x + "," + y + ">" + "has " + neighbors + " neighbors");
  return neighbors;
}

void keyPressed()
{
  if(key == ' ')
    paused = !paused;
  else if(key == 'c')
    clearGrid();
  else if(key == 'q')
    exit();
  else if(key == 'r' || key == 'R')
    initConwaysGameOfLife(color(255,255,255), color(0), 25);
}

void mouseClicked()
{
  if(paused)
  {
    int xCellOver = int(map(mouseX, 0, boardWidth, 0, boardWidth/cell_w));
    xCellOver = constrain(xCellOver, 0, boardWidth/cell_w-1);
    int yCellOver = int(map(mouseY, 0, boardHeight, 0, boardHeight/cell_h));
    yCellOver = constrain(yCellOver, 0, boardHeight/cell_h-1);

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
