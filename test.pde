/**
 * Bounce. 
 * 
 * When the shape hits the edge of the window, it reverses its direction. 
 */
 
int rad = 30;        // Width of the shape
int numberOfBalls = 30;


float [] coordinates;
float [] speed;
int [] direction;
int [] colour;

void setup() 
{
  size(1000, 1000);
  noStroke();
  frameRate(20);
  ellipseMode(RADIUS);
  
  
  print(width);
  print(height);
  
  // Set the starting position of the shape
  coordinates = new float [2*numberOfBalls];
  speed = new float [2*numberOfBalls];
  direction = new int [2*numberOfBalls];
  colour = new int [numberOfBalls];
  for (int i =0; i < numberOfBalls; i++) {
    coordinates[2*i] = int(random(width));
    coordinates[2*i+1] = int(random(height));
    speed[2*i] = random(-2,2);
    speed[2*i+1]=random(-3,3);
    direction[2*i]=1;
    direction[2*i+1]=1;
    colour[i]=int(random(256));
  }
}

void draw() 
{
  background(180);
  
  // Update the position of the shape
  
  for (int i =0; i < numberOfBalls; i++) {
    coordinates[2*i] = coordinates[2*i] + speed[2*i]*direction[2*i];
    coordinates[2*i+1] = coordinates[2*i+1]+speed[2*i+1]*direction[2*i+1];
  }
  
  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1

   for (int i =0; i < numberOfBalls; i++) {
    if (coordinates[2*i] > width-rad || coordinates[2*i] < rad) {
        direction[2*i] = (coordinates[2*i] > width-rad)? -1: 1;
        colour[i]= int(random(256));
    }
    if (coordinates[2*i+1] > height-rad || coordinates[2*i+1] < rad) {
        direction[2*i+1] = (coordinates[2*i+1] > height-rad)? -1 : 1;
        colour[i]= int(random(256));
    }
  } 
  // Draw the shape
  for (int i =0; i < numberOfBalls; i++) {
     fill(colour[i],0,0);
     ellipse(coordinates[2*i], coordinates[2*i+1], rad, rad);
     
  }
}