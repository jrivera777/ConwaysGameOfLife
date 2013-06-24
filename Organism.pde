class Organism
{
  float x, y;
  ArrayList<Cell> cells;
  float xMax, yMax;
  float xMin, yMin;
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
  Organism(float origX, float origY, String file, float w, float h, color cellCol)
  {
    x = origX;
    y = origY;
    xMin = Integer.MAX_VALUE;
    xMax = -1;
    yMin = Integer.MAX_VALUE;
    yMax = -1;

    cells = new ArrayList<Cell>();

    Table table = loadTable(file, "header");
    for (TableRow row : table.rows())
    {
      int modX = row.getInt("x");
      int modY = row.getInt("y");
      if (modX + x < xMin)
        xMin = modX + x;
      if (modX + x > xMax)
        xMax = modX + x;
      if (modY + y < yMin)
        yMin = modY + y;
      if (modY + y > yMax)
        yMax = modY + y;      

      this.cells.add(new Cell(x+modX, y+modY, w, h, cellCol));
    }
  }
}

