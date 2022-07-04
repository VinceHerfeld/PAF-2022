class Object{
  PVector position, velocity, acceleration;
  ArrayList<Boid> neighbors;
  float radius;
  //int eyeSight;
  int id;
  String type;
  
  Object (float x, float y, float radius, int id , String type){
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.radius = radius;
    //this.eyeSight = eyeSight;
    this.neighbors = new ArrayList<Boid>();
    this.id = id;
    this.type = type;
  }
  
    Object (float x, float y, float radius, int id , String type, PVector newAcceleration, PVector newVelocity){
    this.position = new PVector(x, y);
    this.velocity = newVelocity;
    this.acceleration = newAcceleration;
    this.radius = radius;
    this.neighbors = new ArrayList<Boid>();
    this.id = id;
    this.type = type;
  }
  
  
  boolean equals(Object other){
    return this.id == other.id;
  }
   
  float distance(Object other){
    PVector vect = new PVector(min(abs(this.position.x - other.position.x), width - abs(this.position.x - other.position.x)), min(abs(this.position.y - other.position.y), height - abs(this.position.y - other.position.y)));
    return vect.mag();
  }
  
  ArrayList<Boid> searchNeighbors(ArrayList<Boid>[][] map, int eyeSight){
    ArrayList<Boid> listNeighbors = new ArrayList<Boid>();
    for(int i = -eyeSight; i<eyeSight; i++){
      for(int j = -eyeSight; j<eyeSight; j++){
        int X = flock.mod_width((int) (this.position.x+i));
        int Y = flock.mod_height((int) (this.position.y+j));
        for (Boid neighbor : map[int(X/MAILLAGE)][int(Y/MAILLAGE)]){
          if (this.type.equals("obstacle") || !this.equals(neighbor)){
            if (this.distance(neighbor) < eyeSight) listNeighbors.add(neighbor);
          }
        }
      }
    }
    return listNeighbors;
  }  
}
