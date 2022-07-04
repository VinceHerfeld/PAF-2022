// The Boid class

class Boid extends Object{


  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  Group oldGroup, newGroup;
  boolean activeCreate, activeTell;

  Boid(float x, float y, int id, PVector acc, PVector vel) {
    super(x,y, BOIDRADIUS, id, "boid",acc, vel );
    
    maxspeed = 2;
    maxforce = 0.03;
    
    this.oldGroup = new Group();
    this.newGroup = new Group();
  }

  Boid(float x, float y, int id) {
    super(x, y, BOIDRADIUS, id, "boid");

    float angle = random(TWO_PI);
    this.velocity = new PVector(cos(angle), sin(angle));
    maxspeed = 2;
    maxforce = 0.03;
    
    this.oldGroup = new Group();
    this.newGroup = new Group();
    }

  void run(ArrayList<Boid>[][] map) {
    this.activeCreate = false;
    this.activeTell = false;
    this.oldGroup = newGroup;
    this.newGroup = new Group();
    this.neighbors = this.searchNeighbors(map, DISTNEIGHBOR);
    flock(map);
    update();
    borders();
  }
  
  float getX(){
    return position.x;
  }
  
  float getY(){
    return position.y;
  }
  
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid>[][] map) {
    PVector sep = separate(map);   // Separation
    PVector ali = align(map);      // Alignment
    PVector coh = cohesion(map);   // Cohesion
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

  void render(int scale) {
    if (this.neighbors.size() < NMIN && scale > 0){
      return;
    }
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    if (this.newGroup.id == 0){
      fill(200, 200, 200);
    }else{
      fill(colors.get(this.newGroup.id % 12).x, colors.get(this.newGroup.id % 12).y, colors.get(this.newGroup.id % 12).z);
    }
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    noStroke();
    //rect(0, 0, 10, 10);
    beginShape(TRIANGLES);
    vertex(0, -this.radius*2);
    vertex(-this.radius, this.radius*2);
    vertex(this.radius, this.radius*2);
    endShape();
    fill(255, 10);
    //circle(0,0,50);
    popMatrix();

  }

  // Wraparound
  void borders() {
    if (position.x < -this.radius) position.x = width+this.radius;
    if (position.y < -this.radius) position.y = height+this.radius;
    if (position.x > width+this.radius) position.x = -this.radius;
    if (position.y > height+this.radius) position.y = -this.radius;
  }

  // Separation
  // Method checks for nearby boids and steers away

  PVector separate (ArrayList<Boid>[][] map) {
    int desiredseparation = int(DISTINTERACT * 0.5);
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : this.searchNeighbors(map, desiredseparation)) {
      // Calculate vector pointing away from neighbor
      PVector diff = PVector.sub(position, other.position);
      diff.normalize();
      diff.div((this.distance(other)+0.5));        // Weight by distance
      steer.add(diff);
      count++;            // Keep track of how many
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

  PVector align (ArrayList<Boid>[][] map) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : this.searchNeighbors(map, DISTINTERACT)) {
      sum.add(other.velocity);
      count++;
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

  PVector cohesion (ArrayList<Boid>[][] map) {
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : this.searchNeighbors(map, DISTINTERACT)) {
      sum.add(other.position); // Add position
      count++;
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
  int createGroup(int gMin, HashMap<Integer, ArrayList<PVector>> trajectoriesAll,  HashMap<Integer, ArrayList<PVector>> trajectoriesCore, ArrayList<Group> groups, int scale){
    if (this.neighbors.size() >= NMIN && !this.activeCreate){
      Group g = this.propagateGroup(this);
      int n = g.defineId(gMin);
      if (n > gMin){
        groups.add(g);
      }
      g.addTrajectories(trajectoriesAll, trajectoriesCore);
      groups.set(g.id, g);
      if(show){
        g.renderCenter(scale);
        g.renderVector(scale);
      }
      this.tellOthers(g, this);
      return n;
    } else {
      return gMin;
    }
  }
  
  Group propagateGroup(Boid father){
    Group g = new Group();
    if (this.activeCreate == false){
      this.activeCreate = true;
      if (this.neighbors.size() >= NMIN){
        for (Boid neighbor : this.neighbors){
          g.merge(neighbor.propagateGroup(this));
        }
        g.addBoid(this);
      } else {
        for (Boid neighbor : this.neighbors){
          if (this.distance(neighbor) < this.distance(father)){
            this.activeCreate = false;
            return g;
          }
        }
        g.addBoid(this);
      }
    }
    return g;
  }
  
  void tellOthers(Group g, Boid father){
    if (this.activeTell == false){
      this.activeTell = true;
      if (this.neighbors.size() >= NMIN){
        for (Boid neighbor : this.neighbors){
          neighbor.tellOthers(g, this);
        }
        this.newGroup = g;
      } else {
        for (Boid neighbor : this.neighbors){
          if (this.distance(neighbor) < this.distance(father)){
            this.activeTell = false;
          }
        }
        if (this.activeTell){
          this.newGroup = g;
        }
      }
    }
  }
   
  
}
