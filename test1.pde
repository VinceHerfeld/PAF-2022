
PShape[] list_triangle = new PShape[10];


void setup() {
  size(640,360);
  background(255);
  frameRate(100);
  
  for(int i = 0; i < list_triangle.length; i++){
    list_triangle[i] = createShape(TRIANGLE, 0, 10*i, 10, 10*i + 5,0,10*i + 10);
  }
  
}

void draw() {
  background(100,100,200);
  pushMatrix();
  for(int i = 0; i< list_triangle.length; i++){
    list_triangle[i].setFill(color(255, i*25, i*25));
    shape(list_triangle[i]);
  }
  popMatrix();
  
  for(int i = 0; i< list_triangle.length; i++){
    list_triangle[i].translate(1,1);
  }
  
  
}
  
