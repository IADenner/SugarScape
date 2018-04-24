class AgentFactory {
  int minM, maxM, minV, maxV, minIS, maxIS;
  MovementRule m;
  public AgentFactory()
  {
    
  }
  public AgentFactory(int minMetabolism, int maxMetabolism, int minVision, int maxVision, int minInitialSugar, int maxInitialSugar, MovementRule m)
  {
    this.minM = minMetabolism;
    this.maxM = maxMetabolism;
    this.minV = minVision;
    this.maxV = maxVision;
    this.minIS = minInitialSugar;
    this.maxIS = maxInitialSugar;
    this.m = m;
  }
  
  public Agent makeAgent()
  {
   return(new Agent((int)random(minM, maxM), (int)random(minV, maxV), (int)random(minIS, maxIS), this.m)); 
  }
}