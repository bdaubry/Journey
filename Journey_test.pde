int cols, rows;
int scale = 38;
int w = 1300;
int h = 660;
int levelAbs;
int terrainMaxVal;
float terrainMapVal;
float levelAdj;
float alpha;
float level;
float flying = 0;
float speed = 0.006;
float terrainHeight = 50;
float[][] terrain;
float rangeLow = -15;
float rangeHigh = 15;
float totalHigh = 15;
float rangeLength = 30;
int totalCount = 0;
String totalCountString;
int highCount;
color c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12;
FloatDict rangeLast100 = new FloatDict(0);

//import processing.io.*; // import the hardware IO library
//int pin_a = 24;
//int pin_b = 23;
//int lastEncoded1 = 0;
//int pin_c = 20;
//int pin_d = 16;
//int lastEncoded2 = 0;

void setup() {
  //size(800, 480, P3D);
  fullScreen(P3D);
  noCursor();
  noFill();
  cols = w / scale;
  rows = h / scale;
  terrain = new float[cols][rows];

  c1 = color(255,155,131);
  c2 = color(238,147,131);
  c3 = color(221,139,130);
  c4 = color(204,132,130);
  c5 = color(187,124,130);
  c6 = color(170,116,129);
  c7 = color(152,108,129);
  c8 = color(135,100,128);
  c9 = color(118,92,128);
  c10 = color(101,85,128);
  c11 = color(84,77,127);
  c12 = color(67,69,127);
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
      //stroke(map(terrain[x][y], 0, rows, 102, 178), map(terrain[x][y], 0, rows, 82, 161), map(terrain[x][y], 0, rows, 161, 210), map(y, 0, rows+20, 0, 150));
         //<>//
      if (totalCount >= 25) { //<>//
        rangeLast100.sortKeys(); //<>//
        rangeLast100.remove(rangeLast100.minKey()); //<>//
      }
      
      level = map(terrain[x][y], terrainHeight*-1, terrainHeight, 0, 150);
      
      int rangeCountNum = rangeLast100.size();
      
      if(rangeCountNum > 0){
      for (int i=rangeCountNum; i >= 0; i--){
        String iString = String.valueOf((i+1));
        rangeLast100.set(iString,rangeLast100.value(i));
      }}
      
      totalCountString = String.valueOf(totalCount);
      rangeLast100.set(totalCountString,level);
      totalCount++;
      
      rangeHigh = rangeLast100.maxValue();
      rangeLow = rangeLast100.minValue();
      println("Level"+level + "Low: "+rangeLow+"  High: "+rangeHigh+"  RangeLength: "+rangeLength);
      
      if(rangeLength == 0) {
       rangeLength = 1; 
      } else {
      rangeLength = abs(rangeHigh) + abs(rangeLow);
      }
      //alpha = map(y, 0, rows+20, 0, 150);
      //println("level: " + levelAdj + ", alpha: " + alpha + ", terrainHeight: " + terrainHeight + ", terrainMapVal: " + terrainMapVal);
      //map(y, 0, rows, 0, 150) //<>//
      if( //<>//
          level < (rangeLow+(rangeLength * (1/12)))){
        stroke(c12,map(y, 0, rows, 0, 150));
      } else if ( //<>//
          level >= (rangeLow +(rangeLength * (1/12)))
          && 
          level < (rangeLow + (rangeLength * (2/12)))
        ) {
        stroke(c11,map(y, 0, rows, 0, 255));
      } else if (
          level >= (rangeLow+(rangeLength * (2/12)))
          && 
          level < (rangeLow+(rangeLength * (3/12)))
        ) {
        stroke(c10,map(y, 0, rows, 0, 255));
      } else if (
        level >= (rangeLow+(rangeLength * (3/12)))
        && 
        level < (rangeLow+(rangeLength * (4/12)))
      ) {
        stroke(c9,map(y, 0, rows, 0, 150));
      } else if (
        level >= (rangeLow+(rangeLength * (4/12)))
        && 
        level < (rangeLow+(rangeLength * (5/12)))
      ) {
        stroke(c8,map(y, 0, rows, 0, 150));
      } else if (
        level >= (rangeLow+(rangeLength * (5/12)))
        && 
        level < (rangeLow+(rangeLength * (6/12)))
      ) {
        stroke(c7,map(y, 0, rows, 0, 150));
      } else if (
        level >= (rangeLow+(rangeLength * (6/12)))
        && 
        level < (rangeLow+(rangeLength * (7/12)))
      ) {
        stroke(c6,map(y, 0, rows, 0, 150));
      } else if (
        level >= (rangeLow+(rangeLength * (7/12)))
        && 
        level < (rangeLow+(rangeLength * (8/12)))
      ) {
        stroke(c5,map(y, 0, rows, 0, 150));
      } else if (
        level >= (rangeLow+(rangeLength * (8/12)))
        && 
        level < (rangeLow+(rangeLength * (9/12)))
      ) {
        stroke(c4,map(y, 0, rows, 0, 150));
      } else if (
        level >= (rangeLow+(rangeLength * (9/12)))
        && 
        level < (rangeLow+(rangeLength * (10/12)))
      ) {
        stroke(c3,map(y, 0, rows, 0, 150));
      } else if (
        level >= (rangeLow+(rangeLength * (10/12)))
        && 
        level < (rangeLow+(rangeLength * (11/12)))
      ) {
        stroke(c2,map(y, 0, rows, 0, 150));
      } else if (
        level >= (rangeLow+(rangeLength * (11/12))) 
        && 
        level < rangeHigh
      ) {
        stroke(c1,map(y, 0, rows, 0, 150));
      }
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]); //<>//
    }
    endShape();
  }
}

// Java implementation of recursive Binary Search
class BinarySearch {
    // Returns index of x if it is present in arr[l..
    // r], else return -1
    int binarySearch(int arr[], int l, int r, int x)
    {
        if (r >= l) {
            int mid = l + (r - l) / 2;
 
            // If the element is present at the
            // middle itself
            if (arr[mid] == x)
                return mid;
 
            // If element is smaller than mid, then
            // it can only be present in left subarray
            if (arr[mid] > x)
                return binarySearch(arr, l, mid - 1, x);
 
            // Else the element can only be present
            // in right subarray
            return binarySearch(arr, mid + 1, r, x);
        }
 
        // We reach here when element is not present
        // in array
        return -1;
    }
 
        BinarySearch ob = new BinarySearch();
        int arr[] = { 2, 3, 4, 10, 40 };
        int n = arr.length;
        int x = 10;
        int result = ob.binarySearch(arr, 0, n - 1, x);
        if (result == -1)
            System.out.println("Element not present");
        else
            System.out.println("Element found at index " + result);
    }
}
