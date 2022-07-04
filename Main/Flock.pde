// The Flock (a list of Boid objects)
import java.util.Map;
import java.util.Arrays;

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<Obstacle> obstacles;
  ArrayList<Boid>[][] map;
  int nGroups;
  int nObjects;
  HashMap<Integer, ArrayList<PVector>> trajectoriesAll, trajectoriesCore; 
  ArrayList<Group> groups;

  Flock() {
    this.boids = new ArrayList<Boid>();
    this.obstacles = new ArrayList<Obstacle>();
    this.map = new ArrayList[int(width/MAILLAGE)+1][int(height/MAILLAGE)+1];
    for(int i = 0; i < int(width/MAILLAGE)+1; i++){
      for (int j = 0; j < int(height/MAILLAGE)+1; j++){// Tu crées en boucle des ArrayList<Noeud>
        this.map[i][j] = new ArrayList<Boid>();
      }
    }
    this.nGroups = 1;
    this.nObjects = 0;
    this.groups = new ArrayList<Group>();
    this.groups.add(new Group());
    this.trajectoriesAll= new HashMap<Integer, ArrayList<PVector>>();
    this.trajectoriesCore= new HashMap<Integer, ArrayList<PVector>>();
  }
  
  void updateMap(){
    for(int i = 0; i < int(width/MAILLAGE)+1; i++){
      for (int j = 0; j < int(height/MAILLAGE)+1; j++){// Tu crées en boucle des ArrayList<Noeud>
        this.map[i][j] = new ArrayList<Boid>();
      }
    }
    for(Boid b : boids){
      int x = (int)b.getX();
      int y = (int)b.getY();
      map[int(this.mod_width(x)/MAILLAGE)][int(this.mod_height(y)/MAILLAGE)].add(b);
    }
  }

  void run(int scale) {
    
    updateMap();
    for (Obstacle o : obstacles){
      o.run(map);
    }

    for (Boid b : boids) {
      b.run(map);  // Passing the entire list of boids to each boid individually
    }
    for (Boid b : boids) {
      this.nGroups = b.createGroup(this.nGroups, this.trajectoriesAll, this.trajectoriesCore, this.groups, scale);
    }
    for (Boid b : boids) {
      b.render(scale); 
    }
  }

  void addBoid(float x, float y) {
    Boid b = new Boid(x, y, nObjects);
    this.boids.add(b);
    this.map[(int) (x/MAILLAGE)][(int) (y/MAILLAGE)].add(b);
    nObjects++;
  }
  
  void addBoid(float x, float y, float directionX, float directionY){
    float angle = random(TWO_PI/12);
    PVector acceleration = new PVector(directionX+angle,directionY+angle);
    PVector velocity = new PVector(directionX+angle,directionY+angle);
    Boid b = new Boid(x, y, nObjects, acceleration, velocity);
    this.boids.add(b);
    this.map[(int) (x/MAILLAGE)][(int) (y/MAILLAGE)].add(b);
    nObjects++;
  }
    
  
  void addObstacle(float x, float y, int forceAmp) {
    this.obstacles.add(new Obstacle(x, y, forceAmp, nObjects));
    nObjects++;
  }
  
  int mod_width(int x){
    if(x<0){
      x += width;
      return x;
    }
    else if(x>=width){
      x -= width;
      return x;
    }
    return x;
  }
  int mod_height(int y){
    if(y<0){
      y += height;
      return y;
    }
    else if(y>=height){
      y -= height;
      return y;
    }
    return y;
  }


}
