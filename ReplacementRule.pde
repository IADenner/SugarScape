class ReplacementRule {
  int minAge, maxAge;
  AgentFactory factory;
  ArrayList<Agent> AgentList;
  HashMap<Agent, Integer> AgeList;
  public ReplacementRule(int minAge, int maxAge, AgentFactory fac)
  {
   this.minAge = minAge;
   this.maxAge = maxAge;
   this.factory = fac;
   
   AgentList = new ArrayList<Agent>();
   AgeList = new HashMap<Agent, Integer>();
  }
  
  public boolean replaceThisOne(Agent A)
  {
    boolean replace = false;
    
    if (!AgeList.containsKey(A))
    {
     //AgentList.add(A);
     AgeList.put(A, (int)random(minAge, maxAge));
    }
    
    if (A.getAge() > AgeList.get(A))
    {
     A.setAge(maxAge + 1); 
     replace = true;
    }
    return replace;
  }
  
  public Agent replace(Agent a, List<Agent> others)
  {
   return a; 
  }
}