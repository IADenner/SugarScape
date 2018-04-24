 class PollutionRule {
  int gp, ep, a, ns;
  
  public PollutionRule(int gatheringPollution, int eatingPollution)
  {
    gp = gatheringPollution;
    ep = eatingPollution;
  }
  
  //ALTERNATIVE CONSTRUCTOR FOR POLLUTION DIFFUSION
  public PollutionRule(int gatheringPollution, int eatingPollution, int alpha, int numSquares)
  {
    gp = gatheringPollution;
    ep = eatingPollution;
    
    ns = numSquares;
    a = alpha;
  }
  
  public void pollute(Square s)
  {
   if (s.getAgent() != null)
   {
    Agent a = s.getAgent(); 
    s.setPollution(s.getPollution() + ep*a.getMetabolism() + gp*s.getSugar());
   // print("pollution at tile " + s.toString() + "Set to: " + s.getPollution());
   }
  }
  
  public void diffuse(Square s, LinkedList<Square> range)
  {
   if (s.getAgent() != null)
   {
    Agent a = s.getAgent(); 
    s.setPollution(s.getPollution() + ep*a.getMetabolism() + gp*s.getSugar());
   // print("pollution at tile " + s.toString() + "Set to: " + s.getPollution());
   }
   
     int flux = 0;
     for (Square i : range)
     {
      flux += i.getPollution(); 
     }
     flux /= range.size();
     
     s.setPollution(flux);
     
  }
  
}