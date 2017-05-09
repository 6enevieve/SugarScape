public class Graph{
  int x, y, w, h;
  String xlab, ylab;
  
  public Graph(int x, int y, int howWide, int howTall, String xlab, String ylab){
     this.x = x;
     this.y = y;
     this.w = howWide;
     this.h = howTall;
     this.xlab = xlab;
     this.ylab = ylab;
  }
  
  public void update(SugarGrid g){
     stroke(150);
     fill(255);
     //rect(this.x, this.y - this.h, this.w, this.h); 
     stroke(0);
     line(this.x, this.y, this.x + this.w, this.y);
     line(this.x, this.y, this.x, this.y - this.h);
     fill(0);
     text(xlab, this.x, this.y + 15);
     //rotating window to display rotated text
     pushMatrix();
     translate(this.x, this.y);
     rotate(-PI/2.0);
     text(ylab, 0, -5);
     popMatrix();
    
  }
  
  
}

abstract public class LineGraph extends Graph{
  int updateCalls;
  
  
  public LineGraph(int x, int y, int howWide, int howTall, String xlab, String ylab){
    super(x, y, howWide, howTall, xlab, ylab);
    this.updateCalls = 0;
  }  
  
  public abstract int nextPoint(SugarGrid g);
  
  public void update(SugarGrid g){
    if (this.updateCalls == 0){
      super.update(g);
      updateCalls++;
    }
    
    stroke(75, 0, 170);
    point(updateCalls + this.x, this.y - nextPoint(g));
    this.updateCalls++;
    if(this.updateCalls >= this.w-1){
      this.updateCalls = 0;
      fill(205);
      stroke(205);
      rect(this.x, this.y - this.h, this.w, this.h); 
      super.update(g);   
     }
  }
}
  



abstract public class CDFGraph extends Graph{
  int callsPerValue, numUpdates, numPerCell;
  
  public CDFGraph(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue){
    super(x, y, howWide, howTall, xlab, ylab);
    this.callsPerValue = callsPerValue;
    this.numUpdates = 0;
  }
  
  public abstract void reset(SugarGrid g);
  
  public abstract int nextPoint(SugarGrid g);
  
  public abstract int getTotalCalls(SugarGrid g);
  
  public void update(SugarGrid g){
    this.numUpdates = 0;
    super.update(g);
    this.reset(g);
    //this will throw an exception when all agents are dead because getTotalCalls will return zero. this is kind of intended though because this way the program
    //ends when all agents die
    //this.numPerCell = g.getWidth() / this.getTotalCalls(g);
    while(this.numUpdates < this.getTotalCalls(g)){
       fill(75, 0, 170);
       stroke(75, 0, 170);
       rect(this.numUpdates + this.x + 4, this.nextPoint(g) + (this.y - 5), 1, 1);
       this.numUpdates++;
       
    }
  }
}

public class WealthCDF extends CDFGraph{
  int totalSugar, sugarSoFar;
  ArrayList<Agent> sugarList = new ArrayList<Agent>();
  
  public WealthCDF(int x, int y, int howWide, int howTall, String xlab, String ylab, int callsPerValue){
     super(x, y, howWide, howTall, xlab, ylab, callsPerValue);
  }
   

     
  public void reset(SugarGrid g){
     ArrayList<Agent> temp = g.getAgents();
     //see which sort is most efficient
     isort.sort(temp);
     this.sugarList.clear();
     this.sugarList.addAll(temp);
     for(Agent current : sugarList){
        this.totalSugar += current.getSugarLevel();
     }
     this.sugarSoFar = 0;
  }
  
  public int nextPoint(SugarGrid g){
     int sugarCounter = 0, avg = 0;
     for(int i = this.numUpdates; i < this.numUpdates + callsPerValue; i++){
       sugarCounter += sugarList.get(i).getSugarLevel();
     }
     avg = sugarCounter / this.callsPerValue;
     this.sugarSoFar += avg;
     if(sugarList.size() - this.numUpdates > this.callsPerValue){
       avg = avg / (sugarList.size() - this.numUpdates);
     }
     else avg = avg / this.callsPerValue;
    this.sugarSoFar += avg;
    int result = this.sugarSoFar / this.totalSugar;
    return result / 10;
  }
  
  public int getTotalCalls(SugarGrid g){
    return g.getAgents().size() / this.callsPerValue;
  }
}
  
  
  
  




public class TotalGraph extends LineGraph{
  
  public TotalGraph(int x, int y, int howWide, int howTall, String xlab, String ylab){
    super(x, y, howWide, howTall, xlab, ylab);
  }
  
  public int nextPoint(SugarGrid g){
    ArrayList<Agent> a = g.getAgents();
    return a.size() / (this.h / 20);
  }
}

public class AvgSugGraph extends LineGraph{
  
  public AvgSugGraph(int x, int y, int howWide, int howTall, String xlab, String ylab){
    super(x, y, howWide, howTall, xlab, ylab);
  }
  
  public int nextPoint(SugarGrid g){
     int avg, total = 0;
     ArrayList<Agent> a = g.getAgents();
     for(int i = 0; i < a.size(); i++){
       Agent current = a.get(i);
       total += current.getSugarLevel();
     }
     
     /*if(a.size() < 2){
       return total;
     }
     else {
       avg = total / a.size();
       return avg;
     }*/
     
     
     if(a.size() > 0) {
       return (int)((total / a.size()) / 10 );
     } else {
       return 0;
     }
  }
}

public class AgeGraph extends LineGraph {
  public AgeGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }
  public int nextPoint(SugarGrid g) {
    ArrayList<Agent> agents = g.getAgents();
    
    int totalAge = 0;
    
    for(int i = 0; i < agents.size(); i++) {
      totalAge = totalAge + agents.get(i).getAge();
    }      
    
    if(agents.size() > 0) {
      return (totalAge / agents.size()) / 5;
    }
    else {
      return 0;
    }
    
  }
  
  public void update(SugarGrid g) {
    super.update(g);
  }
}

public class CultureGraph extends LineGraph {
  public CultureGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }
  
  public int nextPoint(SugarGrid g) {
    
    ArrayList<Agent> agents = g.getAgents();
    
    int percentTrue = 0;
        
    for (int i = 0; i < agents.size(); i++) {
      if (agents.get(i).getTribe() == true) {
        percentTrue = percentTrue + 1;
      }
    }
    
    
   if(agents.size() > 0) {
      return (int) (this.h * (percentTrue / (1.0 * agents.size())));
    }
    else{
      return 0;
    }

   
  }

}


public class MetaGraph extends LineGraph{
  
  public MetaGraph(int x, int y, int howWide, int howTall, String xlab, String ylab){
    super(x, y, howWide, howTall, xlab, ylab);
  }
  
  public int nextPoint(SugarGrid g){
     int avg, total = 0;
     ArrayList<Agent> a = g.getAgents();
     for(int i = 0; i < a.size(); i++){
       Agent current = a.get(i);
       total += (current.getMetabolism() * 5);
     }
     if(a.size() < 2){
       return total;
     } else{
       avg = total / a.size();
       return avg;
     }
  }
}