class Graph {
  int x, y, Width, Height, numUpdates;
  float scale = 2;
  String xLabel, yLabel;
  
  public Graph(int x, int y, int W, int H, String xLabel, String yLabel)
  {
   this.x = x;
   this.y = y;
   this.Width = W;
   this.Height = H;
   this.xLabel = xLabel;
   this.yLabel = yLabel;
  }
  
  public void setScale(float amount)
  {
   scale = amount; 
  }
  
  public void update(SugarGrid g)
  {
    fill(255);
    rect(x, y, Width, Height); //draw background of graph
    
    fill(0);
    stroke(2);
    line(x, y + Height, x + Width, y + Height); //draw the line along the bottom
    line(x, y, x, y + Height); // draw the line along the left side of graph
    
    
    //TEXT LABELS
    text(xLabel, x + 10, y + Height + 15);
    
    pushMatrix();
    translate(x, y);
    rotate(-PI/2.0);
    text(yLabel, -Height + 10, -5 );
    popMatrix();

  }
  
}

abstract class lineGraph extends Graph
{
  public lineGraph(int x, int y, int W, int H, String xLabel, String yLabel)
  {
    super(x, y, W, H, xLabel, yLabel);
    numUpdates = 0;
  }
  public abstract int nextPoint(SugarGrid g);
  
  public void update(SugarGrid g)
  {
    if (numUpdates == 0) super.update(g);
    else
    {
      //fill(0, 255, 200);
      stroke(0, 255, 255);
      rect(numUpdates + x, y + Height - nextPoint(g), 1, 1);
      stroke(255);
    }
    numUpdates++;
    
    if (numUpdates > Width) 
    {
     numUpdates = 0; 
    }
  }
  
}

class popGraph extends lineGraph 
{
  
  public popGraph(int x, int y, int W, int H, String xLabel, String yLabel)
  {
    super(x, y, W, H, xLabel, yLabel);
  }
  
  public int nextPoint(SugarGrid g)
  {
   return (int)(g.AgentsList.size()*scale); 
  }
}

class tribeGraph extends lineGraph 
{
  
  public tribeGraph(int x, int y, int W, int H, String xLabel, String yLabel)
  {
    super(x, y, W, H, xLabel, yLabel);
  }
  
  public int nextPoint(SugarGrid g)
  {
    float ratio = (float)(g.truePopulation)/g.AgentsList.size();
   return (int)(Height*ratio); 
  }
}

class ageGraph extends lineGraph
{
   public ageGraph(int x, int y, int W, int H, String xLabel, String yLabel)
  {
    super(x, y, W, H, xLabel, yLabel);
  }
  
  public int nextPoint(SugarGrid g)
  {
    ;
   return g.aggregateAge/g.AgentsList.size(); 
  }
  
}


class sugarGraph extends lineGraph 
{
  public sugarGraph(int x, int y, int W, int H, String xLabel, String yLabel)
  {
    super(x, y, W, H, xLabel, yLabel);
  }
  
  public int nextPoint(SugarGrid g)
  {
   int avSugar = 0;
   for (Agent a : g.AgentsList)
   {
    avSugar += a.getSugarLevel(); 
   }
   return Math.max(avSugar/(g.AgentsList.size() * g.grid[0].getMaxSugar()), Height);
  }
}

abstract class CDFGraph extends Graph
{
  int numUpdates;
  int numPerCell;
  int callsPerValue;
  public CDFGraph(int x, int y, int W, int H, String xLabel, String yLabel, int callsPerValue)
  {
    super(x, y, W, H, xLabel, yLabel);
    numUpdates = 0;
    this.callsPerValue = callsPerValue;
  }
  
  public abstract void reset(SugarGrid g);
  public abstract int nextPoint(SugarGrid g);
  public abstract int getTotalCalls(SugarGrid g); 
  public void update(SugarGrid g)
  {
   numUpdates = 0; 
   super.update(g);
   reset(g);
   numPerCell = g.getWidth()/getTotalCalls(g);
   while (numUpdates < getTotalCalls(g))
   {
     stroke(0, 255, 255);
     rect(numUpdates + x, y + Height - nextPoint(g), numPerCell, 1);
     stroke(255);
     numUpdates ++;
   }
  }
}

class WealthCDF extends CDFGraph
{
  ArrayList<Agent> al = new ArrayList<Agent>();
  int totalSugar;
  int callsPerValue;
  int sugarSoFar;
  public WealthCDF(int x, int y, int W, int H, String xLabel, String yLabel)
  {
    super(x, y, W, H, xLabel, yLabel, 3);
  }
  
  public void reset(SugarGrid g)
  {
    for (int i = 0; i < g.AgentsList.size(); i ++)
    {
     al.add(g.AgentsList.get(i)); 
     totalSugar += g.AgentsList.get(i).getSugarLevel();
    }
    Sorter sortMeister = new MergeSorter();
    sortMeister.sort(al);
    sugarSoFar = 0;
  }
  
  public int nextPoint(SugarGrid g)
  {
    float averageSugar = 0;
    for (int i = numUpdates; i < min(numUpdates + callsPerValue, al.size()); i++)
    {
      averageSugar += al.get(i).getSugarLevel();
    }
    averageSugar /= min(callsPerValue, al.size() - callsPerValue);
    sugarSoFar += averageSugar;
    
    return sugarSoFar/totalSugar;
    
  }

  public int getTotalCalls(SugarGrid g)
  {
    return al.size()/callsPerValue;
  }
}