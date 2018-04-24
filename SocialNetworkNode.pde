/*public SocialNetworkNode(Agent a) - initializes a new SocialNetworkNode storing the passed agent. The node is unpainted initially.
public boolean painted() - returns true if this node has been painted.
public void paint() - Sets the node to painted.
public void unpaint() - Sets the node to unpainted.
public Agent getAgent() - Returns the agent stored at this node.*/
class SocialNetworkNode {
  Agent a;
  boolean painted;
  
 public SocialNetworkNode(Agent A)
 {
   this.a = A;
 }
 public boolean painted()
 {
  return painted; 
 }
 
 public void paint()
 {
   painted = true;
 }
 
 public void unpaint()
 {
  painted = false; 
 }
 
 public Agent getAgent()
 {
   return a; 
 }
 
 public boolean equals(SocialNetworkNode n)
 {
  if  (n.getAgent().equals(a)) return true;
  else return false;
 } 
 public String toString()
 {
   if (a != null) return "Agent at " + a.getX() + ", " + a.getY();
   else return "Null Agent";
 }
 
  
}