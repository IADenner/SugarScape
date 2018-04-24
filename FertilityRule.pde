class FertilityRule {
  Map<Character, Integer[]> childbearing;
  Map<Character,Integer[]> climacteric;
  
  //BIRTHLIST INTEGERS - [0] = childbearing age, [1] menopause, [3] sugarlevel
  HashMap<Agent, Integer[]> birthList;
  
  public FertilityRule(Map<Character, Integer[]> childbearingOnset, Map<Character,Integer[]> climactericOnset)
  {
    this.childbearing = childbearingOnset;
    this.climacteric = climactericOnset;
    birthList = new HashMap();
  }
  
  public boolean isFertile(Agent a)
  {
    if (a == null || !a.isAlive())
    {
       if (birthList.containsKey(a)) birthList.remove(a);
       return false;
    }
    else
    {
      //Populate birthList
     if (!birthList.containsKey(a))
     {
       char tempSex = a.getSex();
       //the max amount of time an agent is fertile
       int ageGap = childbearing.get(tempSex)[1] - childbearing.get(tempSex)[0];
       
       
       int childbearingAge = (int)(Math.random()*ageGap + childbearing.get(a.getSex())[0]);
       
       ageGap = climacteric.get(tempSex)[1] - climacteric.get(tempSex)[0];
       int menopauseAge = 0;
       
       //Try random menopause values until menopause is after childbearing age
       while (menopauseAge < childbearingAge) menopauseAge = climacteric.get(a.getSex())[1] - (int)(Math.random()*ageGap);
       
       //Put these into our list
       Integer[] tempList = {childbearingAge, menopauseAge, a.getSugarLevel()};
       birthList.put(a, tempList);
     }
     
     Integer[] tempList = birthList.get(a);
     
     if (tempList[0] <= a.getAge() && tempList[1] > a.getAge() && a.getSugarLevel() > tempList[2])
     {
       return true;
     }
     else return false;
      
    }
    
  }
  
  public boolean canBreed(Agent a, Agent b, LinkedList<Square> local)
  {
    if (isFertile(a) && isFertile(b))
    {
      if (a.getSex() != b.getSex())
      {
        //Checks for empty squares and makes sure agents are in system
        boolean aInLocal = false, bInLocal = false, emptySquare = false;
        for (Square tempSquare : local)
        {
         if (tempSquare.getAgent() == a) {aInLocal = true;}
         if (tempSquare.getAgent() == b) {bInLocal = true; }
         if (tempSquare.getAgent() == null) {emptySquare = true;}
        }
        
        if ((bInLocal == true) && (emptySquare == true))
        {
          //print("Possible breeding!");
         return true; 
         
        }
         
      }
    }
    return false;
  }
  
  public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal)
  {
   if (!canBreed(a, b, aLocal) && !canBreed(b, a, bLocal))
   {
     return null;
   }
   else
   {
     //nmethod for deciding inheritence of metabolism and vision
     double choice[] = {Math.random(), Math.random()};
     int metabolism;
     int vision;
     if (choice[0] > 0.5) metabolism = a.getMetabolism();
     else metabolism = b.getMetabolism();
     
     if (choice[1] > 0.5) vision = a.getVision();
     else vision = b.getVision();
     Agent child = new Agent(metabolism, vision, 0, a.getMovementRule());
     a.gift(child, a.getSugarLevel()/2);
     b.gift(child, b.getSugarLevel()/2);
     child.nurture(a, b);
     //place agent in either aLocal or bLocal
     Collections.shuffle(aLocal);
     for (Square s : aLocal)
     {
       if (s.getAgent() == null)
       {
        s.setAgent(child);
        print("Agent birthed");
        return child;
       }
     }
     
     Collections.shuffle(bLocal);
     for (Square s : bLocal)
     {
      if (s.getAgent() == null)
      {
       s.setAgent(child);
       return child;
      }
     }
     
     return null;
   }
  }
  
  
  
}