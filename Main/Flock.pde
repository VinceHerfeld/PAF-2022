import java.util.*;

// The Flock (a list of Boid objects)


class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  HashSet<Integer> groups; 

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    groups = new HashSet<>();
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
        b.run(flock, boids);
      }
    }
    println("groups 1");
    for (Integer i : groups) {
      print(i+" ");
    }
  }

  void addBoid(Boid b) {
    b.index = boids.size();
    boids.add(b);
  }

}
