public interface MovementRule{
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle);
}

public class SugarSeekingMovementRule implements MovementRule{
   
  public SugarSeekingMovementRule(){
  }
  
  public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle){
      Collections.shuffle(neighbourhood);
      Square current;
      
      Square currentMax = neighbourhood.getFirst();
      int size = neighbourhood.size();
      for(int i = 0; i < size; i++){
        current = neighbourhood.get(i);
        if (currentMax.getSugar() < current.getSugar()){
          currentMax = current;
        }
        else if (currentMax.getSugar() == current.getSugar()){
          if (g.euclidianDistance(current, middle) < g.euclidianDistance(currentMax, middle)){
            currentMax = current;
          }
          else {
            currentMax = currentMax;
          }
        }
      }
      return currentMax;
   }
}

public class PollutionMovementRule implements MovementRule{
    public PollutionMovementRule(){
    }
    
    public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle){
      Collections.shuffle(neighbourhood);
      Square current;
      Square currentBest = neighbourhood.getFirst();
      double bestratio;
      double curratio;
      //ratio is pollution/sugar, so smallest ratio is preferred
      if (currentBest.getSugar() != 0){;
        bestratio = currentBest.getPollution() / currentBest.getSugar();
      }
      else bestratio = currentBest.getPollution();
      
      
      int size = neighbourhood.size();
      for(int i = 0; i < size; i++){
        current = neighbourhood.get(i);
        //setting curratio to correct number
        if (current.getSugar() != 0){
          curratio = current.getPollution() / current.getSugar();
        }
        else curratio = current.getPollution();
        //updating bestratio is curratio is better
        if (bestratio > curratio){
          bestratio = curratio;
          currentBest = current;
        }
        //if ratio of pollution to sugar is the same and not 0
        else if (bestratio == curratio && bestratio != 0){
          if (g.euclidianDistance(current, middle) < g.euclidianDistance(currentBest, middle)){
            currentBest = current;
          }
          else {
            currentBest = currentBest;
          }
        }
        //if no squares so far have had any pollution
        else if (bestratio == 0 && curratio == 0){
          //if current has more sugar
          if(current.getSugar() > currentBest.getSugar()){
            currentBest = current;
            bestratio = curratio;
          }
          //if currentBest has more sugar
          else if (current.getSugar() < currentBest.getSugar()){
            currentBest = currentBest;
          }
          //if the amount of sugar is the same
          else if (current.getSugar() == currentBest.getSugar()){
            if (g.euclidianDistance(current, middle) < g.euclidianDistance(currentBest, middle)){
              currentBest = current;
            }
            else {
              currentBest = currentBest;
            }
          }
        } 
      }
      return currentBest;
   
    }
  
}

public class CombatMovementRule extends SugarSeekingMovementRule {
    int alpha;
    
    public CombatMovementRule(int alpha){
      this.alpha = alpha;
    }
    
    public boolean fightThis(Agent a, Agent other){
      if(a != null && other != null){
        if (other.getTribe() == a.getTribe()){
          return false;
        } else if (other.getSugarLevel() >= a.getSugarLevel()){
          return false;
        }
      }
      return true;
      
    }
    
    public Square move(LinkedList<Square> neighbourhood, SugarGrid g, Square middle){
      LinkedList<Square> updatedList = new LinkedList<Square>(neighbourhood);
      LinkedList<Square> newNeighbours = new LinkedList<Square>();
      Square target = null;
      
      //remove any square from neighbourhood that contains an agent of the same tribe as the middle square
      for(Square current : neighbourhood){
        Agent currentAgent = current.getAgent();
        if(currentAgent == null){
          //nothing
        } else if (fightThis(middle.getAgent(), currentAgent) == false) {
          updatedList.remove(current);
        } 
      }
      
      neighbourhood.clear();
      neighbourhood.addAll(updatedList);
      
      for (Square current : neighbourhood){
        LinkedList<Square> vision = g.generateVision(current.getX(), current.getY(), middle.getAgent().getVision());
        for(Square visionI : vision){
          if (visionI.getAgent() == null){
            //
          } else if (fightThis(middle.getAgent(), current.getAgent()) == false){
            updatedList.remove(current);
          }
        }
      }
      
      neighbourhood.clear();
      neighbourhood.addAll(updatedList);
      //replace each square in neighbourhood that still has an agent with a new square of the same x and y coordinates
      //but a Sugar and MaximumSugar level that are increased by the min of alpha and the sugar level of the occupying agent
      for (int c = 0; c < neighbourhood.size(); c++){
        if (neighbourhood.get(c).getAgent() != null){
          int newSugar = neighbourhood.get(c).getSugar() * alpha;
          int newMaxSugar = neighbourhood.get(c).getMaxSugar() + neighbourhood.get(c).getAgent().getSugarLevel();
          newNeighbours.add(new Square(neighbourhood.get(c).getX(), neighbourhood.get(c).getY(), newSugar, newMaxSugar));
        }
      }
      
      //Square newTarget = super.move(newNeighbours, g, middle);
      
      Square newTarget = super.move(neighbourhood, g, middle);
      
      
      for(int i = 0; i < neighbourhood.size(); i++){
        if (newTarget == null){
          //do nothing
        } else if (neighbourhood.get(i).getX() == newTarget.getX() && neighbourhood.get(i).getY() == newTarget.getY()){
          target = neighbourhood.get(i);
        }
      }
      Agent casualty = null;
      if (target != null && target.getAgent() != null){
          casualty = target.getAgent();
          target.setAgent(null);
          middle.getAgent().currentSugar = casualty.getSugarLevel() + alpha;
          g.killAgent(casualty);
          
          return target;
          
      }
      return target;
      
      
      
      
      
      
    }
    //function ends
}
//class ends


  