class Group{
  
  ArrayList<Boid> coreBoids, allBoids;
  int id;
  HashMap<Group, Integer> distributionOldGroups;
  PVector sumCosCore, sumSinCore, sumCosAll, sumSinAll;
  int birthTime;
  ArrayList<PVector> centerAllTrajectories, centerCoreTrajectories;
  
  
  Group(){
    this.coreBoids = new ArrayList<Boid>();
    this.allBoids = new ArrayList<Boid>();
    this.id = 0;
    this.distributionOldGroups = new HashMap<Group, Integer>();
    this.sumCosCore = new PVector(0, 0);
    this.sumSinCore = new PVector(0, 0);
    this.sumCosAll = new PVector(0, 0);
    this.sumSinAll = new PVector(0, 0);
    this.birthTime = frame;
    this.centerAllTrajectories = new ArrayList<PVector>();
    this.centerCoreTrajectories = new ArrayList<PVector>();
  }
  
  int defineId(int newId){
    for (Group g : this.distributionOldGroups.keySet()){
      if (this.distributionOldGroups.get(g) > this.allBoids.size() / 2 && this.distributionOldGroups.get(g) > g.allBoids.size() / 2 && g.id > id){
        this.id = g.id;
        this.birthTime = g.birthTime;
        this.centerAllTrajectories = new ArrayList(g.centerAllTrajectories);
        this.centerCoreTrajectories = new ArrayList(g.centerCoreTrajectories);
        return newId;
      }
    }
    this.id = newId;
    return newId + 1;
  }
    
  
  void addBoid(Boid boid){
    this.allBoids.add(boid);
    int n = 1;
    if (this.distributionOldGroups.containsKey(boid.oldGroup)){
      n += this.distributionOldGroups.get(boid.oldGroup);
      this.distributionOldGroups.remove(boid.oldGroup);
    }
    this.distributionOldGroups.put(boid.oldGroup, (Integer) n);
    this.sumCosAll.add(new PVector((float) Math.cos(2*PI*boid.position.x/width), (float) Math.cos(2*PI*boid.position.y/width)));
    this.sumSinAll.add(new PVector((float) Math.cos(2*PI*boid.position.x/width), (float) Math.cos(2*PI*boid.position.y/width)));
    if (boid.neighbors.size() >= NMIN){
      this.coreBoids.add(boid);
      this.sumCosCore.add(new PVector((float) Math.cos(2*PI*boid.position.x/width), (float) Math.cos(2*PI*boid.position.y/width)));
      this.sumSinCore.add(new PVector((float) Math.cos(2*PI*boid.position.x/width), (float) Math.cos(2*PI*boid.position.y/width)));
    }
  }

  boolean equals(Group other){
    return this.id == other.id;
  }
  
  void merge(Group other){
    for (Boid boid : other.allBoids){
      this.addBoid(boid);
    }
  }
  
  PVector centerAll(){
    float cos_sumx =0.;
    float sin_sumx =0.;
    float cos_sumy =0.;
    float sin_sumy =0.;
    for (Boid b : this.allBoids){
      cos_sumx += Math.cos(2*PI*b.position.x/width);
      sin_sumx += Math.sin(2*PI*b.position.x/width);
      cos_sumy += Math.cos(2*PI*b.position.y/height);
      sin_sumy += Math.sin(2*PI*b.position.y/height);
    }
    float barycenterx = (float) (width/2/PI*Math.atan2(sin_sumx, cos_sumx)+width)%width;
    float barycentery = (float) (height/2/PI*Math.atan2(sin_sumy, cos_sumy)+height)%height;
    PVector barycentre = new PVector(barycenterx, barycentery);
    //trajectories.get(group).add(barycentre.div(num));
    return barycentre;
        
    //return new PVector((float) (width/2/PI*Math.atan2(this.sumSinAll.x, this.sumCosAll.x)+width)%width, (float) (height/2/PI*Math.atan2(this.sumSinAll.y, this.sumCosAll.y)+height)%height);
  }
  
  PVector centerCore(){
    float cos_sumx =0.;
    float sin_sumx =0.;
    float cos_sumy =0.;
    float sin_sumy =0.;
    for (Boid b : this.coreBoids){
      cos_sumx += Math.cos(2*PI*b.position.x/width);
      sin_sumx += Math.sin(2*PI*b.position.x/width);
      cos_sumy += Math.cos(2*PI*b.position.y/height);
      sin_sumy += Math.sin(2*PI*b.position.y/height);
    }
    float barycenterx = (float) (width/2/PI*Math.atan2(sin_sumx, cos_sumx)+width)%width;
    float barycentery = (float) (height/2/PI*Math.atan2(sin_sumy, cos_sumy)+height)%height;
    PVector barycentre = new PVector(barycenterx, barycentery);
    //trajectories.get(group).add(barycentre.div(num));
    return barycentre;
    
    //return new PVector((float) (width/2/PI*Math.atan2(this.sumSinCore.x, this.sumCosCore.x)+width)%width, (float) (height/2/PI*Math.atan2(this.sumSinCore.y, this.sumCosCore.y)+height)%height);
  }
  
  void addTrajectories(HashMap<Integer, ArrayList<PVector>> trajectoriesAll, HashMap<Integer, ArrayList<PVector>> trajectoriesCore){
    this.centerAllTrajectories.add(this.centerAll());
    this.centerCoreTrajectories.add(this.centerCore());
    if (trajectoriesAll.containsKey(this.id)){
      trajectoriesAll.remove(this.id);
      trajectoriesCore.remove(this.id);
    }
    trajectoriesAll.put(this.id, centerAllTrajectories);
    trajectoriesCore.put(this.id, centerCoreTrajectories);
  }
  
  void renderCenter(int scale){
    switch(scale){
      case(1):
        for (PVector p : this.centerCoreTrajectories){
          pushMatrix();
          /*
          if (gr==-1) {
            fill(200, 200, 200, 150);
          }
          */
          fill(colors.get(this.id%12).x, colors.get(this.id%12).y, colors.get(this.id%12).z, 150);
          ellipse(p.x, p.y, 1+ 2*log(this.allBoids.size()), 1+ 2*log(this.allBoids.size()));
          popMatrix();
        }
        break;
      default:
        for (PVector p : this.centerAllTrajectories){
          pushMatrix();
          /*
          if (gr==-1) {
            fill(200, 200, 200, 150);
          }
          */
          fill(colors.get(this.id%12).x, colors.get(this.id%12).y, colors.get(this.id%12).z, 150);
          ellipse(p.x, p.y, 1+ 2*log(this.allBoids.size()), 1+ 2*log(this.allBoids.size()));
          popMatrix();
        }
        break;
    }
  }
  
  PVector findCenterAllVect(){
    PVector vect = new PVector(0,0);
    if (frame - this.birthTime > 10){
      PVector b2 = centerAllTrajectories.get(frame - this.birthTime - 1);
      PVector b1 = centerAllTrajectories.get(frame - this.birthTime - 11);
      vect = PVector.sub(b2, b1);
      vect.mult(allBoids.size()); 
    }
    return vect;
  }
  
  PVector findCenterCoreVect(){
    PVector vect = new PVector(0,0);
    if (frame - this.birthTime > 10){
      PVector b2 = centerCoreTrajectories.get(frame - this.birthTime - 1);
      PVector b1 = centerCoreTrajectories.get(frame - this.birthTime - 11);
      vect = PVector.sub(b2, b1);
      vect.mult(coreBoids.size()); 
    }
    return vect;
  }
  
  void renderVector(int scale){
    switch(scale){
      case(1):
        PVector vectCore = this.findCenterCoreVect();
        PVector centerCore = this.centerCore();
        pushMatrix();
        stroke(255);
        fill(255);
        translate((int) centerCore.x, (int) centerCore.y);
        rotate(vectCore.heading());
        line(0,0,100, 0);
        line(100, 0, 100 - 8, -8);
        line(100, 0, 100 - 8, 8);
        noStroke();
        popMatrix();
        break;
      default:
        PVector vectAll = this.findCenterAllVect();
        PVector centerAll = this.centerAll();
        pushMatrix();
        stroke(255);
        translate((int) centerAll.x, (int) centerAll.y);
        rotate(vectAll.heading());
        line(0,0,100, 0);
        line(100, 0, 100 - 8, -8);
        line(100, 0, 100 - 8, 8);
        noStroke();
        popMatrix();
        break;
    }
       
  }
}
