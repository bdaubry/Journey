int cols, rows;
int scale = 28;
int w = 1300;
int h = 660;
float flying = 0;
float speed = 0.025;
float terrainHeight = 55;
float[][] terrain;
color c1, c2;
IntDict colorDict;
ArrayList mountainHeights = new ArrayList();
ArrayList colors = new ArrayList();
int heightMax = -1;
int heightMin = -1;
int ColorToDisplay;

void setup() {
  //size(800, 480, P3D);
  fullScreen(P3D);
  noCursor();
  noFill();
  cols = w / scale;
  rows = h / scale;
  terrain = new float[cols][rows];
  colorDict = new IntDict();
  colorDict.set("0",#FF9B83);
  colorDict.set("25",#EE9383);
  colorDict.set("50",#DD8B82);
  colorDict.set("75",#CC8482);
  colorDict.set("100",#BB7C82);
  colorDict.set("125",#AA7481);
  colorDict.set("150",#986C81);
  colorDict.set("175",#876480);
  colorDict.set("200",#765C80);
  colorDict.set("225",#655580);
  colorDict.set("250",#544D7F);
  colorDict.set("255",#43457F);
  
  
  
  colors.add(color(#FF9B83));
  colors.add(color(#EE9383));
  colors.add(color(#DD8B82));
  colors.add(color(#CC8482));
  colors.add(color(#BB7C82));
  colors.add(color(#AA7481));
  colors.add(color(#986C81));
  colors.add(color(#876480));
  colors.add(color(#765C80));
  colors.add(color(#655580));
  colors.add(color(#544D7F));
  colors.add(color(#43457F));

}

    // Method for getting the maximum value
  public static int getMax(int[] inputArray){ 
    int maxValue = inputArray[0]; 
    for(int i=1;i < inputArray.length;i++){ 
      if(inputArray[i] > maxValue){ 
         maxValue = inputArray[i]; 
      } 
    } 
    return maxValue; 
  }
 
  // Method for getting the minimum value
  public static int getMin(int[] inputArray){ 
    int minValue = inputArray[0]; 
    for(int i=1;i<inputArray.length;i++){ 
      if(inputArray[i] < minValue){ 
        minValue = inputArray[i]; 
      } 
    } 
    return minValue; 
  } 

void draw() {
  background(0);
  flying -= speed;
  float yOffset = flying;
  for (int y=0; y < rows; y++) {
    float xOffset = 0;
    for (int x=0; x < cols; x++) {
      //terrainHeight = map(mouseY, 0, height, 155, 0);
      //terrainHeight = 55;
      terrain[x][y] = map(noise(xOffset, yOffset), 0, 1, -terrainHeight, terrainHeight);
      xOffset += 0.1;
    } 
    yOffset += 0.1;
  }
  
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for (int y=0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x < cols; x++) {
      String colorStrArray[] = colorDict.keyArray();
      int [] colorArray = new int [colorDict.size()];
      for(int i=0; i<colorDict.size(); i++) {
         colorArray[i] = Integer.parseInt(colorStrArray[i]);
      }
      
      float mountainHeight = map(terrain[x][y], 0, rows, terrainHeight * -1, terrainHeight);
      int mountainHeightInt = (int) abs(mountainHeight);
      
      sort(colorArray);
      
      mountainHeights.add(mountainHeightInt);
      
      if(mountainHeightInt > heightMax || heightMax == -1) {
        heightMax = mountainHeightInt;
      } 
      
      if (mountainHeightInt < heightMin || heightMin == -1) {
        heightMin = mountainHeightInt;
      }
      
      
      //int returnValue = binarySearch(colorArray,0,colorDict.size()-1,mountainHeightInt);
       int returnValue = findClosest(colorArray,mountainHeightInt); //<>//
       println("returnValue: " + returnValue);
       
      Integer returnValueInteger = (Integer) returnValue;
      String returnValueString = returnValueInteger.toString();
      ColorToDisplay = colorDict.get(returnValueString);
      println("colorToDisplay: " + ColorToDisplay);
      
      stroke(ColorToDisplay, map(y, 0, rows, 0, 255));
      //stroke(map(terrain[x][y], terrainHeight*-1, terrainHeight, 0, 255), map(y, 0, rows, 0, 255), map(x, 0, cols, 0, 255));
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
      
    }
    endShape();
  }
}
