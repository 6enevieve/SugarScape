public abstract class Sorter{
   public abstract void sort(ArrayList<Agent> al);
   
   public boolean lessThan(Agent a, Agent b){
      if (a.getSugarLevel() < b.getSugarLevel()){
        return true;
      }
      else return false;
   }
  
}

public class BubbleSorter extends Sorter{
    
  public void sort(ArrayList<Agent> al){
    for(int n = 0; n < al.size(); n++){
      for(int i = 0; i < al.size() - 1; i++){
        Agent current = al.get(i);
        Agent next = al.get(i + 1);
        if(lessThan(next, current) == true){
          Agent temp = current;
          al.set(i, next);
          al.set(i+1, temp);
          
        }
      }
    }
  }
  
}

public class InsertionSorter extends Sorter{
  
  public void sort(ArrayList<Agent> al){
    int s = al.size();
    for(int i = 1; i < s; i++){
      Agent comp = al.get(i);
      int j = i - 1;
      while(j >= 0 && al.get(j).getSugarLevel() > comp.getSugarLevel()){
        al.set(j + 1, al.get(j));
        j--;
      }
      al.set(j + 1, comp);
    }
  }
  
}

public class MergeSorter extends Sorter{
  
  public void sort(ArrayList<Agent> al){
    ArrayList<Agent> lowHalf = new ArrayList<Agent>(), hiHalf = new ArrayList<Agent>();
    if(al.size() >= 2)
    {
      for(int i = 0; i < al.size() / 2; i++){
        lowHalf.add(al.get(i));
      }
      for(int i = al.size() / 2; i < al.size(); i++){
        hiHalf.add(al.get(i));
      }
      this.sort(lowHalf);
      this.sort(hiHalf);
      ArrayList<Agent> temp = merge(lowHalf, hiHalf);
      for(int i = 0; i < al.size(); i++){
        al.set(i, temp.get(i));
      }
    } 
  }
  
  
  
  public ArrayList<Agent> merge(ArrayList<Agent> a1, ArrayList<Agent> a2){
    ArrayList<Agent> a3 = new ArrayList<Agent>();
    while(a1.size() > 0 || a2.size() > 0){
      if(a1.size() == 0){
        a3.add(a2.get(0));
        a2.remove(0);
      }
      else if(a2.size() == 0){
        a3.add(a1.get(0));
        a1.remove(0);
      }
      else{
        if(a1.get(0).getSugarLevel() < a2.get(0).getSugarLevel()){
          a3.add(a1.get(0));
          a1.remove(0);
        }
        else {
          a3.add(a2.get(0));
          a2.remove(0);
        }
      }
      
    } 
    
    return a3;
  }
    
}


public class QuickSorter extends Sorter{
  
  public void sort(ArrayList<Agent> al){
    int ltsize = 0, gtsize = 0;
    
    if(al.size() <= 1){
      return;
    }
    Agent pivot = al.get(al.size() -1);
    al.remove(pivot);
    for(int i = 0; i < al.size() - 1; i++){
      Agent current = al.get(i);
      if(current.getSugarLevel() <= pivot.getSugarLevel()){
        ltsize++;
      }
      else{
        gtsize++;
      }
    }
    ArrayList<Agent> lt = new ArrayList<Agent>(ltsize);
    ArrayList<Agent> gt = new ArrayList<Agent>(gtsize);
    for(int i = 0; i < al.size() - 1; i++){
      Agent current = al.get(i);
      if(current.getSugarLevel() <= pivot.getSugarLevel()){
        lt.add(current);
      }
      else{
        gt.add(current);
      }
    }
    sort(lt);
    sort(gt);
    al.clear();
    al.addAll(lt);
    al.add(pivot);
    al.addAll(gt);
      
  }
  
  
  
  
}