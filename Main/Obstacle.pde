class Obstacle{
  PVector position;
  int forceAmp;
  ArrayList<Boid> neighbors;
  Flock flock;
  int minDist = 50;
  
  Obstacle(Flock flock, int x, int y, int forceAmp){
    this.position = new PVector(x,y);
    this.forceAmp = forceAmp;
    this.neighbors = new ArrayList<Boid>();
    this.flock = flock ;
  }
  
  void run(){
    this.neighbors = searchNeighbours(flock.map, forceAmp * 10);
    for(Boid b : neighbors){
      PVector force = new PVector(b.position.x - this.position.x, b.position.y - this.position.y);
      b.applyForce(force.mult(forceAmp));
    }
    render();
  }
  
  void render(){
    pushMatrix();
    fill(255);
    ellipse(position.x, position.y, 30,30);
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
