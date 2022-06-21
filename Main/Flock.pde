import java.util.*;

// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  Map<Integer, ArrayList<PVector>> trajectories; 
  HashSet<Integer> groups;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    groups = new HashSet<>();
    trajectories = new HashMap<Integer, ArrayList<PVector>>();
  }

  void run(int pause) {
    for (Boid b : boids) {
      b.group = b.index;
    }
    for (Boid b : boids) {
      b.grouping(this, boids);
    }
    for (Boid b : boids) {
      if (pause ==0) {
        b.run(boids);
      }
    }
    checkGroups();
    for(int g : trajectories.keySet()){
      findCenter(g);
      int g_red = boids.get(g).red;
      int g_green = boids.get(g).green;
      int g_blue = boids.get(g).blue;
      for (PVector p : trajectories.get(g)){
        renderCenter(p, g_red, g_green, g_blue);
      }
    }
  }

  void addBoid(Boid b) {
    b.index = boids.size();
    boids.add(b);
  }
  
  void findCenter(int group){
    PVector barycentre = new PVector();
    int num = 0;
    for (Boid b : boids){
      if (b.group == group ){
        barycentre.add(b.position);
        num++;
      }
    }
    if (num > 0){
      trajectories.get(group).add(barycentre.div(num));
    }
    else {
      print("No boids in group");
      return;
    }
  }
  
  void renderCenter(PVector b, int red, int green, int blue){
    if(b != null){
      pushMatrix();
      fill(red,green,blue, 150);
      ellipse(b.x, b.y, 2, 2);
      popMatrix();
    }
  }
  
  void checkGroups(){
    for(int g : groups){
      if(!trajectories.containsKey(g)){
        trajectories.put(g, new ArrayList<PVector>());
      }
    }
    for(int g : trajectories.keySet()){
      if(!groups.contains(g)){
        trajectories.remove(g);
      }
    }
  }

}
