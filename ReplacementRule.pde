import java.util.*;
public class ReplacementRule{
  int minAge, maxAge;
  AgentFactory factory;
  HashMap<Agent, Integer> agentMap  = new HashMap<Agent, Integer>();
  
  public ReplacementRule(int minAge, int maxAge, AgentFactory fac){
    this.minAge = minAge;
    this.maxAge = maxAge;
    this.factory = fac;
  }
  
  public boolean replaceThisOne(Agent a){
    //if a is null
    if (a == null){
      return false;
    }
    //decide whether to replace based on dead or alive
    boolean answer;
    if(a.isAlive() == false){
      answer = true;
    }
    else {
      answer = false;
    }
    
    
    
    int lifespan;
    //check if agent has been seen by this function before
    if (agentMap.containsKey(a)){
       if (a.getAge() > agentMap.get(a)){
         answer = true;
         a.setAge(1 + this.maxAge);
      }
    }
    //if this is the first time agent has been seen
    else {
      //generate random integer for lifespan
      lifespan = ((int)(Math.random() * ((this.maxAge - this.minAge)))) + this.minAge;
      agentMap.put(a, lifespan);
    }
    
    
    return answer;
  }
  
  public Agent replace(Agent a, List<Agent> others){
     return a;
  }
  
  
  
  
  
  
  
  
  
  
  
}