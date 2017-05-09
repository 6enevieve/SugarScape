public class Agent{
  int metabolism, vision, currentSugar, age;
  char sex;
  MovementRule m;
  boolean[] culture = new boolean[11];
  Random rand = new Random();
  
  public Agent(int metabolism, int vision, int initialSugar, MovementRule m){
    this.metabolism = metabolism;
    this.vision = vision;
    this.currentSugar = initialSugar;
    this.m = m;
    this.age = 0;
    
    //generating random sex - there is an equal chance of X and Y, because this will generate randomly either a 0 or a 1
    
    int sexValue = rand.nextInt(2);
    if (sexValue == 1){
      this.sex = 'X';
    } else {
      this.sex = 'Y';
    }
    
    //generate random cultural characteristics
    this.culture = new boolean[11];
    for (int i = 0; i < culture.length; i++){
      culture[i] = rand.nextBoolean();
    }
  }
  
  public Agent(int metabolism, int vision, int initialSugar, MovementRule m, char sex){
    this.metabolism = metabolism;
    this.vision = vision;
    this.currentSugar = initialSugar;
    this.m = m;
    this.age = 0;
    //if sex is something other than 'X' or 'Y', throws an assertion error
    
    if (sex == 'X' || sex == 'Y'){
      this.sex = sex;
    } else {
      assert(1==0);
    }
    
    //generate random cultural characteristics
    this.culture = new boolean[11];
    for (int i = 0; i < culture.length; i++){
      culture[i] = rand.nextBoolean();
    }
     
  }
  
  public char getSex(){
    return this.sex;
  }
  
  public void gift(Agent other, int amount){
    if (this.currentSugar >= amount){
      this.currentSugar -= amount;
      //the only way to set an existing agent's sugar level is to access the field directly - isn't this bad practice?
      other.currentSugar += amount;
    } else {
      assert(1==0);
    }
  }
  
  public int getMetabolism(){
    return this.metabolism;
  }
  
  public int getVision(){
    return this.vision;
  }
  
  public int getSugarLevel(){
    return this.currentSugar;
  }
  
  public int getAge(){
    return this.age;
  }
  
  public MovementRule getMovementRule(){
    return this.m;
  }
  
  public void move(Square source, Square destination){
    if (destination.getAgent() == null || source.equals(destination)){
      source.setAgent(null);
      destination.setAgent(this); 
    }
    //NOTE THAT BECAUSE I COMMENTED THIS OUT, NO ERROR IS THROWN IF AN AGENT TRIES TO MOVE TO AN OCCUPIED SQUARE
    //IT JUST DOESNT MOVE. NOT SURE IF THIS IS A PROBLEM
    /*
    else {
      assert(1==0);
    }
    */
  }
  
  public void step(){
    if (this.currentSugar > 0){
      this.currentSugar = this.currentSugar - metabolism;
      this.age += 1;
    }
  }
  
  public void setAge(int howOld){
     if(howOld < 0){
       assert(1==0);
     }
     else {
       this.age = howOld;
     }
  }
  
  public boolean isAlive(){
    if (currentSugar > 0){
      return true;
    }
    else{
      return false;
    }
  }
  
  public void eat(Square s){
    this.currentSugar = this.currentSugar + s.getSugar();
    s.setSugar(0);
  }
   
  public void display(int x, int y, int scale){
    switch (colors) {
      case 1: 
        if (this.getTribe() == true){
          //red if true tribe
          fill(255, 0, 0);
        } else {
          //green if false tribe
          fill(0, 255, 50);
        } 
        break;
      case 2:
        if (fertRule.isFertile(this)) {
          // greenish if fertile
          fill(15, 150, 15);
        } else {
          //brown if infertile
          fill(134, 85, 45);
        }
        break;
      case 3: 
        if (this.getSex() == 'X'){
          //blue if X
          fill(0, 0, 255);
        } else {
          //pink if Y
          fill(255, 70, 180);
        }
        break;
    }
      
    ellipse(x, y, 3*scale/4, 3*scale/4);
  }
  
  //culture stuff
  
  public void influence(Agent other) {
    int traitNumber = rand.nextInt(11);
    
    if (other.culture[traitNumber] != this.culture[traitNumber]){
      other.culture[traitNumber] = this.culture[traitNumber];
    }
  }
  
  public void nurture(Agent parent1, Agent parent2){
    for (int i = 0; i < culture.length; i++){
      boolean whichParent = rand.nextBoolean();
      
      if (whichParent == true){
        culture[i] = parent1.culture[i];
      } else {
        this.culture[i] = parent2.culture[i];
      }
    }
  }
  
  public boolean getTribe(){
    int trues = 0, falses = 0;
    for (boolean current : culture){
      if (current == true){
        trues++;
      } else {
        falses++;
      }
    }
    if (trues > falses){
      return true;
    } else {
      return false;
    }
   
  }
  
  
}