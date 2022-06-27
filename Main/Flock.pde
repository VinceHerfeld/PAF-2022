import java.util.*;
import java.util.Arrays;

// The Flock (a list of Boid objects)
import java.util.Map;

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<Obstacle> obstacles;
  Map<Integer, ArrayList<PVector>> trajectories; 
  HashSet<Integer> groups;
  Boid[][] map;
  ArrayList<ArrayList<Boid>> oldGroups, newGroups;
  Map<Integer, PVector> groupVectors;
  
  int[][] linkedGroups;
  int nGroups;
  int[] oldBijectGroups, newBijectGroups;

  Flock() {
    this.boids = new ArrayList<Boid>(); // Initialize the ArrayList
    this.map = new Boid[int(width/maillage)+1][int(height/maillage)+1];
    this.obstacles = new ArrayList<Obstacle>();
    this.groups = new HashSet<>();
    this.trajectories = new HashMap<Integer, ArrayList<PVector>>();
    this.groupVectors = new HashMap<Integer, PVector>();
  }
  void updateMap(){
    for (int i=0; i<int(width/maillage)+1;i++){
      Arrays.fill(map[i],null);
    }
    for(Boid b : boids){
      int x = (int)b.getX();
      int y = (int)b.getY();
      map[int(mod_width(x)/maillage)][int(mod_height(y)/maillage)] = b;
    }
    /*
    for(Obstacle o : obstacles){
      int x = (int)o.getX();
      int y = (int)o.getY();
      map[int(mod_width(x)/maillage)][int(mod_height(y)/maillage)] = o;
    }*/ 
  }
  void run() {
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
    for (Obstacle o : obstacles){
      o.run();
    }
    for (Boid b : boids) {
      b.run(this.map);  // Passing the entire list of boids to each boid individually
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

    for(int group = 1 ; group < newGroups.size() ; group++){
      int gr = newBijectGroups[group];

      findCenter(gr, newGroups.get(group));
      groupVectors = new HashMap<Integer, PVector>();
      findGroupVect(gr, newGroups.get(group));
      if(show){
        for (PVector p : trajectories.get(gr)){
           renderCenter(p, gr);
        }
        if(groupVectors.get(gr) != null){
          PVector b = trajectories.get(gr).get(trajectories.get(gr).size() - 1);
          drawVect((int) b.x, (int) b.y, 100, groupVectors.get(gr).heading());
        }
      }
    }
  }

  void addBoid(Boid b) {
    this.boids.add(b);
  }
  
  void addObstacle(Obstacle o) {
    this.obstacles.add(o);
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
  void findCenter(int group, ArrayList<Boid> newGroup){
    PVector barycentre = new PVector();
    PVector barycentre2;
    int num = 0;
    float cos_sumx =0.;
    float sin_sumx =0.;
    float cos_sumy =0.;
    float sin_sumy =0.;
    for (Boid b : newGroup){
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
      barycentre2 = new PVector(barycenterx, barycentery, newGroup.size());
      //trajectories.get(group).add(barycentre.div(num));
      trajectories.get(group).add(barycentre2);
      return;
    }
    else {
      //print("No boids in group : " + group + "\n");
      return;
    }
  }
  
  void renderCenter(PVector b, int gr){
    if(b != null){
      pushMatrix();
      /*
      if (gr==-1) {
        fill(200, 200, 200, 150);
      }
      */
      int value = (gr +nbColors-1) % nbColors;
      fill(colors.get(value).x, colors.get(value).y, colors.get(value).z, 150);
      ellipse(b.x, b.y, 1+ 2*log(b.z), 1+ 2*log(b.z));
      popMatrix();
    }
    
  }
  
  void checkGroups(){
    for(int group : newBijectGroups){
      //print(group+" ");
      if(!trajectories.containsKey(group)){
        trajectories.put(group, new ArrayList<PVector>());
      }
    }
    if(tour < 30 & erase){
      int present = 0;
      ArrayList<Integer> contains = new ArrayList<Integer>();
      for(int group : trajectories.keySet()){
        present = 0;
        //print(group, " : ");
        for (int g : newBijectGroups) {
          if (g == group) {
            present = 1;
            break;
          }
        }
        if (present==0) {
            contains.add(group);
        }
      }
      for(int g : contains){
        trajectories.remove(g);
      }
      //print(tour);
    }
  }
  
  void findGroupVect(int group, ArrayList<Boid> newGroup){
    ArrayList<PVector> traj = trajectories.get(group);
    int size = traj.size();
    PVector vect = null;
    groupVectors.put(group, vect);
    if (size > 10){
      PVector b2 = trajectories.get(group).get(size - 1);
      PVector b1 = trajectories.get(group).get(size - 11);
      vect = PVector.sub(b2, b1);
      vect.mult(newGroup.size()); 
    }
    groupVectors.replace(group, vect);
  }
  
  void drawVect(int bx, int by, int len, float angle){
    pushMatrix();
    stroke(255);
    translate(bx, by);
    rotate(angle);
    line(0,0,len, 0);
    line(len, 0, len - 8, -8);
    line(len, 0, len - 8, 8);
    noStroke();
    popMatrix();
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
