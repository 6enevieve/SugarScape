public interface GrowthRule {
    public void growBack(Square s);
} 



public class GrowbackRule implements GrowthRule{
    
    int currentRate;
   
    public GrowbackRule(int rate) {
        this.currentRate = rate;
    }
    
    public void growBack(Square s){
        int c = s.getSugar();  
        c = c + this.currentRate;
        s.setSugar(c);
    }
}


public class SeasonalGrowbackRule implements GrowthRule{
  int alpha, beta, gamma, equator, numSquares, counter;
  boolean northSummer;
  boolean southSummer = !northSummer;
  
  public SeasonalGrowbackRule(int alpha, int beta, int gamma, int equator, int numSquares){
      this.alpha = alpha;
      this.beta = beta;
      this.gamma = gamma;
      this.equator = equator;
      this.numSquares = numSquares;
      northSummer = true;
      this.counter = 0;
  }
  
  public boolean isNorthSummer(){
    if (this.northSummer == true){
      return true;
    }
    else
    return false;
  }
  
  
  public void growBack(Square s){
      int c = s.getSugar();
      int n;
      //if s is at or above equator and it's northSummer
      if (s.getY() <= equator && northSummer == true){
        n = c + alpha;
        s.setSugar(n);
      }
      //if s is below the equator and it's southSummer
      else if (s.getY() > equator && southSummer == true){
        n = c + alpha;
        s.setSugar(n);
      }
      //if s is at or above the equator and it's southSummer
      else if (s.getY() <= equator && southSummer == true){
        n = c + beta;
        s.setSugar(n);
      }
      //if s is below equator and it's northSummer
      else if (s.getY() > equator && northSummer == true){
        n = c + beta;
        s.setSugar(n);
      }
      //if the rule has been called gamma*numSquares since the last change of seasons
      if (counter == gamma*numSquares){
        if(northSummer == true){
          southSummer = true;
          northSummer = false;
          counter = 0;
        }
        else if (northSummer == false){
          southSummer = false;
          northSummer = true;
          counter = 0;
        }
      }
      else {
        this.counter = this.counter + 1;
      }  
  }
  
  
  
  
  
}