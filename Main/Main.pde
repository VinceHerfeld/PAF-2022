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
ArrayList<PVector> colors;
int nMin = 2;
int nBoids = 750;
int disNeighbor = 30;
int disInteract = 35;
int maillage = 1; //maillage*maillage pixels par case du tableau map
//maillage = 2 permet de coloriser les groupes isolés
int nbColors = 12;

void setup() {
  size(1500, 900);
  colors = new ArrayList<PVector>();
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

  /*
  colors.add(new PVector(77, 122, 107));
  colors.add(new PVector(157, 169, 19));
  
  colors.add(new PVector(54, 169, 239));
  colors.add(new PVector(57, 247, 93));
  colors.add(new PVector(217, 216, 211));
  colors.add(new PVector(77, 122, 107));
  colors.add(new PVector(157, 169, 19));
  */
  flock = new Flock();
  background(0);
    
  // Add an initial set of boids into the system
  for (int i = 0; i < nBoids; i++) {
    flock.addBoid(new Boid(random(width), random(height)));
    //flock.addBoid(new Boid(width/2, height/2));
  }
  flock.initGroups();
  pause=0;
  frameRate(200);
}

void draw() {
  if (pause==0){
    background(20);
  }
  flock.run(pause);
}

// Add a new boid into the System
/*
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}*/
void mousePressed() {
  pause = 1-pause;
}

