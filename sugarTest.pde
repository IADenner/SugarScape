class sugarTest {
  SugarGrid s;
 public sugarTest()
 {
   s = new SugarGrid(40, 40, 50, new GrowbackRule(1), new PollutionRule(0, 0));
 }
}

class sortTest extends sugarTest
{
  public sortTest()
  {
    ArrayList<Agent> listy = new ArrayList<Agent>();
   for (int i = 0; i < 25; i++)
   {
     listy.add(new Agent(100,1, (int)random(25), new PollutionMovementRule()));
   }
   for (int i = 0; i < 25; i++)
   {
     print(" " + listy.get(i).getSugarLevel()); 
   }
    print("\n");
   
    ArrayList<Agent> listy2 = listy;
    Sorter sorter = new BubbleSorter();
    sorter.sort(listy2);
    for (int i = 0; i < 25; i++)
    {
     print(" " + listy2.get(i).getSugarLevel()); 
    }
    
    print("\n");

    ArrayList<Agent> listy3 = listy;
    sorter = new InsertionSorter();
    sorter.sort(listy3);
    
    for (int i = 0; i < 25; i++)
    {
     print(" " + listy3.get(i).getSugarLevel()); 
    }
    print("\n");
    
    //println("MergeSorter");
    ArrayList<Agent> listy4 = listy;
    sorter = new MergeSorter();
    sorter.sort(listy4);
    for (int i = 0; i < 25; i++)
    {
     print(" " + listy4.get(i).getSugarLevel()); 
    }
    print("\n");
    
    
    ArrayList<Agent> listy5 = listy;
    sorter = new QuickSorter();
    sorter.sort(listy5);
    for (int i = 0; i < 25; i++)
    {
     print(" " + listy5.get(i).getSugarLevel()); 
    }
    print("\n");
    
    
    print("\n \n");
  }
}

class socialTest extends sugarTest
{
  public socialTest()
  {
   super();
   ArrayList<Agent> listy = new ArrayList<Agent>();
   
   
   /*TEST DETAILS: CREATES TWO COLUMNS OF AGENTS AT 1 and 10
   AGENTS IN COLUMN 1 SHOULD NOT BE ABLE TO SEE COLUMN 10*/
   // s = new SugarGrid(26, 9, 50, new GrowbackRule(1), new PollutionRule(0, 0));
   
   for (int i = 0; i < 25; i++)
   {
     listy.add(new Agent(100, 1, 1, new SugarSeekingMovementRule()));
     s.placeAgent(listy.get(i), i, 0);  
   }
   
   for (int i = 25; i < 50; i++)
   {
     listy.add(new Agent(100, 1, 1, new SugarSeekingMovementRule()));
     s.placeAgent(listy.get(i), i - 25, 8);  
     
   }
   s.display();
   
   
   
   SocialNetwork sn = new SocialNetwork(s);
   s.display();
   
   //Test findAgent
   assert(sn.findAgent(listy.get(0)).equals(new SocialNetworkNode(listy.get(0))));
   
   //assert that 0 and 1 are adjacent
   assert(sn.adjacent(sn.findAgent(listy.get(0)), sn.findAgent(listy.get(1))));
   
   //assert that 0 and some random agent are not adjacent
   assert(sn.adjacent(sn.findAgent(listy.get(0)), new SocialNetworkNode(new Agent(1, 1, 1, new PollutionMovementRule()))) == null);
   
   //assert that row 0 and row 10 are not adjacent 
   assert(sn.adjacent(sn.findAgent(listy.get(10)), sn.findAgent(listy.get(0))) == false);
   
   //assert that 0 and 10 have a path
   println(sn.pathExists(listy.get(0), listy.get(10)));
   for (Agent a : listy)
   {
    println("Agent painted: " + sn.findAgent(a).painted());
    //println("Agent points to: " + sn.sees(sn.findAgent(a)).toString());
   }
   
   
   assert(sn.pathExists(listy.get(0), listy.get(10)) == true);
   println("/////////////////");
   //assert that 0 and 25 do not have a path
   assert(sn.pathExists(listy.get(0), listy.get(26)) == false);
   
   
   //BACON TEST
   listy = new ArrayList<Agent>();
    s = new SugarGrid(40, 40, 50, new GrowbackRule(1), new PollutionRule(0, 0));
   
   /*TEST DETAILS: CREATES A BLOCK OF AGENTS 10x10 AND FINDS SHORTEST DISTANCE*/
   
   
   for (int i = 0; i < 100; i++)
   {
     listy.add(new Agent(100, 1, 1, new SugarSeekingMovementRule()));
     s.placeAgent(listy.get(i), i%10, floor(i/10.0));  
   }
   s.display();
   
   
   
  sn = new SocialNetwork(s);

  LinkedList<Agent> tList = sn.bacon(listy.get(0), listy.get(5));
  for (Agent a : tList)
    {
     //a.redAgent = true; 
    }
    sn.display();
    s.display();
    
   println("/////////////////////////////////////////RESULTS///////////////////////////////////");
   println("Path to: " + listy.get(27).toString());
   println(tList);

   
   
   
   
  }
  
}