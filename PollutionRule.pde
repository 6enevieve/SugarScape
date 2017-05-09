public class PollutionRule{
   int gatheringPollution, eatingPollution;
   
   public PollutionRule(int gatheringPollution, int eatingPollution){
     this.gatheringPollution = gatheringPollution;
     this.eatingPollution = eatingPollution;
   }
   
   public void pollute(Square s){
      if (s.getAgent() != null){ 
         int c = s.getPollution();
         int m = s.getAgent().getMetabolism();
         int g = s.getSugar();
         s.setPollution(c + (g * gatheringPollution) + (m * eatingPollution)); 
      }
   }
  
  
}