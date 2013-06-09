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
}
