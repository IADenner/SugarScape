interface GrowthRule
{
 public void growBack(Square s);

}

class GrowbackRule implements GrowthRule{
  int rate;
  //sets growth rate and initializes class
   public GrowbackRule(int rate)
   {
     this.rate = rate;
   }
   
   //set this square to grow. 
   public void growBack(Square s) 
   {
       s.setSugar(rate + s.getSugar()); 
   }
}


class SeasonalGrowbackRule implements GrowthRule {
  int a, b, g, e, numSquares, it, days;
  String season;
  
  public SeasonalGrowbackRule(int alpha, int beta, int gamma, int equator, int numSquares)
  {
    a = alpha;
    b = beta;
    g = gamma;
    e = equator;
    this.numSquares = numSquares;
    season = "northSummer";
    it = 0;
  }
  
  public boolean isNorthSummer()
  {
    if (season == "northSummer") return true;
    else return false;
  }
  
  public void growBack(Square s)
  {
    //if on summer side of map, add alpha
   if (((s.getY() <= e) && (season == "northSummer")) || ((s.getY() >= e) && (season == "southSummer")))
   {
    s.setSugar(s.getSugar() + a); 
   }
   //if on winter, add beta
   else if (((s.getY() >= e) && (season == "northSummer")) || ((s.getY() <= e) && (season == "southSummer")))
   {
    s.setSugar(s.getSugar() + b);
   }
   
   
   it ++;
   days ++;
   //change seasons
   if (g*numSquares == it)
   {
     println("SEASON CHANGING AT DAY " + days/numSquares);
     it = 0;
     if (isNorthSummer()) season = "southSummer";
     else season = "northSummer";
     
   }
  }
  
}