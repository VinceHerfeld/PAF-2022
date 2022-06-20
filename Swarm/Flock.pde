// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  int groupdist = 40;
  ArrayList<ArrayList<Boid>> groups;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    groups = new ArrayList<ArrayList<Boid>>();
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
    setGroups();
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
  
  void addGroup() {
    ArrayList<Boid> g = new ArrayList<Boid>();
    groups.add(g);
  }
  
  void addToGroup(int group, Boid b){
    groups.get(group).add(b);
  }
  
  void setGroups(){
    for (Boid b1 : boids){
      for (Boid b2 : boids){
        float d = PVector.dist(b1.position, b2.position);
        if (d < groupdist){
          int g = b1.getGroup();
          b2.setGroup(g);
          groups.get(g).add(b2);
        }
      }
   } 
  }
  

}
