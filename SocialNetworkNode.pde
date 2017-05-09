public class SocialNetworkNode{
    Agent a;
    boolean painted;
    
    public SocialNetworkNode(Agent a){
      this.a = a;
      this.painted = false;
    }
    
    public boolean painted(){
      return this.painted;
    }
    
    public void paint(){
      this.painted = true;
    }
    
    public void unpaint(){
      this.painted = false;
    }
    
    public Agent getAgent(){
      return this.a;
    }
  
}