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
int pause = 0;
ArrayList<PVector> colors;
int nMin = 2;
int nBoids = 150;
int disNeighbor = 30;
int disInteract = 35;
int maillage = 1; //maillage*maillage pixels par case du tableau map
//maillage = 2 permet de coloriser les groupes isolés
int nbColors = 12;
int tour =0;


void setup() {
  size(1500, 900);
  colors = new ArrayList<PVector>();
  /*  
  for (int i =0; i < nbColors ; i++){
    int r = int(random(7));
    int g = int(random(7));
    g = g+int(random(6))*int(g==r);
    g=g%7;
    int b = int(random(7));
    b=b+int(random(6))*int(b==g);
    b=b%7;
    colors.add(new PVector(80+25*r,80+25*g,80+25*b));
  }
  */
  colors.add(new PVector(255, 0, 0));
  colors.add(new PVector(0, 255, 0));
  colors.add(new PVector(0, 0, 255));
  colors.add(new PVector(255, 255, 0));
  colors.add(new PVector(255, 0, 255));
  colors.add(new PVector(0, 255, 255));
  colors.add(new PVector(255, 130, 0));
  colors.add(new PVector(0, 255, 130));
  colors.add(new PVector(130, 0, 255));
  colors.add(new PVector(255, 0, 130));
  colors.add(new PVector(130, 255, 0));
  colors.add(new PVector(0, 130, 255));
  colors.add(new PVector(0, 130, 0));
  colors.add(new PVector(130, 0, 0));
  colors.add(new PVector(0, 0, 130));

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
  for (int i = 0; i < nBoids/2; i++) {
    flock.addBoid(new Boid(width/4, 3*height/4, 0));
    //flock.addBoid(new Boid(width/2, height/2));
  }
  for(int i=nBoids/2; i< nBoids; i++){
        flock.addBoid(new Boid(3*width/4, 3*height/4, 1));
  }
  flock.initGroups();
  frameRate(60);
}

void draw() {
  if (pause==0){
    tour ++;
    background(20);
    flock.run();
  }
}

// Add a new boid into the System
/*
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}*/
void mousePressed() {
  pause = 1-pause;
}
