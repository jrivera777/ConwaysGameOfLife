class Organism
{
  int x, y;
  ArrayList<Cell> cells;
  int xMax, yMax;
  int xMin, yMin;
  Organism()
  {
    this(-1, -1);
  }
  Organism(int origX, int origY)
  {
    x = origX;
    y = origY;
    cells = new ArrayList<Cell>();
  }
  Organism(int origX, int origY, String file, int w, int h, color cellCol)
  {
    x = origX;
    y = origY;
    xMin = Integer.MAX_VALUE;
    xMax = -1;
    yMin = Integer.MAX_VALUE;
    yMax = -1;
    
    cells = new ArrayList<Cell>();

    Table table = loadTable(file, "header");
    for(TableRow row : table.rows())
    {
      int modX = row.getInt("x");
      int modY = row.getInt("y");
      if(modX < xMin)
        xMin = modX;
      if(modX > xMax)
        xMax = modX; 
        if(modX < xMin)
        xMin = modX;
      if(modY > yMax)
        xMax = modX; 
      this.cells.add(new Cell(x+modX, y+modY, w, h, cellCol));
    }
  }
}
