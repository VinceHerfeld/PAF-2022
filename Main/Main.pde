Flock flock;
int pause = 0;

/*
  Paramètres globaux
*/

int nBoids = 150;
int nObst = 0;
int frame = 30;
int nMin = 2;

int position = 2;

int newObsForce = 5;
int disNeighbor = 30;
int disInteract = 35;
int maillage = 1; //maillage*maillage pixels par case du tableau map
//maillage = 2 permet de coloriser les groupes isolés
int nbColors = 12;
int tour =0;



PGraphics tails;
ArrayList<PVector> colors;
boolean saved = false;
boolean show = false;
String DEL = ";";
String SEP = "\n";
boolean erase = true;


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
  for(int i = 0; i < nObst; i++){
    flock.addObstacle(new Obstacle(flock, (int) random(width), (int)random(height), (int) random(1,10)));
  }
  float directionX;
  float directionY;
  switch(position){
    case 0:
      for (int i = 0; i < nBoids/2; i++) {
        flock.addBoid(new Boid(random(width), random(height)));
        //flock.addBoid(new Boid(width/2, height/2));
      }
      break;
      
    case 1:
       directionX = 1;
       directionY = -1;
       for (int i = 0; i < nBoids/2; i++) {
         flock.addBoid(new Boid(width/4, 3*height/4, directionX, directionY));
       }
       directionX = -1;
       directionY = -1;
      for(int i=nBoids/2; i< nBoids; i++){
         flock.addBoid(new Boid(3*width/4, 3*height/4, directionX, directionY));
       }
       break;
     
     case 2:
       directionX = random(-1,1);
       directionY = random(-1,1);
       for (int i = 0; i < nBoids/4; i++) {
         flock.addBoid(new Boid(width/4, height/4, directionX, directionY));
       }
       directionX = random(-1,1);
       directionY = random(-1,1);
       for(int i=nBoids/4; i< nBoids/2; i++){
         flock.addBoid(new Boid(3*width/4, 3*height/4, directionX, directionY));
       }
       directionX = random(-1,1);
       directionY = random(-1,1);
       for (int i = nBoids/2; i < 3*nBoids/4; i++) {
         flock.addBoid(new Boid(width/4, 3*height/4, directionX, directionY));
       }
       directionX = random(-1,1);
       directionY = random(-1,1);
       for(int i=3*nBoids/4; i< nBoids; i++){
         flock.addBoid(new Boid(3*width/4, height/4, directionX, directionY));
       }
       break;
         
  }

  flock.initGroups();
  frameRate(frame);
}

void draw() {
  if (pause==0){
    saved = false;
    tour = (tour + 1) % 100;
    if (tour == 30){
      erase = false;
    }
    //background(60);
    background(60);
    flock.run();
  }
  else if(!saved){
    saved = true;
    saveToCSV();
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

void keyPressed(){
  if(key == 'p'){
    flock.addObstacle(new Obstacle(flock, mouseX, mouseY, newObsForce));
  }
  if (key == 'r'){
    setup();
  }
  if(key == 't'){
    show = !show;
  }
}

void saveToCSV(){
  Map<Integer, ArrayList<PVector>> traj = flock.trajectories;
  saved = true;
  try {
    PrintWriter file = createWriter("./traj.csv");
    for(int g : traj.keySet()){
      file.print(String.valueOf(g));
      file.print(DEL);
      ArrayList<Float> Y = new ArrayList<Float>();
      for(PVector b : traj.get(g)){
        Y.add(b.y);
        file.print(String.valueOf(b.x).replace(".", ","));
        file.print(DEL);
      }
      file.print(SEP);
      file.print(" ");
      file.print(DEL);
      for(float y : Y){
        file.print(String.valueOf(height - y).replace(".", ","));
        file.print(DEL);
      }
      file.print(SEP);
      file.print(SEP);
    }
    file.close();
  }
  catch(Exception e) {
    print("Couldn't export trajectories\n" + e);
  }
}
