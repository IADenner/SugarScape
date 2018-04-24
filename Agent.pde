class Agent
{
    //Main variables
    int metabolism, vision, sugar, age, x, y, redness;
    MovementRule movement;
    boolean hasMoved = false;
    public Integer[] line = new Integer[2];
    char sex;
    public boolean culture[];

    //constructor
    public Agent(int m, int v, int initialSugar, MovementRule move, char sex)
    {
        metabolism = m;
        vision = v;
        sugar = initialSugar;
        movement = move;
        age = 0;
        
        if (sex != 'X' && sex != 'Y') assert(0==1);
        this.sex = sex;
        
        culture = new boolean[11];
        
        for (int i = 0; i < culture.length; i++)
        {
         if (Math.random() > 0.5) culture[i] = true;
         else culture[i] = false;
         
        }
        println(getTribe());
       // redness = 255;
    }
    
    public void influence(Agent other)
    {
     int random = (int)(Math.random()*11.0);
     other.culture[random] = this.culture[random];
    }
    
    public void nurture(Agent parent1, Agent parent2)
    {
      
      for (int i = 0; i < 11; i++)
      {
         if (Math.random() > 0.5) culture[i] = parent1.culture[i];
         else culture[i] = parent2.culture[i];
      }
    }
    
    public boolean getTribe()
    {
      int trueVals = 0;
      for (int i = 0; i < 11; i++)
      {
         if (culture[i] == true) trueVals ++;
         
      }
      
      if (trueVals > 5) redness = 255;
      else redness = 1;
      
      return (trueVals > 5);
    }
    
    public Agent(int m, int v, int initialSugar, MovementRule move)
    {
      this(m, v, initialSugar, move, 'X');
      
      
      double sex = Math.random();
      if (sex > 0.5)
      {
       this.sex = 'Y';
      }
      
    }
    
    //****************************************************************REFERENCE FUNCTIONS************************************//
    public void gift(Agent other, int amount)
    {
      if (amount > this.sugar) assert(0==1);
      
     other.sugar += amount; 
     this.sugar -= amount;
    }
    public char getSex()
    {
     return this.sex; 
    }
    
    public String toString()
    {
     return "Agent at " + this.x + ", " + this.y; 
    }
    public int getX()
    {
     return x; 
    }
    public void setX(int newX)
    {
      this.x = newX;
    }
    public int getY()
    {
      return y;
    }
    public void setY(int newY)
    {
     this.y = newY; 
    }
    public int getMetabolism()
    {
     return metabolism; 
    }
    
    public int getVision()
    {
     return vision; 
    }
    
    public int getSugarLevel()
    {
     return sugar;
    }
     
    public MovementRule getMovementRule()
    {
     return movement; 
    }
    
    public int getAge()
    {
     return age; 
    }
    
    public void setAge(int howOld)
    {
      age = howOld;
    }
    //*************************************************************************************************************//
    
 
    public void move(Square source, Square destination)
    {
      if (destination.getAgent() == null)
      {
      source.setAgent(null);
      destination.setAgent(this);
      }
      
    }
    public void step()
    {
     sugar -= metabolism; 
     
     //hasMoved = true;
    }
    
    public boolean isAlive()
    {
     if (sugar > 0) return true; 
     else return false;
    }
    
    public void eat(Square s)
    {
      sugar += s.getSugar();
      s.setSugar(0);
    }
    
    public void setRedness(int setter)
    {
     redness = setter; 
    }
    
    public void setLine(int x, int y)
    {
     line[0] = x;
     line[1] = y;
    }
    public void display(int x, int y, int scale)
    {
      fill(0);
      if (redness > 0)
      {
         stroke(2);
         fill(0, 255 - redness, redness); 
      }
      if (line[1] != null)
      {
        stroke(2);
       line(x, y, line[0]*scale + .5*scale, line[1]*scale+ .5*scale); 
      }
     // stroke(0);
     ellipse(x, y, 3*scale/4, 3*scale/4);
    }
    
    public void display(int x, int y, int scale, int size)
    {
      
      if (redness > 0)
      {
         //stroke(0);
         fill(0, 255 - redness, redness); 
      }
      else {fill(0);}
      if (line[1] != null)
      {
       // stroke(0);
       line(x, y, line[0]*size + .5*size, line[1]*size+ .5*size); 
      }
     // stroke(0);
     ellipse(x, y, 3*scale/4, 3*scale/4);
    }

    
   
}