public class AgentFactory{
   int minMeta, maxMeta, minVision, maxVision, minInit, maxInit;
   MovementRule m;
   
   public AgentFactory(int minMetabolism, int maxMetabolism, int minVision, int maxVision, int minInitialSugar, int maxInitialSugar, MovementRule m){
     this.minMeta = minMetabolism;
     this.maxMeta = maxMetabolism;
     this.minVision = minVision;
     this.maxVision = maxVision;
     this.minInit = minInitialSugar;
     this.maxInit = maxInitialSugar;
     this.m = m;
   }
   
   public Agent makeAgent(){
     //for future reference, i'm generating a random int between two values by multiplying rand by the difference
     //between min and max, then adding 1 to that value to make it inclusive.
     //then to set the proper upper bound, we add the minimum back to this entire integer
     int meta = ((int)(Math.random() * ((this.maxMeta - this.minMeta) + 1))) + this.minMeta;
     int vision = ((int)(Math.random() * ((this.maxVision - this.minVision) + 1))) + this.minVision;
     int init = ((int) (Math.random() * ( (this.maxInit - this.minInit) + 1) ) ) + this.minInit;
     return new Agent(meta, vision, init, this.m);
   }
  
  
  
}