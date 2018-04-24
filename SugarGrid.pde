class SugarGrid{
  int w, h, tileSize;
  GrowthRule growback;
  public Square[] grid;
  PollutionRule pollute;
  public int day;
  public ArrayList<Agent> AgentsList;  
  public FertilityRule breedrule;
  public ReplacementRule replacer;
  public Agent sugarAgent;
  
  public LinkedList<Agent> trueTribe;
  public LinkedList<Agent> falseTribe;
  
  public int truePopulation;
  public int aggregateAge;
  
  //initiate values
  public SugarGrid(int wi, int hi, int sideLength, GrowthRule g, PollutionRule p)
  {
   this.w = wi;
   this.h = hi;
   this.tileSize = sideLength;
   growback = g;
   grid = new Square[wi*hi];
   pollute = p;
   day = 0;
   replacer = new ReplacementRule(0, 100000, new AgentFactory());
   
   sugarAgent = new Agent(0, 0, 0, new PollutionMovementRule(), 'Y');
   HashMap tempMap1 = new HashMap();
   HashMap tempMap2 = new HashMap();
   
   Integer[] maleAge1 = {15, 2000};
   Integer[] maleAge2 = {4000, 5000};
   
   Integer[] femaleAge1 = {15, 2000};
   Integer[] femaleAge2 = {3800, 4400};
   tempMap1.put('X', maleAge1);
   tempMap1.put('Y', femaleAge1);
   
   tempMap2.put('X', maleAge2);
   tempMap2.put('Y', femaleAge2);
   breedrule = new FertilityRule(tempMap1, tempMap2);
   
   AgentsList = new ArrayList<Agent>();
   
   
   //tile the grid by placing a new square at each location
   for (int i = 0; i < wi*hi; i++)
   {
     grid[i] = new Square(0, 3000, (i%wi), floor(i/hi));
   }    
  }
  
  public SugarGrid(int wi, int hi, int sideLength, GrowthRule g, PollutionRule p, FertilityRule f)
  {
    this(wi, hi, sideLength, g, p);
    breedrule = f;
  }
  
  public SugarGrid(int wi, int hi, int sideLength, GrowthRule g, PollutionRule p, FertilityRule f, ReplacementRule r)
  {
    this(wi, hi, sideLength, g, p, f);
    replacer = r; 
  }
  
  public int getHeight()
  {
   return this.h; 
  }
  
  public int getWidth()
  {
   return this.w; 
  }
  
  public int getSquareSize()
  {
   return this.tileSize; 
  }
  
  //returns max sugar at x, y
  public Agent getAgentAt(int x, int y) 
  {
    if (findSquareAt(x, y).getAgent() != null)
    {
      return findSquareAt(x, y).getAgent();
    }
    else return null;
  }
  
  public void killAgent(Agent a)
  {
   AgentsList.remove(a);
   for (Square s : grid)
   {
    if (s.getAgent() == a)
    {
      s.setAgent(null);
    }
   }
   
   if (a.getSugarLevel() > 0)
   {
    a.gift(sugarAgent, a.getSugarLevel()); 
   }
     a = null;
  }
  
  //place an agent, crash the program is space is occupied. 
  public void placeAgent(Agent a, int x, int y)
  {
     AgentsList.add(a);
     findSquareAt(x, y).setAgent(a);
  }
  
  //returns max sugar at x, y
  public int getSugarAt(int y, int x)
  {
    return findSquareAt(x, y).getSugar();
  }
  
  //returns max sugar at x, y
  public int getMaxSugarAt(int y, int x)
  {
    return findSquareAt(x, y).getMaxSugar();
  }
  
  //Find distance between s1 and s2 with simple distance formula. If distance between xvals or yvals is more than half the grid, 'invert' these values for toroidal use
  public double euclidianDistance(Square s1, Square s2)
  {
    int diffX;
    int diffY;
    
    //Check absolute X distance
    diffX = abs(s1.getX() - s2.getX());
    //and invert if too large
    if (diffX > round(this.w/2.0) - 1.0)
    {
     diffX =  this.w - diffX;
    }
    
   //repeat for Y values
    diffY = abs(s1.getY() - s2.getY());
    if (diffY > round(this.h/2.0) - 1.0)
    {
     diffY =  this.h - diffY;
    }
    
    //return the distance formula applied to our x/y distance remainders
    return Math.sqrt(diffX*diffX + diffY*diffY);
  }
  
  public void addSugarBlob(int x, int y, int radius, int max)
  {
    Square center =  findSquareAt(x, y);
    //center.setSugar(max);
    
    //cycle through every tile in the grid
    for (Square s : grid)
    {
      
      
      //find distance between epicenter and current tile
      double distance = euclidianDistance(s, center);
      
      //checks through iterations and finds out how many multiples of the radii this tile is away from the epicenter
      int k = 0;
      while ((distance > radius*k) && (max - k > 0))
      {
        k++; //increments k - k will be 1 if 1 radius away, 2 if 2 radii away, etc etc
      }
      if (max - k < 0) return;
      
      if (s.getSugar() < max - k) { s.setSugar(max - k); } //sets sugar in this tile to be max - k. 
      
    }
  }
  
  public void addSugarBlob(int x, int y, int radius, int max, int radmult)
  {
    Square center =  findSquareAt(x, y);
    //center.setSugar(max);
    
    //cycle through every tile in the grid
    for (Square s : grid)
    {
      
      
      //find distance between epicenter and current tile
      double distance = euclidianDistance(s, center);
      
      //checks through iterations and finds out how many multiples of the radii this tile is away from the epicenter
      int k = 0;
      while ((distance > radius*k) && (max - k > 0))
      {
        k++; //increments k - k will be 1 if 1 radius away, 2 if 2 radii away, etc etc
      }
      if (max - k < 0) return;
      
      if (s.getSugar() < max - k*radmult) { s.setSugar(max - k*radmult); } //sets sugar in this tile to be max - k. 
      
    }
  }
  
  
  public Square findSquareAt(int x, int y)
  {
    Square returnSquare = null;
    for (int i = 0; i < this.w*this.h; i++)
    {
     if ((grid[i].getX() == x) && (grid[i].getY() == y))
     {
      returnSquare = grid[i]; 
     }
    }
    return returnSquare;
  }
  
  
  //returns a list with all points within radius along cardinal directions
  public LinkedList<Square> generateVision(int x, int y, int radius)
  {
    LinkedList<Square> list = new LinkedList<Square>();
    Square center = findSquareAt(x, y);
    
    
    //list.add(center);
    //println("BEEP BEEP: REAL CENTER AT: " + center.getX() + ", " + center.getY() + "!!!!");
    for (int i = 0; i < this.w*this.h; i++)
    {
      //cycle through every square in the grid
      Square k = grid[i];
      
      //if k is aligned on either the x or y axis (cardinal direction) with center AND within the radius, add to list. 
      if (((k.getX() == center.getX()) ||  (k.getY() == center.getY())) && (euclidianDistance(k, center) <= radius) && (k != center))
      {
       list.add(k); 
      }
      
    }
    return list;
  }
  
  //Displays all tiles. 
  public void display()
  {
   for (int i = 0; i <this.w*this.h; i++)
   {
     grid[i].display(this.tileSize);
   }
  }
  
  
  public void addAgentAtRandom(Agent A)
  {
   int randx = (int)random(0, this.w);
   int randy = (int)random(0, this.h);
   boolean successful = false;
   
   while (successful == false)
   {
     if (findSquareAt(randx, randy).getAgent() == null)
     {
      placeAgent(A, randx, randy);
      successful = true;
     }
     else 
     {
      randx = (int)random(0, this.w);
      randy = (int)random(0, this.h);
     }
   }
   
  }
  
  
  public void update()
  {
    day ++;
    truePopulation = 0;
    aggregateAge = 0;
   //RESET HASMOVED SO AGENT CAN MOVE !!ONCE!! PER UPDATE
   int i = 0;
   while (i < AgentsList.size())
   {
     AgentsList.get(i).hasMoved = false;
     if ((AgentsList.get(i).getSugarLevel() <= 0))
     {
      //Agent tempAgent = AgentsList.get(i);
      //tempAgent = null;
      
      AgentsList.remove(i); 
      i --;
     }
    i ++; 
   }
   
   for (Square s : grid)
   {
     growback.growBack(s);
     
     //EVERY FIFTY DAYS, FLUX THE POLLUTION
     if (day % 50 == 0)
     {
           pollute.diffuse(s, generateVision(s.getX(), s.getY(), 1));
           //println("Pollution flowing");
     }
         
         
     //MAKE SURE THE AGENT DOES NOT MOVE TWICE IN THE SAME TURN
     if ((s.getAgent() != null))
     {
       Agent a = s.getAgent();
     
       
       if (!AgentsList.contains(a)) {AgentsList.add(a);}
       
       if (a.hasMoved == false)
       {
         if (tribal == true)
         {
           if (a.getTribe()) truePopulation ++;
         }
         
         pollute.pollute(s);
         
         //print(s.getX() + ", " + s.getY());
         LinkedList<Square> v = generateVision(s.getX(), s.getY(), a.getVision());
         a.eat(s);
         a.step();
         a.setAge(a.getAge() + 1);
         aggregateAge += a.getAge();
         
         //print("\n Generated list containing: ");
         for (Square k : v)
         {
          if (k.getAgent() != null)
          {
           breedrule.breed(a, k.getAgent(), v, v); 
           a.influence(k.getAgent());
          }
         }
         //print("Centered at: " + s.getX() + ", " + s.getY() + ". ");
         
         if ((a.isAlive() == false) || (replacer.replaceThisOne(a)))
         {
           if (a.getSugarLevel() > 0)
           {
            a.gift(sugarAgent, a.getSugarLevel()); 
           }
           s.setAgent(null);
           a = null;
           print("Agent died!");
           //AgentsList.remove(AgentsList.indexOf(a));
         }
         else
         {
         
     
         Square dest = a.getMovementRule().move(v, this, s);
         //print("\n Moving agent to " + dest.getX() + ", " + dest.getY());
         a.move(s, dest);
         a.hasMoved = true;
         }
       }
     }
   }
  }
  
}