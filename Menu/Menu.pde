final int MENUSCREEN = 0;
final int GAMESCREEN = 1;
int screenState;
int nMin = 3;
// setup() and other global variables

void setup(){
  size(800, 800);
  screenState = 0;
}
  

  
void draw() {
  if (screenState == MENUSCREEN) {
    drawMenu();
  } else if (screenState == GAMESCREEN) {
    drawGame();
  } else {
    println("Something went wrong!");
  }
}

void drawGame() {
  background(0);
  
  // Pew, pew, I'm a game!
}

void drawMenu() {
  background(255);
  fill(255,0,0);
  rect(20,20, 600, 50);
  textSize(30);
  fill(0,255,0);
  text("Select the minimum for heart selection", 20, 45);
  textSize(50);
  for(int i = 0; i<5; i++){
    fill(255,0,0);
    rect(i*(width/5), 100, 100, 100);
    fill(0,255,0);
    String a = "" + i;
    text(a,i*(width/5),150);
  }



  
  // Don't forget to save :D
}

void mouseClicked() {
  if(screenState == 1){
    return;
  }
  for(int i = 0; i<5; i++){
    if(mouseX>=i*(width/5) && mouseX <=i*(width/5) + 100 && mouseY>=100 && mouseY<=200){
      nMin = i;
      print(nMin);
      return;
    }
  }
  screenState = 1;
}
