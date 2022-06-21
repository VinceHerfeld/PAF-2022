
class Flock {
  Boid[][] map;
  ArrayList<Boid> boids; // An ArrayList for all the boids


  Flock() {
    map = new Boid[width+1][height+1];
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }
  
  void updateMap(){
    for(int i=0; i<boids.size(); i++){
      Boid b = boids.get(i);
      int x = (int)b.getX();
      int y = (int)b.getY();
      if(x<0){
        x += width;
      }
      if(x>width){
        x -= width;
      }
      if(y>height){
        y-=height;
      }
      if(y<0){
        y+=height;
      }
      map[x][y] = b;
    }
  }

  void run(int pause) {
    for (Boid b : boids){
      b.searchNeighboor(this.map);
    }
    for (Boid b : boids) {
      b.grouping = b.index;
    }
    for (Boid b : boids) {
      b.grouping(boids);
    }
    for (Boid b : boids) {
      if (pause ==0) {
        b.run(boids);
      }
        // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
  
  
  
  int mod_width(int x){
    if(x<0){
      x += width;
      return x;
    }
    else if(x>width){
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
    else if(y>height){
      y -= height;
      return y;
    }
    return y;
  }
}
