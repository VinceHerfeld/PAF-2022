// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
    for (Boid b : boids) {
      int g = 1;
      if (b.neighbors.size() > 2 && b.newGroup == 0) {
        b.propagateGroup(g);
        g = g + 1;
      }
    }
    for (Boid b : boids) {
      if (b.neighbors.size() > 0 && b.newGroup == 0) {
        b.joinGroup();
      }
    }
    for (Boid b : boids) {
      b.render();
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}
