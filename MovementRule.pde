interface MovementRule
{
 public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle);
 
}


class SugarSeekingMovementRule implements MovementRule{
 public SugarSeekingMovementRule()
 {
   
 }
 
 public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle)
 {
   
   //randomize default firstsugar
   Collections.shuffle(neighbourhood);
   Square mostSugar = neighbourhood.get(0);
   for (Square i : neighbourhood)
   {
    
     //If i's sugar is greater or equal to mostSugar's.
     if (i.getSugar() >= mostSugar.getSugar())
     {
       if ((i.getSugar() == mostSugar.getSugar()) && (g.euclidianDistance(i, middle) >= g.euclidianDistance(mostSugar, middle)))
       {
        //If there's a tie and the new one is further away from center, do nothing
       }
       else if (i.getAgent() == null)
       {
         //If there's not a tie, update mostSugar
         //println("Found a new mostSugar at tile" + i.getX() + ", " + i.getY());
         mostSugar = i;
       }
     }
   }
  // print("\n Final mostSugar: " + mostSugar.getX() + ", " + mostSugar.getY());
   return mostSugar;
 }
  
}




class PollutionMovementRule implements MovementRule{
 public PollutionMovementRule()
 {
   
 }
 
 public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle)
 {
   
   //randomize default firstsugar
   Collections.shuffle(neighbourhood);
   Square mostSugar = neighbourhood.get(0);
   for (Square i : neighbourhood)
   {
    
     //If i's sugar is greater or equal to mostSugar's.
     float iRatio;
     float mRatio;
     
     //Set iRatio to 0 if invalid values
     if (i.getSugar() != 0) iRatio = i.getPollution()/i.getSugar();
     else iRatio = 1000;
     
     if (mostSugar.getSugar() != 0) mRatio = mostSugar.getPollution()/mostSugar.getSugar();
     else mRatio = 1000;
     
     //println("mRatio: " + mRatio + " iRatio: " + iRatio);
     
      if (iRatio <= mRatio)
      {
        if ((mostSugar.getAgent() != null) && (!i.equals(mostSugar)) && (i.getAgent() == null))
        {
         mostSugar = i; 
        } 
        else if ((iRatio == mRatio) && (g.euclidianDistance(i, middle) >= g.euclidianDistance(mostSugar, middle)) && (mostSugar.getAgent() == null))
        {
         //If there's a tie and the new one is further away from center, do nothing
        }
        else if (i.getAgent() == null)
        {
          //If there's not a tie, update mostSugar
          //println("Found a new mostSugar at tile" + i.getX() + ", " + i.getY());
          mostSugar = i;
        }
        
        
      }
      
      
     
   }
  // print("\n Final mostSugar: " + mostSugar.getX() + ", " + mostSugar.getY());
   return mostSugar;
 }
  
}


class CombatMovementRule extends SugarSeekingMovementRule
{
  int alpha;
  public CombatMovementRule(int alpha)
  {
   this.alpha = alpha;
  }
 
 public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle)
 {
   
   //randomize default firstsugar
   Collections.shuffle(neighbourhood);
   Square mostSugar = neighbourhood.get(0);
   
   for (int i = 0; i < neighbourhood.size(); i++)
   {
    Square s = neighbourhood.get(i);
    if (s.getAgent() != null)
    {
      if (s.getAgent().getTribe() == middle.getAgent().getTribe()) 
      {
        neighbourhood.remove(i);
        i--; 
      }
      else if (s.getAgent().getSugarLevel() >= middle.getAgent().getSugarLevel())
      {
       neighbourhood.remove(i);
       i--;
      }
    }
    else
    {
     LinkedList<Square> tempVision = g.generateVision(s.getX(), s.getY(), middle.getAgent().getVision() );
     boolean temp = false;
     for (Square t : tempVision)
     {
      if (t.getAgent() != null) if ((t.getAgent().getTribe() !=  middle.getAgent().getTribe()) && (t.getAgent().getSugarLevel() >= middle.getAgent().getSugarLevel())) temp = true;
     }
     
     if (temp == true)
     {
      neighbourhood.remove(i);
      i--;
     }
    
     
    }
   }
    
    LinkedList<Square> newNeighbourhood = new LinkedList<Square>();
    for (Square s : neighbourhood)
    {
      Square tempSquare;
      if (s.getAgent() != null) tempSquare = new Square(s.getSugar() + min(s.getAgent().getSugarLevel(),  alpha), s.getMaxSugar() + min(s.getAgent().getSugarLevel(), alpha), s.getX(), s.getY());
      else tempSquare = s;
      
      newNeighbourhood.add(tempSquare);
    }
    
    Square destSquare;
    if (newNeighbourhood.size() > 0) destSquare = super.move(newNeighbourhood, g, middle);
    else return middle;
    
    destSquare = g.findSquareAt(destSquare.getX(), destSquare.getY());
    if (destSquare.getAgent() == null)
    {
     return destSquare; 
    }
    else
    {
     Agent casualty = destSquare.getAgent();
     casualty.gift(middle.getAgent(), Math.min(alpha, casualty.getSugarLevel()));
     
     g.findSquareAt(casualty.getX(), casualty.getY()).setAgent(null);
     g.killAgent(casualty);
     print("Agent murdered");
     
     return destSquare;
    }
    
    
   
   
  // print("\n Final mostSugar: " + mostSugar.getX() + ", " + mostSugar.getY());
   
 }
  
}