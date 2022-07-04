import java.text.SimpleDateFormat;
import java.util.*;

Flock flock;
ArrayList<PVector> colors;

/*
Paramètres globaux
*/

int NMIN = 2;
int FRAMERATE = 80;
int NBOIDS = 40;

int STARTPOS = 2;
int DISTNEIGHBOR = 50;
float BOIDRADIUS = 4.0;
float OBSTACLERADIUS = 20.0;

int newObsForce1 = 4;
int newObsForce2 = 8;

int DISTINTERACT = 50;
int MAILLAGE = 10;
String DEL = ";";
String SEP = "\n";
boolean pause, show;
int scale;
int frame;

void setup() {
  size(1080, 720);
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
  
  this.flock = new Flock();
  background(0);
  frameRate(FRAMERATE);
  this.show = false;
  this.pause = false;
  this.scale = 0;
  this.frame = 0;
    
  // Add an initial set of boids into the system
  float directionX;
  float directionY;
  switch(STARTPOS){
    case 0:
      for (int i = 0; i < NBOIDS/2; i++) {
        flock.addBoid(random(width), random(height));
        //flock.addBoid(new Boid(width/2, height/2));
      }
      break;
      
    case 1:
       directionX = 1;
       directionY = -1;
       for (int i = 0; i < NBOIDS/2; i++) {
         flock.addBoid(width/4, 3*height/4, directionX, directionY);
       }
       directionX = -1;
       directionY = -1;
      for(int i=NBOIDS/2; i< NBOIDS; i++){
         flock.addBoid(3*width/4, 3*height/4, directionX, directionY);
       }
       break;
     
     case 2:
       directionX = random(-1,1);
       directionY = random(-1,1);
       for (int i = 0; i < NBOIDS/4; i++) {
         flock.addBoid(width/4, height/4, directionX, directionY);
       }
       directionX = random(-1,1);
       directionY = random(-1,1);
       for(int i=NBOIDS/4; i< NBOIDS/2; i++){
         flock.addBoid(3*width/4, 3*height/4, directionX, directionY);
       }
       directionX = random(-1,1);
       directionY = random(-1,1);
       for (int i = NBOIDS/2; i < 3*NBOIDS/4; i++) {
         flock.addBoid(width/4, 3*height/4, directionX, directionY);
       }
       directionX = random(-1,1);
       directionY = random(-1,1);
       for(int i=3*NBOIDS/4; i< NBOIDS; i++){
         flock.addBoid(3*width/4, height/4, directionX, directionY);
       }
       break;
         
  }
}

void draw() {
  if (!this.pause){
    this.frame ++;
    background(0);
    this.flock.run(this.scale);
  }
}

void keyPressed(){
  if(key == 'o'){
    this.flock.addObstacle(mouseX, mouseY, newObsForce1);
  }
  if(key == 'O'){
    this.flock.addObstacle(mouseX, mouseY, newObsForce2);
  }
  if (key == 'r'){
    setup();
  }
  if(key == 't'){
    this.show = !this.show;
  }
  if (key == ' '){
    this.pause = !this.pause;
  }
  if(key == 's' && this.pause){
    this.saveToCSV();
  }
  if(key == '0'){
    this.scale = 0;
  }
  if(key == '1'){
    this.scale = 1;
  }
  
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(mouseX,mouseY);
}

void saveToCSV(){
  Map<Integer, ArrayList<PVector>> traj = flock.trajectoriesAll;
  SimpleDateFormat formatter = new SimpleDateFormat("dd_MM_yyyy-HH.mm.ss");  
  Date date = new Date();  
  print(formatter.format(date));
  try {
    String path = "../Trajectories/traj-" + formatter.format(date) + ".csv";
    PrintWriter file = createWriter(path);
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
