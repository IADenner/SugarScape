import java.util.*;
SugarGrid myGrid;
boolean started = false;
Graph blankgraph, population, sugargraph, CDFgraph, tribegraph, agegraph;
boolean social = false;
boolean paused = false;
Agent selected1;
Agent selected2;
Integer mousexy[] = new Integer[2];
SocialNetwork sn;
boolean noPath = false;
boolean tribal;

void setup(){

  size(1000,800);
  fill(0, 0, 0);
  rect(0, 0, 800, 800);
  fill(255, 255, 255);
  text("Press, P for pollution simulation, S for season simulation, B for both. Press K for a social simulation. Press T to run tests. \n Press 1, 2, or 3 to replicate models III-3, III-4, or III-5 (respectively) from Epstein and Axtell.", 100, 100);
  
  frameRate(60);
  
  //GRAPH TEST
  population = new popGraph(820, 0, 180, 180, "Time", "Population");
  sugargraph = new sugarGraph(820, 200, 180, 180, "Time", "Avg. Sugar");
  tribegraph = new tribeGraph(820, 400, 180, 180, "Time", "% trueTribe");
  agegraph = new ageGraph(820, 600, 180, 180, "Time", "Avg. Age");
 // CDFgraph = new WealthCDF(820, 400, 180, 180, "Agents", "Sugar", 20);
}

void keyPressed()
{
  if (key == 't')
  {
    sugarTest tester = new socialTest();
    
    
  }
  if ((key == 'p') && (social == false))
  {
    myGrid = new SugarGrid(80,80,10, new GrowbackRule(1), new PollutionRule(5, 5));
    myGrid.addSugarBlob(20,20,5, 3000, 450);
    
    for (int i = 0; i < 40; i++)
    {
      myGrid.addAgentAtRandom(new Agent(100,1,1000, new PollutionMovementRule()));
    }
    started = true;
  }
  if (key == 's')
  {
    myGrid = new SugarGrid(80,80,10, new SeasonalGrowbackRule(4, 0, 2400, 40, 1600), new PollutionRule(0, 0));
    myGrid.addSugarBlob(20,20,1, 3000, 50);
    
    for (int i = 0; i < 40; i++)
    {
      myGrid.addAgentAtRandom(new Agent(200,1,1000, new PollutionMovementRule()));
    }
    started = true;
  }
  if (key == 'b')
  {
    myGrid = new SugarGrid(80,80,10, new SeasonalGrowbackRule(2, 0, 365, 40, 1600), new PollutionRule(5, 5));
    myGrid.addSugarBlob(20,20,1, 3000, 120);
    
    for (int i = 0; i < 40; i++)
    {
      myGrid.addAgentAtRandom(new Agent(100,1,1000, new PollutionMovementRule()));
    }
    started = true;
  }
  if (key == 'k')
  {
    myGrid = new SugarGrid(25,25,800/25, new GrowbackRule(8), new PollutionRule(0, 0));
    myGrid.addSugarBlob(20,20,1, 3000, 100);
    
    for (int i = 0; i < 40; i++)
    {
      myGrid.addAgentAtRandom(new Agent(200,10,4000, new PollutionMovementRule()));
    }
    started = true;
    social = true;
    
  }
  
  ////////////////
  if (key == 'c')
  {
    population.setScale(0.1);
    myGrid = new SugarGrid(80,80,10, new GrowbackRule(0), new PollutionRule(0, 0));
    
    
    myGrid.addSugarBlob(60,60,1, 3000, 100);
    myGrid.addSugarBlob(20,20,1, 3000, 100);
    
    for (int i = 0; i < 200; i++)
    {
      myGrid.addAgentAtRandom(new Agent(200,1,1000, new CombatMovementRule(2000)));
    }
    started = true;
    tribal = true;
  }
  //////////////////////
  
  if (key == '1')
  {
   population.setScale(0.1);
   FertilityRule breedrule;
   HashMap tempMap1 = new HashMap();
   HashMap tempMap2 = new HashMap();
   
   Integer[] maleAge1 = {300, 500};
   Integer[] maleAge2 = {1500, 1800};
   
   Integer[] femaleAge1 = {300, 500};
   Integer[] femaleAge2 = {1500, 1800};
   tempMap1.put('X', maleAge1);
   tempMap1.put('Y', femaleAge1);
   
   tempMap2.put('X', maleAge2);
   tempMap2.put('Y', femaleAge2);
   breedrule = new FertilityRule(tempMap1, tempMap2);
   ReplacementRule replacer = new ReplacementRule(2000, 2150, new AgentFactory());
   
   
    myGrid = new SugarGrid(80,80,10, new GrowbackRule(20), new PollutionRule(0, 0), breedrule, replacer);
    myGrid.addSugarBlob(20,20,5, 3000, 50);
    
    for (int i = 0; i < 500; i++)
    {
      myGrid.addAgentAtRandom(new Agent(100,1,100, new PollutionMovementRule()));
    }
    started = true;
    
  }
  
  if (key == '2')
  {
     population.setScale(0.1);
     FertilityRule breedrule;
     HashMap tempMap1 = new HashMap();
     HashMap tempMap2 = new HashMap();
     
     Integer[] maleAge1 = {20, 100};
   Integer[] maleAge2 = {400, 900};
   
   Integer[] femaleAge1 = {20, 100};
   Integer[] femaleAge2 = {400, 900};
   tempMap1.put('X', maleAge1);
   tempMap1.put('Y', femaleAge1);
   
   tempMap2.put('X', maleAge2);
   tempMap2.put('Y', femaleAge2);
   breedrule = new FertilityRule(tempMap1, tempMap2);
   ReplacementRule replacer = new ReplacementRule(400, 900, new AgentFactory());
     
     
      myGrid = new SugarGrid(80,80,10, new GrowbackRule(20), new PollutionRule(0, 0), breedrule, replacer);
      myGrid.addSugarBlob(20,20,5, 3000, 50);
      
      for (int i = 0; i < 500; i++)
      {
        myGrid.addAgentAtRandom(new Agent(100,1,100, new PollutionMovementRule()));
      }
      started = true;
  }
  
  if (key == '3')
  {
     population.setScale(0.1);
     FertilityRule breedrule;
     HashMap tempMap1 = new HashMap();
     HashMap tempMap2 = new HashMap();
     
     Integer[] maleAge1 = {20, 100};
   Integer[] maleAge2 = {200, 400};
   
   Integer[] femaleAge1 = {20, 100};
   Integer[] femaleAge2 = {200, 400};
   tempMap1.put('X', maleAge1);
   tempMap1.put('Y', femaleAge1);
   
   tempMap2.put('X', maleAge2);
   tempMap2.put('Y', femaleAge2);
   breedrule = new FertilityRule(tempMap1, tempMap2);
   ReplacementRule replacer = new ReplacementRule(200, 450, new AgentFactory());
     
     
      myGrid = new SugarGrid(80,80,10, new GrowbackRule(20), new PollutionRule(0, 0), breedrule, replacer);
      myGrid.addSugarBlob(20,20,5, 3000, 50);
      
      for (int i = 0; i < 500; i++)
      {
        myGrid.addAgentAtRandom(new Agent(100,1,100, new PollutionMovementRule()));
      }
      started = true;
  }
  
  
  if ((key == 'p') && (social == true))
  {
   selected1 = selected2 = null;
   paused = !paused; 
   sn = new SocialNetwork(myGrid);
  }
}

void mouseClicked() {
  if (started == true){
 mousexy[0] = mouseX/myGrid.getSquareSize();
 mousexy[1] = mouseY/myGrid.getSquareSize();
 if (myGrid.getAgentAt(mousexy[0], mousexy[1]) != null)
 {
  if (selected1 == null) selected1 = myGrid.getAgentAt(mousexy[0], mousexy[1]) ;
  else if (selected2 == null)
  {
    selected2 = myGrid.getAgentAt(mousexy[0], mousexy[1]);
    sn.bacon(selected1, selected2);
    if (sn.pathExists(selected1, selected2) == false)
    {
      paused = false;
      fill(255, 0, 0);
      noPath = true;
    }
    else noPath = false;
    sn.display();
  }
 }}
}
void draw(){
  if (started == true)
  {
  
  if (paused == false) myGrid.update();
  else
  {
    sn.display();
  }
 // background(250);
  myGrid.display();
  if (sn != null) sn.display();
    if (myGrid.day%30 == 0)
    {
    population.update(myGrid);
    sugargraph.update(myGrid);
    tribegraph.update(myGrid);
    if (tribal == true){
    myGrid.addSugarBlob(60,60,1, 3000, 100);
    myGrid.addSugarBlob(20,20,1, 3000, 100);
    }
    
    }
    
    //CDFgraph.update(myGrid);
    if (social == true)
    {
      fill(255, 0, 0);
      if (noPath == true) text("NO PATH", 800, 500);
     fill(0);
     stroke(1);
     
     text("Press p to pause the simulation. \n Then click on an agent to select it. \n Click on a second agent to see the \n path between them.", 800, 600); 
    }
   
    
  }
  
}