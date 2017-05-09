public class FertilityRule {
  Map<Character, Integer[]> childbearingOnset, climactericOnset;
  
  //in agentInfo, Integer[0] is childbearing age and Integer[1] is climacteric age. Integer[2] is current sugar level when first passed into map
  HashMap<Agent, Integer[]> agentInfo;
  
  public FertilityRule(Map<Character, Integer[]> childbearingOnset, Map<Character, Integer[]> climactericOnset){
     this.childbearingOnset = childbearingOnset;
     this.climactericOnset = climactericOnset;
     this.agentInfo = new HashMap<Agent, Integer[]>();
  }
  
  public boolean isFertile(Agent a){
      char aSex = a.getSex();
      int c, o;
      // if a is null or dead, remove all records of it from any storage it may be present in and return false
      if (a == null || a.isAlive() == false){
        agentInfo.remove(a);
        return false;
      } else if (this.agentInfo.containsKey(a) == false){
        //generate a random number for the onset of childbearing age (c) and climacteric age (o) based on fields of the class, inclusive
        //for c
        Integer[] cArray = this.childbearingOnset.get(aSex);
        int cUpper = cArray[1];
        int cLower = cArray[0];
        int cRange = cUpper - cLower;
        Random cRand = new Random();
        c = cRand.nextInt(cRange + 1) + cLower;
        //for o
        Integer[] oArray = this.climactericOnset.get(aSex);
        int oUpper = oArray[1];
        int oLower = oArray[0];
        int oRange = oUpper - oLower;
        Random oRand = new Random();
        o = oRand.nextInt(oRange + 1) + oLower;
        //store those generatred numbers in a way this is associated with a for later retrieval
        Integer[] agentArray = {c, o, a.getSugarLevel()};
        this.agentInfo.put(a, agentArray);
      } // regardless of whether this is the first time
      //check if agent has at least as much sugar as it did the first time it came through the function
      boolean sugarDifference;
      if(a.getSugarLevel() >= this.agentInfo.get(a)[2]){
        sugarDifference = true;
      } else {
        sugarDifference = false;
      }
      int agentC = this.agentInfo.get(a)[0];
      int agentO = this.agentInfo.get(a)[1];
      if (agentC <= a.getAge() && a.getAge() < agentO){
        if(sugarDifference){
          return true;
        }
      }
      return false;
  }
  
  public boolean canBreed(Agent a, Agent b, LinkedList<Square> local){
    boolean aFertile = false, bFertile = false, differentSex = false, bLocal = false, emptyLocal = false;
    //check if a is fertile
    if (this.isFertile(a)){
      aFertile = true;
    }
    //check if b is fertile
    if (this.isFertile(b)){
      bFertile = true;
    }
    //check if they are different sexes
    if (a.getSex() != b.getSex()){
      differentSex = true;
    }
    //check if b is in local
    for(Square current : local){
      if (current.getAgent() != null && current.getAgent().equals(b)){
        bLocal = true;
      }
      if (current.getAgent() == null){
        emptyLocal = true;
      }
    }
    if (aFertile && bFertile && differentSex && bLocal && emptyLocal){
      return true;
    } else {
      return false;
    }
    
  }
  
  public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal){
      if ( this.canBreed(a, b, aLocal) == false && this.canBreed(b, a, bLocal) == false){
        return null;
      }
      int newMet = 0, newVision = 0;
      char newSex;
      
      //randomly give child the metabolism of one parent
      Random metRand = new Random();
      boolean parentMet = metRand.nextBoolean();
      if(parentMet == false){
        newMet = a.getMetabolism();
      } else {
        newMet = b.getMetabolism();
      }
      
      //randomly give child the vision of one of the parents
      Random visionRand = new Random();
      boolean parentVision = visionRand.nextBoolean();
      if(parentVision == false){
        newVision = a.getVision();
      } else {
        newVision = b.getVision();
      }
      
      //pick a sex uniformly at random
      Random sexRand = new Random();
      boolean newSexBool = sexRand.nextBoolean();
      if (newSexBool == false){
        newSex = 'Y';
      } else {
        newSex = 'X';
      }
      
      //create a new child using these parameters and 0 initial sugar 
      Agent child = new Agent(newMet, newVision, 0, a.getMovementRule(), newSex);
      a.gift(child, a.getSugarLevel() / 2);
      b.gift(child, b.getSugarLevel() / 2);
      child.nurture(a, b);
      
      //pick a random square from aLocal or bLocal that does not have an Agent on it
      LinkedList<Square> babySquares  = new LinkedList<Square>();
    
      for (int i = 0; i < aLocal.size(); i++) {
        if (aLocal.get(i).getAgent() == null) {
          babySquares.add(aLocal.get(i));
        }
      }
    
      for (int i = 0; i < bLocal.size(); i++) {
        if (bLocal.get(i).getAgent() == null) {
          babySquares.add(bLocal.get(i));
        }
      }

    
     //now pick a square randomly.
     Collections.shuffle(babySquares);
     babySquares.get(0).setAgent(child);
     //print("A child is born!" );
     return child;
  }
  
  
  
}