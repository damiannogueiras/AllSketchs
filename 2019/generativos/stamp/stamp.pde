import org.processing.wiki.triangulate.*;
import toxi.math.noise.SimplexNoise;

//920141 48273 79839 883078 488833 773004
int seed = 773004;//int(random(999999));

float nwidth =  960; 
float nheight = 960;
float swidth = 960; 
float sheight = 960;
float scale  = 1;

boolean export = false;

void settings() {
  scale = nwidth/swidth;
  size(int(swidth*scale), int(sheight*scale), P2D);
  smooth(8);
  pixelDensity(2);
}

void setup() {

  generate();

  if (export) {
    saveImage();
    exit();
  }
}

void draw() {
}

void keyPressed() {
  if (key == 's') saveImage();
  else {
    seed = int(random(999999));
    generate();
  }
}

void generate() { 

  randomSeed(seed);
  noiseSeed(seed);

  randPallets();

  background(rcol());

  float grid = 40;
  int cc = int(300*random(0.8, 1));
  float amp = random(8, 10)*0.4;
  forms(cc, grid, amp);
  
  forms(cc, grid, amp*0.1);
  
  
  forms(cc, grid/4, amp*0.1);
}

void forms(int cc, float grid, float amp) {

  for (int i = 0; i < cc; i++) {

    float x1 = random(width+grid);
    float y1 = random(height+grid);
    float x2 = x1+random(-450, 450)*random(0.5)*random(1)*random(amp);
    float y2 = y1+random(-450, 450)*random(0.5)*random(amp);

    x1 -= x1%grid;
    y1 -= y1%grid;
    x2 -= x2%grid;
    y2 -= y2%grid;

    if (random(1) < 0.5) {
      x1 -= x1%(grid*2);
      y1 -= y1%(grid*2);
      x2 -= x2%(grid*2);
      y2 -= y2%(grid*2);
    }

    float det = 0.001*random(random(10))*10;

    noStroke();
    fill(rcol());
    beginShape();
    noiseLine(x1, y1, x2, y2, det);
    endShape();
  }
}

void noiseLine(float x1, float y1, float x2, float y2, float det) {
  ArrayList<PVector> points = new ArrayList<PVector>();

  int lar = int(dist(x1, y1, x2, y2));

  float desAng = atan2(y2-y1, x2-x1);

  float ix = 0;
  float iy = 0;
  float des = random(1000);
  points.add(new PVector(ix, iy));
  for (int k = 0; k < lar; k++) {
    float ang = (noise(des+ix*det, des+iy*det)*2-1)*PI*3.8+desAng;
    ix += cos(ang);
    iy += sin(ang);
    points.add(new PVector(ix, iy));
  }

  PVector p1 = points.get(0);
  PVector p2 = points.get(points.size()-1);
  float ang = atan2(p2.y-p1.y, p2.x-p1.x);
  float dis = p1.dist(p2);


  for (int k = 0; k < points.size(); k++) {
    PVector p = points.get(k);
    p.rotate(-ang+desAng);
    p.mult((lar*1./dis));
  }

  noStroke();
  fill(rcol());
  beginShape();
  for (int k = 0; k < points.size(); k++) {
    PVector p = points.get(k);
    vertex(x1+p.x, y1+p.y);
  }
  endShape();
}

void saveImage() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2); 
  saveFrame(timestamp+"-"+seed+".png");
}

void randPallets() {
  int aux[] = {#F23602, #300F96, #C9FFF6, #F72C81, #021E06, #F9C013}; 
  colors = aux; 

  int aux2[] = new int[int(random(5, 6))]; 
  for (int i = 0; i < aux2.length; i++) {
    aux2[i] = rcol();
  }
  colors = aux2;
}


//int colors[] = {#E1E8E0, #F5CE4B, #FC5801, #025DC4, #02201A, #489B4D};
//int colors[] = {#F0C7C0, #F65A5C, #3080E9, #50E2C6, #F7D3C3, #F41B9C};
//int colors[] = {#EF3621, #295166, #C9E81E, #0F190C, #F5FFFF};
//int colors[] = {#F5B4C4, #FCCE44, #EE723F, #77C9EC, #C5C4C4, #FFFFFF};
//int colors[] = {#0E1619, #024AEE, #FE86F0, #FD4335, #F4F4F4};
//int colors[] = {#F7DF04, #EAE5E5, #7332AD, #000000, #92A7D3};
//int colors[] = {#333A95, #FFDC15, #FC9CE6, #31F5C2, #1E9BF3};
//int colors[] = {#333A95, #F6C806, #F789CA, #1E9BF3};
int colors[]; 
int rcol() {
  return colors[int(random(colors.length))];
}
int getColor() {
  return getColor(random(colors.length));
}
int getColor(float v) {
  v = abs(v); 
  v = v%(colors.length); 
  int c1 = colors[int(v%colors.length)]; 
  int c2 = colors[int((v+1)%colors.length)]; 
  return lerpColor(c1, c2, pow(v%1, 0.5));
}
