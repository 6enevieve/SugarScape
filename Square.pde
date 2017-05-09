public class Square
{
    int sugarLevel, maxSugarLevel;
    int x, y;
    int pollution;
    boolean isOccupied;
    Agent currentAgent;
    public Square(int sugarLevel, int maxSugarLevel, int x, int y){
        this.sugarLevel = sugarLevel;
        this.maxSugarLevel = maxSugarLevel;
        this.x = x;
        this.y = y;
        this.isOccupied = false;
        this.pollution = 0;
    }
    
    public int getPollution(){
      return this.pollution;
    }
    
    public void setPollution(int level){
      if (level < 0){
        this.pollution = 0;
      }
      else {
        this.pollution = level;
      }
    }
      
    
    public int getSugar(){
        return this.sugarLevel;
    }
    
    public int getMaxSugar(){
        return this.maxSugarLevel;
    }
    
    public int getX(){
        return this.x;
    }
    
    public int getY(){
        return this.y;
    }
    
    public void setSugar(int howMuch){
        if (howMuch >= this.maxSugarLevel){
            this.sugarLevel = this.maxSugarLevel;
        }
        else if (howMuch < 0){
            this.sugarLevel = 0;
        }
        else {
            this.sugarLevel = howMuch;
        }
        
    }
    
    public void setMaxSugar(int howMuch){
        if (howMuch < 0){
            this.maxSugarLevel = 0;
        }
        else {
            this.maxSugarLevel = howMuch;
        }
    }
    
    public Agent getAgent(){
        return this.currentAgent;
    }
    
    public void setAgent(Agent a){
       if (a == null){
         this.currentAgent = null;
       }
       else if (this.getAgent() == null || this.currentAgent.equals(a)){
         this.currentAgent = a;
       }
       else {
         assert(1==0);
       }
    }
    
    public void display(int size){
       strokeWeight(4);
       stroke(255);
       fill(255 - this.pollution/6.0 * 25, 255 - sugarLevel/6.0*255, 255);
       rect(this.x * size, this.y * size, size, size);
       if(this.currentAgent != null){
         //stroke( (this.getSugar() * 50) + 5 );
         //fill( (this.getSugar() * 50) + 5);
         this.currentAgent.display(size*this.x + size/2, size*this.y + size/2, size);
       }
    }
      
}