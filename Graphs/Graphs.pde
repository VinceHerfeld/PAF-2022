import java.util.*;

String[] table;
ArrayList<ArrayList<String>> cols;
Map<Integer, ArrayList<PVector>> trajectories; 
Set<Integer> groups; 
ArrayList<PVector> colors;
int nbColors = 12;

int startFrame =150;
int endFrame = 200;
String path = "../Trajectories/traj-01_07_2022-11.42.28.csv";



void setup(){
  size(1500,900);
  trajectories = new HashMap();
  try{
    table = loadStrings(path);
    for(int i = 0; i < table.length; i++){
      ArrayList<String> c = new ArrayList(Arrays.asList(table[i].split(";")));
      if(!c.get(0).equals("") & !c.get(0).equals(" ") & c.get(0) != null){
        int group = Integer.parseInt(c.get(0));
        trajectories.put(group, new ArrayList<PVector>());
        ArrayList<String> c2 = new ArrayList(Arrays.asList(table[i+1].split(";")));
        for(int j = 1; j < c.size(); j++){
          trajectories.get(group).add(new PVector(Float.valueOf(c.get(j).replace(",", ".")).floatValue(), height - Float.valueOf(c2.get(j).replace(",", ".")).floatValue()));
        }
      }
    }
  }
  catch(Exception e){
    exit();
  }
  
  trajectories.remove(0);
  groups = trajectories.keySet();
  colors = new ArrayList<PVector>();
  
  colors.add(new PVector(255, 0, 0));
  colors.add(new PVector(0, 255, 0));
  colors.add(new PVector(0, 0, 255));
  colors.add(new PVector(255, 255, 0));
  colors.add(new PVector(255, 0, 255));
  colors.add(new PVector(0, 255, 255));
  colors.add(new PVector(255, 130, 0));
  colors.add(new PVector(0, 255, 130));
  colors.add(new PVector(130, 0, 255));
  colors.add(new PVector(255, 0, 130));
  colors.add(new PVector(130, 255, 0));
  colors.add(new PVector(0, 130, 255));
  colors.add(new PVector(0, 130, 0));
  colors.add(new PVector(130, 0, 0));
  colors.add(new PVector(0, 0, 130));
}

void draw(){
  background(0);
  for(Integer g: groups){
    for(int i = startFrame; i < endFrame & i < trajectories.get(g).size(); i++){
      
      PVector b = trajectories.get(g).get(i);
      int value = (g +nbColors-1) % nbColors;
      fill(colors.get(value).x, colors.get(value).y, colors.get(value).z, 150);
      noStroke();
      ellipse(b.x, b.y, 4, 4);
    }
  }
}
