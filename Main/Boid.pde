// The Boid class


class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  ArrayList<Boid> neighbors;
  int oldGroup, newGroup;
  int red;
  int green;
  int blue;
  int group;
  int index;

  Boid(float x, float y) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    position = new PVector(x, y);
    r = 4.0;
    maxspeed = 2;
    maxforce = 0.03;
    
    this.oldGroup = 0;
    this.newGroup = 0;
    this.neighbors = new ArrayList<Boid>();
    }

  void run(ArrayList<Boid> boids, Boid [][] map) {
    this.oldGroup = newGroup;
    this.newGroup = 0;
    flock(boids);
    searchNeighbours(map);
    update();
    borders();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render(int[] biject) {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    if (this.newGroup == 0){
      fill(200, 200, 200);
    }else{
      fill(colors.get((biject[this.newGroup] - 1) % 12).x, colors.get((biject[this.newGroup] - 1) % 12).y, colors.get((biject[this.newGroup] - 1) % 12).z);
    }
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    noStroke();
    //rect(0, 0, 10, 10);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    fill(255, 10);
    //circle(0,0,50);
    popMatrix();

  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }
  float getX(){
    return position.x;
  }
  
  float getY(){
    return position.y;
  }
  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = disInteract * 0.5;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = this.distance(other);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = disInteract;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = this.distance(other);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
        
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = disInteract;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = this.distance(other);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
  /*
  void coreBoid(ArrayList<Boid> boids){
    float neighbordist = disNeighbor;
    this.neighbors = new ArrayList<Boid>();
    for (Boid other : boids) {
      float d = this.distance(other);
      if ((d > 0) && (d <= neighbordist)) {
        this.neighbors.add(other);
      }
    }
  }
  */

  void propagateGroup(int g){
    this.newGroup = g;
    for (Boid neighbor : this.neighbors){
      if (neighbor.neighbors.size() >= nMin && neighbor.newGroup == 0){
        neighbor.propagateGroup(g);
      }
    }
  }
  
  void joinGroup(){
    Boid nearest = this.neighbors.get(0);
    float dMin = PVector.dist(this.position, nearest.position);
    for (Boid other : this.neighbors){
      float d = this.distance(other);
      if (d < dMin && nearest.neighbors.size() >= nMin) {
        d = dMin;
        nearest = other;
      }
    }
    if (nearest.neighbors.size() >= nMin){
      this.newGroup = nearest.newGroup;
    }
  }
  
  float distance(Boid other){
    PVector vect = new PVector(min(abs(this.position.x - other.position.x), width - abs(this.position.x - other.position.x)), min(abs(this.position.y - other.position.y), height - abs(this.position.y - other.position.y)));
    return vect.mag();
  }
  void searchNeighbours(Boid[][] map){
    this.neighbors.clear();
    int x = (int)position.x;
    int y = (int)position.y;
    for(int i = -50; i<50; i++){
      for(int j=-50; j<50; j++){
        if(i==0 && j==0){
        }
        else{
          
          int X = flock.mod_width(x+i);
          int Y = flock.mod_height(y+j);
          if(map[X][Y]!= null){
            this.neighbors.add(map[X][Y]);
            //print("1neighbour");
          }
        }
      }
    }
  }
  
}
