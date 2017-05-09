SugarGrid myGrid;
Graph cultGraph = new CultureGraph(775, 150, 150, 100, "time", "% in red tribe");
Graph avgSug = new AvgSugGraph(775, 350, 150, 100, "time", "average sugarlevel");
Graph age = new AgeGraph(775, 550, 150, 100, "time", "avg age");
//WealthCDF wcdf = new WealthCDF(775, 750, 150, 100, "- number of updates", "wealth dist.", 4);
SugarSeekingMovementRule m = new SugarSeekingMovementRule();
PollutionMovementRule p = new PollutionMovementRule();
CombatMovementRule cr = new CombatMovementRule(20);
HashMap<Character, Integer[]> cRule = new HashMap();
Integer[] cRange = {12, 39};
HashMap<Character, Integer[]> oRule = new HashMap();
Integer[] oRange = {40, 70};
FertilityRule fertRule;
//note2self: 3rd and 4th arguments for agentfactory constructor are minvision and maxvision respectively
AgentFactory f = new AgentFactory(1, 1, 1, 2, 20, 50, cr);
Agent a1 = new Agent(0, 5, 50, p, 'X');
Agent a2 = new Agent(0, 5, 50, p, 'Y');
Agent a3 = f.makeAgent(); 
BubbleSorter bsort = new BubbleSorter();
InsertionSorter isort = new InsertionSorter();
MergeSorter msort = new MergeSorter();
QuickSorter qsort = new QuickSorter();
SocialNetwork network;

//integer for determining what coloring system to use:
//if 1 : display culture; if 2 : display fertility; if 3 : display sex
int colors = 1;

void setup(){
  size(1000, 800);
  
  
  frameRate(3);
  cRule.put('X', cRange);
  cRule.put('Y', cRange);
  oRule.put('X', oRange);
  oRule.put('Y', oRange);
  fertRule = new FertilityRule(cRule, oRule);
  
  
  myGrid = new SugarGrid(50,40,15, new GrowbackRule(1), fertRule, new PollutionRule(3, 3), new ReplacementRule(20, 50, f));
  myGrid.placeAgent(a1, 3, 4);
  myGrid.placeAgent(a2, 3, 5);
  myGrid.addAgentAtRandom(a3);
  
  
  
  for(int i = 0; i < 200; i++)
  {
    myGrid.addAgentAtRandom(f.makeAgent());
  }
  
  network = new SocialNetwork(myGrid);
  myGrid.addSugarBlob(10,20,3,8);
  myGrid.addSugarBlob(35,30,3,8);
  //myGrid.display();
  
  
  
  
  
  
}

void draw(){
  
  
  myGrid.update();
  myGrid.display();
  cultGraph.update(myGrid);
  avgSug.update(myGrid);
  age.update(myGrid);
  
}

void keyPressed() {
  switch (key) {
    case 'c' : colors = 1;
      break;
    case 'f' : colors = 2;
      break;
    case 's' : colors = 3;
      break;
  }
}
  