// The Flock (a list of Boid objects)
import java.util.Map;

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<ArrayList<Boid>> oldGroups, newGroups;
  int[][] linkedGroups;
  int nGroups;
  int[] oldBijectGroups, newBijectGroups;

  Flock() {
    this.boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
    this.oldBijectGroups = this.newBijectGroups.clone();
    int g = 1;
    for (Boid b : boids) {
      if (b.neighbors.size() >= nMin && b.newGroup == 0) {
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

}
