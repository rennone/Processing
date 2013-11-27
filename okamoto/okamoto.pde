int cellSize = 500;
int w = 500, h = 500;
int[][][] region;
PImage img;
final color[] col= {color(0), color(255,0,0), color(0,255,0)};
int time;
boolean flag = false;
void setup(){
  size(w,h);
  region = new int[w][h][2];
  img = createImage(w,h,RGB);
  time = 0;
  frameRate(1);
}

void draw(){
  if(flag)  calc();
  img.loadPixels();
  for(int i=0; i<width; i++){
    for(int j=0; j<height; j++){
      img.pixels[j*width+i] = col[region[i][j][time]];
    }
  }
  img.updatePixels();
  image(img, 0,0,width,height);
}

void calc(){
  for(int i=0; i<width; i++){
    for(int j=0; j<height; j++){
      update(i,j);
    }
  }
  time = (time+1)%2;
}

void update(int x, int y){
 int num = 0;
 if(region[x][y][time] == 0)return;
 for(int i=-1; i<2; i++){
  for(int j=-1; j<2; j++){
    int nx = x+i;
    int ny = y+j;
    if(nx<0 || ny<0 || nx>=width || ny >=height || region[nx][ny][time] == 0) continue;
     num += (region[nx][ny][time] == 1) ? 1 : 0;
  }
 } 
 region[x][y][(time+1)%2] = int(num>4)+1;
}

int stX, stY;
void mousePressed(){
  stX = mouseX;
  stY = mouseY;
}

void mouseDragged(){
//  region[mouseX][mouseY] = 1;
}

void mouseReleased(){
 for(int i=stX; i<mouseX; i++){
  for(int j=stY; j<mouseY; j++){
    region[i][j][time] = int(random(2)+1); 
  }
 } 
}

void keyPressed(){
 flag = true; 
}
