
/**
 * Write a description of class Square here.
 *
 * @author (your name)
 * @version (a version number or a date)
 */
class Square
{
    // create an agent to occupy our square
    public Agent Occupant;
    
    //init several variables
    private int sugarLevel = 0, maxSugarLevel = 10, x, y, pollution;
    public int pollutionRatio;
    
    /**
     * Constructor for objects of class Square
     * simply sets up our initial variable values
     */
    public Square(int sugarLevel, int maxSugarLevel, int x, int y)
    {
        // initialise instance variables
        this.x = x;
        this.y = y;
        this.sugarLevel = sugarLevel;
        Occupant = null;
        this.maxSugarLevel = maxSugarLevel;
        pollution = 0;
    }
    
    //returns pollution
    public int getPollution()
    {
     return pollution; 
    }
    
  
    
    //sets pollution
    public void setPollution(int level)
    {
      pollution = level;
    }
    
    //returns sugar
    public int getSugar()
    {
       return this.sugarLevel;   
    }
    
    //returns maxsugar
    public int getMaxSugar()
    {
       return this.maxSugarLevel;   
    }
    
    //returns x coordinate
    public int getX()
    {
       return this.x;   
    }
    
    //returns y coordinate
    public int getY()
    {
     return this.y;
    }
    
    public boolean equals(Square s)
    {
     if ((s.getX() == this.getX()) && (s.getY() == this.getY()))
     {
      return true; 
     }
     else return false;
    }
    
    public String toString()
    {
     return getX() + ", " + getY() + " "; 
    }
    
    //Checks to make sure howMuch isn't invalid, then sets sugarValue accordingly
    public void setSugar(int howMuch)
    {
        if (howMuch > this.maxSugarLevel)
        {
           this.sugarLevel = this.maxSugarLevel;
        }
        else if (howMuch < 0)
        {
           this.sugarLevel = 0;
        }
        else
        {
          this.sugarLevel = howMuch;  
        }
    }
    
    //Checks to make sure input is valid (not less than 0), sets max sugar and adjusts current sugar value accordingly
    public void setMaxSugar(int howMuch)
    {
        if (howMuch < 0)
        {
         this.maxSugarLevel = 0;
         this.sugarLevel = 0;
        }
        else
        {
         this.maxSugarLevel = howMuch;
         if (this.sugarLevel > howMuch)
         {
             this.sugarLevel = howMuch;
         }
        }
    }
    
    //Returns null for no agent, returns agent for yes agent
    public Agent getAgent()
    {
        if (Occupant == null)
        {
            return null;
        }
        else
        {
         return Occupant;   
        }
    }
    
    //Sets agent. Throws error if square is occupied by different agent. Does nothing if 'a' is null.
    public void setAgent(Agent a)
    {
      
        if ((Occupant != null) && (a != null))
        {
          //print("occupant is agent with sugar : " + Occupant.getSugarLevel());
           if (Occupant != a)
            {
               //assert(1==0);
            }
        }

       Occupant = a;
       if (a == null)
       {
        Occupant = null; 
       }
       
    }
    //drawn as a size*size square at position (size*xOffset, size*yOffset). 
    //The square should have a while boarder 4 pixels wide. The square should be colored as a function of its Sugar Levels. 
    //An example color scheme is to use shades of yellow: (255, 255, 255 - sugarLevel/6.0*255). 
    public void display(int size)
    {
      strokeWeight(4);
      stroke(255);
      fill(255 - min(getPollution()/(getMaxSugar()/5), 255), 255 - min(getPollution()/(getMaxSugar()/25), 255), 255.0 - ((float)sugarLevel/ (float)maxSugarLevel)*255.0);
      rect(x*size, y*size, size, size);
      if (Occupant != null)
      {
        
        Occupant.display(size*x + size/2, size*y + size/2, 15, size);
        Occupant.setX(x);
        Occupant.setY(y);
      }
    }
}