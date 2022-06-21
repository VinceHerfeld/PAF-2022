import java.util.*;

// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  Map<Integer, ArrayList<PVector>> trajectories; 
  HashSet<Integer> groups;
  Boid[][] map;

  Flock() {
    map = new Boid[width][height];
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    groups = new HashSet<>();
    trajectories = new HashMap<Integer, ArrayList<PVector>>();
  }
  void updateMap(){
    for (int i=0; i<width;i++){
      Arrays.fill(map[i],null);
    }
    for(Boid b : boids){
      int x = (int)b.getX();
      int y = (int)b.getY();
      map[mod_width(x)][mod_height(y)] = b;
    }
  }
  void run(int pause) {
    for (Boid b : boids){
      b.searchNeighbour(this.map);
    }
    for (Boid b : boids) {
      b.group = b.index;
    }
    groups.clear();
    for (Boid b : boids) {
      b.grouping(boids);
    }
    for (Boid b : boids) {
      if (pause ==0) {
        b.run(boids);
      }
    }
    checkGroups();
    println(groups + " --" + trajectories.keySet());
    for(int g : groups){
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
      print("No boids in group : " + group + "\n");
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
    ArrayList<Integer> removed = new ArrayList<>();
    for(int g : trajectories.keySet()){
      if(!groups.contains(g)){
        removed.add(g);
      }
    }
    for (int i : removed) {
      trajectories.remove(i);
    }
  }
  
  
  
  
  int mod_width(int x){
    if(x<0){
      x += width;
      return x;
    }
    else if(x>=width){
      x -= width;
      return x;
    }
    return x;
  }
  int mod_height(int y){
    if(y<0){
      y += height;
      return y;
    }
    else if(y>=height){
      y -= height;
      return y;
    }
    return y;
  }

}
