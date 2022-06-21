/**
 * Flocking 
 * by Daniel Shiffman.  
 * 
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on 
 * rules of avoidance, alignment, and coherence.
 * 
 * Click the mouse to add a new boid.
 */

Flock flock;
int pause;

void setup() {
  size(1900, 1000);
  pause=0;
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 300; i++) {
    flock.addBoid(new Boid(random(width), random(height), i));
  }
}

void draw() {
  if (pause==0){
    background(20);
  }
  flock.run(pause);

  
}

// Add a new boid into the System

void mousePressed() {
  pause = 1-pause;
}
