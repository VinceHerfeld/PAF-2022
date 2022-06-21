// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  int groupdist = 40;
  ArrayList<ArrayList<Boid>> groups;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    groups = new ArrayList<ArrayList<Boid>>();
    groups.add(new ArrayList<Boid>()); 
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
    setGroups();
    groupChange();
    print(groups);
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
          if(g == 0){
            g = b2.getGroup();
            if(g == 0){
              g = groups.size();
              groups.get(0).remove(b1);
              groups.get(0).remove(b2);
              b1.setGroup(g);
              b2.setGroup(g);
              groups.add(new ArrayList<Boid>());
              groups.get(g).add(b2);
              groups.get(g).add(b1);
            }
            else{
              groups.get(g).add(b1);
              groups.get(b1.getGroup()).remove(b1);
              b1.setGroup(g);
            }
          }
          else{
            groups.get(b2.getGroup()).remove(b2);
            b2.setGroup(g);
            groups.get(g).add(b2);
          }     
        }
       }
     } 
  }
  
  void groupChange(){
    boolean quits;
    for (ArrayList<Boid> group : groups){
      for (Boid b1 : group){
        quits = true;
        for (Boid b2 : group){
          float d = PVector.dist(b1.position, b2.position);
          if (d <= groupdist){
            quits = false;
            break;
          }
        }
        if(quits){
          group.remove(b1);
          b1.setGroup(0);
        }
      }
    }
  }
  

}
