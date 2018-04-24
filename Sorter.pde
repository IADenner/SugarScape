public abstract class Sorter
{
  public Sorter()
  {
    
  }
  
  public abstract void sort(ArrayList<Agent> al);
  
  public boolean lessThan(Agent a, Agent b)
  {
    if (a.getSugarLevel() < b.getSugarLevel()) return true;
    else return false;
  }
  
}

public class BubbleSorter extends Sorter
{
 public BubbleSorter()
 {
   
 }
 
 public void sort(ArrayList<Agent> al)
 {
   
   //using while loops because using for loops screws things up - WAIT - THAT'S JUST FOR ENCHANCED FOR LOOP
   int i = 0;
   while (i < al.size() - 1)
   {
     int j = 0;
     //iterate through inside loop 
     while (j < al.size() - i - 1)
     {
       if (al.get(j).getSugarLevel() > al.get(j + 1).getSugarLevel()) //no need for elses here
       {
         Agent tempAgent = al.get(j + 1); //create temporary holder variable
         al.set(j + 1, al.get(j));
         al.set(j, tempAgent); //Swap!!
       }
       
       j ++;
     }
     
     i++;
   }
 }
 
}

public class InsertionSorter extends Sorter
{
 public InsertionSorter()
 {
   
 }
 
 public void sort(ArrayList<Agent> al)
 {
   //iterate through every element in the list in outside loop
   for (int i = 0; i < al.size(); i ++)
   {
     int j = i;
     //in inside loop, iterate through every element to the left of our value. If it is less than our value, move to the right of our value. 
     while ((j > 0) && (al.get(j).getSugarLevel() > al.get(i).getSugarLevel()))
     {
       al.set(j, al.get(j - 1));
       j = j-1;
     }
     al.set(j, al.get(i));
   }
 }
}

public class MergeSorter extends Sorter
{
 public MergeSorter()
 {
   
 }
 
 public void merge(ArrayList<Agent> al1, ArrayList<Agent> al2)
 {
   
 }
 public void sort(ArrayList<Agent> al)
 {
   
   //FIRST STEP - DIVIDE
     ArrayList<Agent> al1 = new ArrayList<Agent>();
     ArrayList<Agent> al2 = new ArrayList<Agent>();
     
     int listsize = (int)(al.size()/2); //round down al/2. 
     //Iterate through the first (rounded down) half of the list
     for (int i = 0; i < listsize; i++)
     {
       
       al1.add(i, al.get(i));
     }
     //iterate through the second half
     for (int i = listsize + 1; i < al.size(); i ++)
     {
       
       al2.add(i - listsize - 1, al.get(i));
     }
     
     //SECOND STEP - RECURSE
     if (al1.size() > 21)
     {
       sort(al1);
     }
     if (al2.size() > 21)
     {
       sort(al2);
     }
     
     //THIRD STEP STEP - MERGE
     
     if (al1.size() + al2.size() < al.size()/2.0)
     {
       int j = 0, k = 0;
       while (j < al1.size() && k < al2.size())
       {
         //merge part - tricky
         if (al1.get(j).getSugarLevel() < al2.get(k).getSugarLevel())
         {
           al.set(j + k, al1.get(j));
           j ++;
         }
         else
         {
           al.set(j + k, al2.get(k));
           k++;
         }
       }
       
       //copy leftovers
       while (j < al1.size())
       {
        al.add(j, al1.get(j)); 
        j++; 
       }
       while (k < al2.size())
       {
        al.add(j, al1.get(k));
        k++;
       }
     
     }
     
 }
}
 
 public class QuickSorter extends Sorter{
  public QuickSorter()
  {
    
  }
  
  public void sort(ArrayList<Agent> al)
  {
    Agent pivot = al.get(al.size() - 1);
    
    
    //MOVE ELEMENTS
    int i = 0;
    for (int j = 0; j < al.size(); j++)
    {
      //if less than pivot, move to the right. If more, don't do anything
     if (al.get(j).getSugarLevel() <= pivot.getSugarLevel())
     {
       
       Agent tempAgent = al.get(j); //Swap elements
       al.set(j, al.get(i));
       al.set(i, tempAgent);
       
       i++;
     }
    }
    int partition = i + 1;
    //The internet told me I had to do this when I asked it why my code wasn't working. 
    
    if (partition < al.size())
    {
      Agent tempAgent = al.get(partition);
      al.set(partition, pivot);
      al.set((al.size() - 1), tempAgent);
      
      
      //DIVIDE INTO TWO SECTIONS AND RECURSE
       ArrayList<Agent> al1 = new ArrayList<Agent>();
       ArrayList<Agent> al2 = new ArrayList<Agent>();
       
       
       //Iterate through all elements less than partition
       for (int j = 0; j < partition; j++)
       {
         
         al1.add(i, al.get(j));
       }
       //iterate through all elements more than partition
       for (int j = partition; j < al.size(); j++)
       {
         al2.add(j - i, al.get(j));
       }
       
       sort(al1);
       sort(al2);
       
       //merge al1 and al2 
       for (int j = 0; j < al2.size(); j++)
       {
         
         al.add(al2.get(j));
       }
       
       al = al1; //set al to al1
    }
  }
   
 }
 