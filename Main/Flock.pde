// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run(int pause) {
    for (Boid b : boids) {
      b.grouping = b.index;
    }
    for (Boid b : boids) {
      b.grouping(boids);
    }
    for (Boid b : boids) {
      if (pause ==0) {
        b.run(boids);
      }
        // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    b.index = boids.size();
    boids.add(b);
  }

}
