
import processing.io.*;

int cols, rows;
int scale = 28;
int w = 1300;
int h = 660;
float flying = 0;
float speed = 0.015;
float terrainHeight = 55;
float[][] terrain;
color c1, c2;

int pin_a = 24;
int pin_b = 23;
int lastEncoded1 = 0;
int pin_c = 20;
int pin_d = 16;
int lastEncoded2 = 0;

void setup() {
  //size(800, 480, P3D);
  fullScreen(P3D);
  noCursor();
  noFill();
  cols = w / scale;
  rows = h / scale;
  terrain = new float[cols][rows];
  c1 = color(0, 255);
  c2 = color(0, 0);
  
  GPIO.pinMode(pin_a, GPIO.INPUT_PULLUP);
  GPIO.pinMode(pin_b, GPIO.INPUT_PULLUP);
  GPIO.pinMode(pin_c, GPIO.INPUT_PULLUP);
  GPIO.pinMode(pin_d, GPIO.INPUT_PULLUP);

  GPIO.attachInterrupt(pin_a, this, "updateTerrain", GPIO.CHANGE);
  GPIO.attachInterrupt(pin_b, this, "updateTerrain", GPIO.CHANGE);
  GPIO.attachInterrupt(pin_c, this, "updateSpeed", GPIO.CHANGE);
  GPIO.attachInterrupt(pin_d, this, "updateSpeed", GPIO.CHANGE);
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
      //stroke(map(terrain[x][y], 0, rows, 120, 180), 100, map(terrain[x][y], 0, rows, 140, 220), map(y, 0, rows+20, 0, 255));
      stroke(map(terrain[x][y], terrainHeight*-1, terrainHeight, 0, 255), map(y, 0, rows, 0, 255));
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }
}

void updateTerrain(int pin) { 
  int MSB = GPIO.digitalRead(pin_a);
  int LSB = GPIO.digitalRead(pin_b);
  int encoded = (MSB << 1) | LSB;
  int sum = (lastEncoded1 << 2) | encoded;

  if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
    if(terrainHeight < 160) {
      terrainHeight += 3;
    }
  }
  if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
    if(terrainHeight > 5) {
      terrainHeight -= 3;
    }
  }

  lastEncoded1 = encoded;
}

void updateSpeed(int pin) { 
  int MSB = GPIO.digitalRead(pin_c);
  int LSB = GPIO.digitalRead(pin_d);
  int encoded = (MSB << 1) | LSB;
  int sum = (lastEncoded2 << 2) | encoded;

  if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
    if(speed > 0) {
      speed -= 0.0015;
    }
  } 
  if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
    if(speed < 0.07) {
      speed += 0.0015;
    }
  }

  lastEncoded2 = encoded;
}
