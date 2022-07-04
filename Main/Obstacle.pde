class Obstacle extends Object{
  int forceAmp;
  
  Obstacle(float x, float y, int forceAmp, int id){
    super(x, y, OBSTACLERADIUS, id, "obstacle");
    this.forceAmp = forceAmp;
    this.neighbors = new ArrayList<Boid>();
  }
  
  void run(ArrayList<Boid>[][] map){
    this.neighbors = this.searchNeighbors(map, forceAmp * 30);
    for(Boid b : neighbors){
      PVector force = new PVector(b.position.x - this.position.x, b.position.y - this.position.y);
      float d = force.mag();
      force.normalize();
      force.div(2 * d * d);
      
      if(b.position.x <= this.position.x & b.position.y <= this.position.y){
        force.rotate(-HALF_PI / 2);
      }
      else if (b.position.x > this.position.x & b.position.y <= this.position.y){
        force.rotate(HALF_PI / 2);
      }
      else if (b.position.x > this.position.x & b.position.y > this.position.y){
        force.rotate(-HALF_PI / 2);
      }
      else if (b.position.x <= this.position.x & b.position.y > this.position.y){
        force.rotate(HALF_PI / 2);
      }
      b.applyForce(force.mult(forceAmp));
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
}
