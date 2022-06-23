import java.util.*;

// The Flock (a list of Boid objects)
import java.util.Map;

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  Map<ArrayList<Boid>, ArrayList<PVector>> trajectories; 
  HashSet<Integer> groups;
  Boid[][] map;
  ArrayList<ArrayList<Boid>> oldGroups, newGroups;
  int[][] linkedGroups;
  int nGroups;
  int[] oldBijectGroups, newBijectGroups;

  Flock() {
    this.boids = new ArrayList<Boid>(); // Initialize the ArrayList
    map = new Boid[width][height];
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    groups = new HashSet<>();
    trajectories = new HashMap<ArrayList<Boid>, ArrayList<PVector>>();
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
    if (pause==0) {
      /*
      for (Boid b : boids){
        b.searchNeighbours(this.map);
      }
      for (Boid b : boids) {
        b.group = b.index;
      }
      groups.clear();
      for (Boid b : boids) {
        b.grouping(boids);
      }
      */
      updateMap();
      for (Boid b : boids) {
        b.run(boids, this.map);  // Passing the entire list of boids to each boid individually
      }
      this.oldBijectGroups = this.newBijectGroups.clone();
      int g = 1;
      //print("OK");
      for (Boid b : boids) {
        if (b.neighbors.size() >= nMin && b.newGroup == 0) {
          //print(b.neighbors.size());
          b.propagateGroup(g);
          g = g + 1;
        }
      }
      this.oldGroups = new ArrayList<ArrayList<Boid>>(this.newGroups);
      this.newGroups.clear();
      for (int k = 0; k < g; k++){
        this.newGroups.add(new ArrayList<Boid>());
      }
      
      this.linkedGroups = new int[oldGroups.size()][newGroups.size()];
  
      for (Boid b : boids) {
        if (b.neighbors.size() > 0 && b.newGroup == 0) {
          b.joinGroup();
        }
        this.newGroups.get(b.newGroup).add(b);
        this.linkedGroups[b.oldGroup][b.newGroup]++; 
      }
  
      this.newBijectGroups = new int[this.newGroups.size()];
      for (int n = 1; n < this.newGroups.size(); n++){
        for (int o = 1; o < this.oldGroups.size(); o++){
          if (this.linkedGroups[o][n] > this.oldGroups.get(o).size() / 2 && this.linkedGroups[o][n] > this.newGroups.get(n).size() / 2){
            this.newBijectGroups[n] = this.oldBijectGroups[o];
            break;
          }
        }
        if (this.newBijectGroups[n] == 0){
          this.newBijectGroups[n] = this.nGroups;
          this.nGroups++;
        }
      }
      for (Boid b : boids) {
        b.render(this.newBijectGroups); 

      }
      checkGroups();
      //println(" --" + trajectories.keySet());
      println();
      int firstGroup=1;
      for(ArrayList<Boid> gr : newGroups){
        print("0");
        findCenter(gr);
        /*
        int g_red = boids.get(gr).red;
        int g_green = boids.get(gr).green;
        int g_blue = boids.get(gr).blue;
        */
        if (firstGroup==0) {
          for (PVector p : trajectories.get(gr)){
            renderCenter(p, gr);
          }
        }
        firstGroup =0;
      }
    }
  }

  void addBoid(Boid b) {
    this.boids.add(b);
  }
  
  void initGroups(){
    this.oldGroups = new ArrayList<ArrayList<Boid>>();
    this.oldGroups.add(boids);
    this.newGroups = new ArrayList<ArrayList<Boid>>();
    this.newGroups.add(boids);
    this.nGroups = 1;
    this.oldBijectGroups = new int[1];
    this.newBijectGroups = new int[1];
  }
  void findCenter(ArrayList<Boid> group){
    PVector barycentre = new PVector();
    PVector barycentre2;
    int num = 0;
    float cos_sumx =0.;
    float sin_sumx =0.;
    float cos_sumy =0.;
    float sin_sumy =0.;
    for (Boid b : group){
      cos_sumx += Math.cos(2*PI*b.position.x/width);
      sin_sumx += Math.sin(2*PI*b.position.x/width);
      cos_sumy += Math.cos(2*PI*b.position.y/height);
      sin_sumy += Math.sin(2*PI*b.position.y/height);
      barycentre.add(b.position);
      num++;
    }
    if (num > 0){
      float barycenterx = (float) (width/2/PI*Math.atan2(sin_sumx, cos_sumx)+width)%width;
      float barycentery = (float) (height/2/PI*Math.atan2(sin_sumy, cos_sumy)+height)%height;
      barycentre2 = new PVector(barycenterx, barycentery);
      //trajectories.get(group).add(barycentre.div(num));
      
      trajectories.get(group).add(barycentre2);
    }
    else {
      //print("No boids in group : " + group + "\n");
      return;
    }
  }
  
  void renderCenter(PVector b, ArrayList<Boid> group){
    if(b != null){
      pushMatrix();
      /*
      if (gr==-1) {
        fill(200, 200, 200, 150);
      }
      */
      int value = (this.newBijectGroups[group.get(0).newGroup] +11) % 12;
      fill(colors.get(value).x, colors.get(value).y, colors.get(value).z, 150);
      ellipse(b.x, b.y, 2, 2);
      popMatrix();
    }
    
  }
  
  void checkGroups(){
    for(ArrayList<Boid> group : newGroups){
      if(!trajectories.containsKey(group)){
        trajectories.put(group, new ArrayList<PVector>());
      }
    }
    ArrayList<ArrayList<Boid>> removed = new ArrayList<>();
    for(ArrayList<Boid> group : trajectories.keySet()){
      if(!newGroups.contains(group)){
        removed.add(group);
      }
    }
    for (ArrayList<Boid> i : removed) {
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
