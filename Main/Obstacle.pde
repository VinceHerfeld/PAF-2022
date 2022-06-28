class Obstacle{
  PVector position;
  int forceAmp;
  ArrayList<Boid> neighbors;
  Flock flock;
  int minDist = 50;
  Map<Integer, PVector> groupVectors;
  
  Obstacle(Flock flock, int x, int y, int forceAmp){
    this.position = new PVector(x,y);
    this.forceAmp = forceAmp;
    this.neighbors = new ArrayList<Boid>();
    this.flock = flock ;
    this.groupVectors = new HashMap<Integer,PVector>();
  }
  
  void run(){
    this.neighbors = searchNeighbours(flock.map, forceAmp * 30);
    for(Boid b : neighbors){
      PVector force = new PVector(b.position.x - this.position.x, b.position.y - this.position.y);
      float d = force.mag();
      force.normalize();
      force.div(2 * d);
      
      if(b.position.x <= this.position.x & b.position.y <= this.position.y){
        force.rotate(-HALF_PI / 3);
      }
      else if (b.position.x > this.position.x & b.position.y <= this.position.y){
        force.rotate(HALF_PI / 3);
      }
      else if (b.position.x > this.position.x & b.position.y > this.position.y){
        force.rotate(-HALF_PI / 3);
      }
      else if (b.position.x <= this.position.x & b.position.y > this.position.y){
        force.rotate(HALF_PI / 3);
      }
      b.applyForce(force.mult(forceAmp));
      
/*       TO BE CONTINUED      
      int group = flock.newBijectGroups[b.newGroup];
      if(flock.groupVectors.get(group) == null){
        this.groupVectors.put(group, new PVector(0,0));
      }
      else if(!b.inObstacle){
        b.inObstacle = true;
        PVector vect = flock.groupVectors.get(group).copy();
        this.groupVectors.put(group, vect);
      }
      print(this.groupVectors);
      print(group + "\n----------------------\n");
      b.applyForce(this.groupVectors.get(group).mult(10));
 */
 
    }
    
    render();
  }
  
  void render(){
    pushMatrix();
    fill(255);
    ellipse(position.x, position.y, 30, 30);
    if(forceAmp <= 3){
      fill(0,200,0);
    }
    else if(forceAmp <= 6){
      fill(0,0,200);
    }
    else{
      fill(200,0,0);
    }
    ellipse(position.x, position.y, 20, 20);
    fill(0);
    ellipse(position.x, position.y, 10, 20);
    popMatrix();
  }
  
  ArrayList<Boid> searchNeighbours(Boid[][] map, int eyeSight){
    ArrayList<Boid> neigh = new ArrayList<Boid>();
    int x = (int)position.x;
    int y = (int)position.y;
    for(int i = -eyeSight; i<eyeSight; i++){
      for(int j=-eyeSight; j<eyeSight; j++){
        if(i==0 && j==0){
          continue;
        }
        else{
          if (i*i+j*j < eyeSight*eyeSight) {
            int X = flock.mod_width(x+i);
            int Y = flock.mod_height(y+j);
            if(map[int(X/maillage)][int(Y/maillage)]!= null){
              neigh.add(map[int(X/maillage)][int(Y/maillage)]);
              //print("1neighbour");
            }
          }
        }
      }
    }
    return neigh;
  }
  
  
  
}
