/*public SocialNetwork(SugarGrid g) - Initializes a new social network such that for every pair of Agents (x,y) on grid g, if x can see y (i.e. y is on a square that is in the vision of x), then the SocialNetworkNode for x is connected to the SocialNetworkNode for y in this new social network. Note that x might be able to see y even if y cannot see x.
public boolean adjacent(SocialNetworkNode x, SocialNetworkNode y) - Returns true if agent x is adjacent to agent y in this SocialNetwork. If either x or y is not present in the social network, should return null.
public List<SocialNetworkNode> seenBy(SocialNetworkNode x) - Returns a list (either ArrayList or LinkedList) containing all the nodes that x is adjacent to. Returns null if x is not in the social network.
public List<SocialNetworkNode> sees(SocialNetworkNode y) - Returns a list (either ArrayList or LinkedList) containing all the nodes that are adjacent to y. Returns null if y is not in the social network.
public void resetPaint() - Sets every node in the network to unpainted.
public SocialNetworkNode getNode(Agent a) - Returns the node containing the passed agent. Returns null if that agent is not represented in this graph.*/

class SocialNetwork
{
 private LinkedList<SocialNetworkNode>[] adj;
 private ArrayList<SocialNetworkNode> nodeList;
 private ArrayList<Agent> fromList;
 private LinkedList<LinkedList<Agent>> posPaths;
 private LinkedList<Agent> shortestPath;
 
 public SocialNetwork(SugarGrid g)
 {
    //this.g = g;
    adj = new LinkedList[g.getWidth()*g.getHeight()];
    nodeList = new ArrayList<SocialNetworkNode>();
    
    int i = 0;
    //initialize agents
   while (i < adj.length)
   {
    adj[i] = new LinkedList<SocialNetworkNode>();
    Agent tempAgent = g.getAgentAt(i%g.getWidth(), i/g.getWidth());
    //print("Loc: " + i%g.getWidth() + ", " + i/g.getWidth() + " ");
    nodeList.add(new SocialNetworkNode(tempAgent));
    i++;
   }
   println(nodeList);
   
   
   //Cycle through every agent again
   i = 0;
   while (i < adj.length)
   {
     if (nodeList.get(i).getAgent() != null)
     {
       //Find their vision range
       LinkedList<Square> squareList = g.generateVision(i%g.getWidth(), floor(i/g.getWidth()), nodeList.get(i).getAgent().getVision());
       
       for (Square s : squareList)
       {
         //if squares in vision range contains agent, add this agent to the nodeList
         if ((s.getAgent() != null))
         {
           //Find the agent in the nodelist, and make it's adjacency list point to this
           adj[i].add(new SocialNetworkNode(s.getAgent()));
           println("adding " + s.getAgent() + " to adj[" + i + "]");
         }
       }
     }
     
     i++;
   } 
 }
 
 public SocialNetworkNode findAgent(Agent a)
 {
   SocialNetworkNode returnable = null;
   for (SocialNetworkNode s : nodeList)
   {
     if (s.getAgent() != null)
     {
       if (s.getAgent().equals(a)) returnable =  s;
     }
   }
   return returnable;
 }
 
 public boolean isInNetwork(Agent a)
 {
   boolean returnable = false;
   for (SocialNetworkNode s : nodeList)
   {
     if (s.getAgent() != null)
     {
       if (s.getAgent().equals(a)) returnable =  true;
     }
   }
   return returnable;
   
 }
 
 public Integer getIndex(Agent a)
 {
   int i = 0;
   for (SocialNetworkNode s : nodeList)
   {
     if (s.getAgent() != null)
     {
       if (s.getAgent().equals(a))
       {
         return i;
       }
     }
     i++;
   }
   return null;
 }
 
 //Adjacent - does Y see x?
 public Boolean adjacent(SocialNetworkNode x, SocialNetworkNode y)
 {
   boolean returnable = false;
   //check through all agents that y knows
   int index = nodeList.indexOf(x);
   for (SocialNetworkNode s : adj[index])
   {
     if (s.equals(y)) returnable = true;
   }
   
   if (!isInNetwork(x.getAgent()) || !isInNetwork(y.getAgent())) return null;
   else return returnable;
 }
 
 public LinkedList<SocialNetworkNode> seenBy(SocialNetworkNode x)
 {
   //create a list to return
   LinkedList<SocialNetworkNode> returnList = new LinkedList<SocialNetworkNode>();
   //cycle through all nodes
   for (SocialNetworkNode s : nodeList)
   {
    if (adjacent(x, s)) returnList.add(s);
   }
   
   return returnList;
 }
 
 public LinkedList<SocialNetworkNode> sees(SocialNetworkNode x)
 {
   assert(isInNetwork(x.getAgent()));
  return adj[getIndex(x.getAgent())]; 
 }
 
 public void resetPaint()
 {
  for (SocialNetworkNode s : nodeList)
  {
    s.unpaint();
  }
 }
 
 public SocialNetworkNode getNode(Agent a)
 {
   SocialNetworkNode tempNode = null;
   for (SocialNetworkNode s : nodeList)
   {
     if (s.getAgent().equals(a)) tempNode = s;
   }
   return tempNode;
 }
 
 public boolean pathExists(Agent x, Agent y)
 {
   resetPaint();
   fromList = new ArrayList<Agent>();
   nodeList.get(getIndex(x)).paint();
   
   dfs(nodeList.get(getIndex(x)), null);
   
   //if y was painted in the dfs, it will be noted here
   //println("IS THIS TRUE? " + findAgent(y).painted());
   return findAgent(y).painted();
 }
 
 public void dfs(SocialNetworkNode Node, SocialNetworkNode From)
 {
   //paint current node
   
   findAgent(Node.getAgent()).paint();
   
   
    if (From != null) 
    {
      findAgent(From.getAgent()).paint();
      fromList.add(From.getAgent());
    }
    //fromList.set(nodeList.indexOf(Node), From);
    //call dfs on any valid nodes branching from current Node
    //println("CALLING DFS ON " + Node.toString() + ", WHOSE PAINTED STATUS IS " + findAgent(Node.getAgent()).painted());
    
      for (SocialNetworkNode s : sees(Node))
      {
        if (findAgent(s.getAgent()).painted() == false) dfs(s, From);
      }
 }
 
 public LinkedList<Agent> bacon(Agent x, Agent y)
 {
   //define shortestPath and make it the longest possible length
   if (pathExists(x, y) == false)
   {
     return null; 
   }
   shortestPath = new LinkedList<Agent>(fromList);
   for (SocialNetworkNode sn : nodeList)
   {
     shortestPath.add(sn.getAgent()); 
   }
   
   
   LinkedList<Agent> calledFrom = new LinkedList<Agent>();
   calledFrom.add(x);
   
   if (x == y)
   {
     LinkedList<Agent> tempList = new LinkedList<Agent>();
     tempList.add(x);
     tempList.add(y);
     return tempList;
   }
   else
   {
     for (SocialNetworkNode s : sees(findAgent(x)))
     {
       bacon(s.getAgent(), y, calledFrom);
     }
   }
   
   return shortestPath;
 }
 
 
 public void bacon(Agent x, Agent y, LinkedList<Agent> calledFrom)
 {
   //println("Investigating " + x + " from point " + calledFrom.get(calledFrom.size() - 1));
   LinkedList<Agent> train = new LinkedList<Agent>(calledFrom);
   train.add(x);
   if (pathExists(x, y) == false)
   {
   }
   else if ((calledFrom.size() > shortestPath.size()))
   {
     //println("cancelled path");
   }
   else if (x == y)
   {
     if (train.size() < shortestPath.size())
     {
      shortestPath = train;
      println("NEW SHORTEST PATH: " + shortestPath);  
     } 
   }
   else
   {
     //LinkedList<SocialNetworkNode> shuffler = new LinkedList<SocialNetworkNode>();
     //Collections.shuffle(shuffler);
     for (SocialNetworkNode s : sees(findAgent(x)))
     {
       if (train.contains(s.getAgent()) == false) bacon(s.getAgent(), y, train);
     }
   }
 }
 
 public void display()
 {
   int i = 0;
   if (shortestPath != null)
   {
  for (i = 0; i < shortestPath.size(); i++)
  {
    Agent al = shortestPath.get(i);
   al.setRedness((int)(254.0*((float)(i)/shortestPath.size())) + 1);
    stroke(2);
   if ( i != shortestPath.size() - 1) line(al.getX()*32 + 16, al.getY()*32 + 16, shortestPath.get(i + 1).getX()*32 + 16, shortestPath.get(i + 1).getY()*32 + 16);
   //i++;
  }
   }
 }
 
 /*
 public LinkedList<Agent> bacon(Agent x, Agent y)
 {
  //Since this is only the first call, wipe listList. This will contain a list of all possible paths
  LinkedList<LinkedList<Agent>> listList = new LinkedList<LinkedList<Agent>>();
  posPaths = new LinkedList<LinkedList<Agent>>();
  shortestPath = new LinkedList<Agent>();
  for (SocialNetworkNode sn : nodeList)
  {
   shortestPath.add(sn.getAgent()); 
  }
  
  //return nothing if there is no possible path
  if (pathExists(x, y) == false)
  {
   return null; 
  }
  else if (x == y)
  {
     LinkedList<Agent> tempList = new LinkedList<Agent>();
     tempList.add(x);
     tempList.add(y);
     return tempList;
  }
  //Alternatively - there is a possible path. 
  else {
    //Create a new temparray for each node that x points to
    for (SocialNetworkNode s : adj[nodeList.indexOf(findAgent(x))])
    {
      
      //if there is a path from s to y 
      if (pathExists(s.getAgent(), y))
      { 
        
        //create a new temporary array
        LinkedList<Agent> tempArray = new LinkedList<Agent>();
        //make sure it contains the orignal value
        tempArray.add(x);
   
        LinkedList<Agent> calledFrom = new LinkedList<Agent>();
        calledFrom.add(x);
        
        LinkedList<LinkedList<Agent>> tempList = bacon(s.getAgent(), y, calledFrom);
        if (tempList != null)
        {
          for (LinkedList<Agent> tempList2 :tempList)
          {
            for (Agent a : tempList2)
            {
               tempArray.add(a); 
            } 
            
            //add this possible path to y in listList, which will eventually decide the shortest path. 
            listList.add(tempArray);
          }
            
          
        }
        
      }
    }
    //Now - 
    
    //Collections.shuffle(listList);
   /* println("");
    LinkedList<Agent> shortestList = posPaths.get(0);
    int k = 0;
    for (LinkedList<Agent> al : posPaths)
    {
     println("PosPath index " + k + ": " + al);
     k++;
    }
    for (int i = 0; i < posPaths.size(); i ++)
     {
     int j = i;
     //in inside loop, iterate through every element to the left of our value. If it is less than our value, move to the right of our value. 
     while ((j > 0) && (posPaths.get(j).size() > posPaths.get(i).size()))
     {
       posPaths.set(j, posPaths.get(j - 1));
       j = j-1;
     }
     posPaths.set(j, posPaths.get(i));
   }
     println("shortestPath: " + shortestPath);
    return shortestPath;
  }
 }
 
 //METHODOLOGY: RECURSIVELY FIND THE SHORTEST PATH FROM SOME MIDPOINT IN THE GRAPH TO Y, THEN GRAFT IT ONTO THE SHORTEST PATH FROM THE NODE THAT POINTS TO IT. 
 public LinkedList<LinkedList<Agent>> bacon(Agent x, Agent y, LinkedList<Agent> calledFrom)
 {
    //Listlist will contain every possible path to y. 
    LinkedList<LinkedList<Agent>> listList = new LinkedList<LinkedList<Agent>>();
    
    //println("calling from " + x);
    if ((getIndex(x) > getIndex(y)) && (getIndex(x) > getIndex(calledFrom.get(0))))
    {
     return listList; 
    }
    else if (x == y)
    {
     LinkedList<Agent> finalList = new LinkedList<Agent>();
     //calledFrom.add(x);
     if (calledFrom.size() < shortestPath.size())
     {
      shortestPath = new LinkedList<Agent>(calledFrom);
      shortestPath.add(y);
      println("NEW SHORTEST PATH: " + shortestPath);
      
     }
     else
     {
       calledFrom.add(y);
       //println("Found one path: " + calledFrom);
     }
     
     return null;
    }
    else {
      LinkedList<SocialNetworkNode> k = adj[nodeList.indexOf(findAgent(x))];
      Collections.shuffle(k);
      
      //This loop generates a list of possible paths from the points that x is connected to 
      for (SocialNetworkNode s : k)
      {
        //if there is a path from s to y AND, additionally, this new path does not overlap with the previous path
        if ((pathExists(s.getAgent(), y)) && (calledFrom.contains(s.getAgent()) == false))
        { 
          //create a new temporary array to hold the partial shortest list
          LinkedList<Agent> tempArray = new LinkedList<Agent>();
          
          //Add this current node to the list of used nodes in this path
         for (Agent a : calledFrom)
         {
          tempArray.add(a); 
         }
         
          //tempArray.add(x);
          if (calledFrom.contains(x) == false) calledFrom.add(x);
          
          LinkedList<LinkedList<Agent>> tempList = bacon(s.getAgent(), y, calledFrom);
          if (tempList != null)
          {
           for (LinkedList<Agent> tempList2 :tempList)
            {
              for (Agent a : tempList2)
              {
                 tempArray.add(a); 
              }
              
              listList.add(tempArray);
            }
          }
        }
      }
      
      return listList;
    }
  }*/
 }