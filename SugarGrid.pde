import java.util.*;
public class SugarGrid{
  int w, h, sideLength;
  GrowthRule currentGrowthRule;
  PollutionRule currentPolRule;
  FertilityRule currentFertRule;
  ReplacementRule currentRepRule;
  Square[][] grid;
  
  public SugarGrid(int w, int h, int sideLength, GrowthRule g, FertilityRule f, PollutionRule p, ReplacementRule r){
      this.w = w;
      this.h = h;
      this.sideLength = sideLength;
      this.currentGrowthRule = g;
      this.currentFertRule = f;
      this.currentRepRule = r;
      this.currentPolRule = p;
      this.grid = new Square[w][h];
      for(int i = 0; i < w; i++){
        for(int j = 0; j < h; j++){
          grid[i][j] = new Square(0, 0, i, j);
        }
      }
      
  }
  
  public ArrayList<Agent> getAgents(){
    ArrayList a = new ArrayList<Agent>();
    for(int i = 0; i < w; i++){
        for(int j = 0; j < h; j++){
          Agent current = grid[i][j].getAgent();
          if (current != null){
            a.add(current);
          }
        }
      }
    return a;
  }
  
  public int getWidth(){
    return this.w;
  }
  
  public int getHeight(){
    return this.h;
  }
  
  public int getSquareSize(){
    return this.sideLength;
  }
  
  public int getSugarAt(int i, int j){
    return this.grid[i][j].getSugar();  
  }
  
  public int getMaxSugarAt(int i, int j){
    return this.grid[i][j].getMaxSugar();
  }
  
  public Agent getAgentAt(int i, int j){
    return this.grid[i][j].getAgent();
  }
  
  public void placeAgent(Agent a, int x, int y){
    this.grid[x][y].setAgent(a);
  }
  
  public void addAgentAtRandom(Agent a){
    int randx = (int)(Math.random() * w);
    int randy = (int)(Math.random() * h);
    if (this.getAgentAt(randx, randy) == null){
      this.placeAgent(a, randx, randy);
    }
    else {
      this.addAgentAtRandom(a);
    }
    
    
  }
  
  public double euclidianDistance(Square s1, Square s2){
    int x1 = s1.getX();
    int y1 = s1.getY();
    int x2 = s2.getX();
    int y2 = s2.getY();
    int realdifX = Math.abs(x1 - x2);
    int realdifY = Math.abs(y1 - y2);
    int wrapdifX = this.w - realdifX;
    int wrapdifY = this.h - realdifY;
    double wrapdist = Math.sqrt((wrapdifX * wrapdifX) + (wrapdifY * wrapdifY));
    double realdist = Math.sqrt((realdifX * realdifX) + (realdifY * realdifY));
    if (wrapdist < realdist){
      return wrapdist;
    }
    else if (realdist < wrapdist){
      return realdist;
    }
    else {
      return realdist;
    }
  }
  
  public void addSugarBlob(int x, int y, int radius, int max){
    Square center = this.grid[x][y];
    if (center.getMaxSugar() < max){
        center.setMaxSugar(max);
        center.setSugar(max);
    }
    
    for(int l = 1; l < w; l++){
      for(int i = 0; i < w; i++){
        for(int j = 0; j < h; j++){
          Square current = this.grid[i][j];
          if (euclidianDistance(center, current) > radius * (l- 1) && euclidianDistance(center, current) <= l * radius){
            if (current.getMaxSugar() < max - l){
              current.setMaxSugar(max - l);
              current.setSugar(max - l);
            }
          }
        }
      }
    }
   
    
    
    
 }
 
 public LinkedList<Square> generateVision(int x, int y, int radius){
   LinkedList<Square> vision = new LinkedList<Square>();
   if(x >= w || y >= h || radius < 0){
     return vision;
   }
   else if (radius == 0){
     vision.add(grid[x][y]);
     return vision;
   }
    else{
      vision.add(grid[x][y]);
      for(int i = 0; i < w; i++){
        for(int j = 0; j < h; j++){
          if(euclidianDistance(grid[x][y], grid[i][j]) <= radius){
            vision.add(grid[i][j]);
          }
          
        }
      }
      return vision;
    }
 }
 
 public void killAgent(Agent a){
   a.currentSugar = 0;
   currentRepRule.replaceThisOne(a);
   currentFertRule.isFertile(a);
 }
  
  public void display(){
     for(int i = 0; i < w; i++){
       for(int j = 0; j < h; j++){
         this.grid[i][j].display(this.sideLength);
       }
     }
  }
  
  public void update(){
    for(int i = 0; i < w; i++){
      for(int j = 0; j < h; j++){
        Square current = grid[i][j];
        currentGrowthRule.growBack(current);
        if(current.getAgent() != null){
           PollutionRule pr = this.currentPolRule;
           FertilityRule fr = this.currentFertRule;
           Agent a = current.getAgent();
           LinkedList<Square> aLocal = this.generateVision(i, j, a.getVision());
           MovementRule m = a.getMovementRule();
           Square dest = m.move(aLocal, this, current);
           a.move(current, dest);
           a.step();
           if(a.isAlive() == false){
             current.setAgent(null);
             
           }
           else{
             a.eat(current);
           }
           //pollute function already checks whether square is occupied
           pr.pollute(current);
           //lets breed!
           for(Square currentInA : aLocal){
             if(currentInA.getAgent() != null){
               LinkedList<Square> bLocal = generateVision(currentInA.getX(), currentInA.getY(), currentInA.getAgent().getVision());
               fr.breed(a, currentInA.getAgent(), aLocal, bLocal);
               
             }
          }
        }
      } 
    }
  }
  
  
  
  
}