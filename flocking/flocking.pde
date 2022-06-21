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
ArrayList<PVector> colors;

void setup() {
  size(1080, 1080);
  colors = new ArrayList<PVector>();
  colors.add(new PVector(200, 200, 200));
  colors.add(new PVector(255, 0, 0));
  colors.add(new PVector(0, 255, 0));
  colors.add(new PVector(0, 0, 255));
  colors.add(new PVector(255, 255, 0));
  colors.add(new PVector(255, 0, 255));
  colors.add(new PVector(0, 255, 0));
  colors.add(new PVector(255, 130, 0));
  colors.add(new PVector(0, 255, 130));
  colors.add(new PVector(130, 0, 255));
  colors.add(new PVector(255, 0, 130));
  colors.add(new PVector(130, 255, 0));
  colors.add(new PVector(0, 130, 255));

  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
}

void draw() {
  background(0);
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}
