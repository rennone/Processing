import processing.opengl.*;
import java.util.Map.*;

Player player;
KeyEventManager keyEM;
Field field;
Enemy enemy;
int[][] HeightMap;

void setup(){
  size(500,500,OPENGL);
  colorMode(HSB);
  hint(ENABLE_DEPTH_SORT);
  keyEM = new KeyEventManager(); //キーイベントの作成
  keyEM.initialize();  //使うキーの登録
  field = new Field();
  field.createMap(1); //分割度
  player = new Player();
  enemy = new Enemy();
}

int frame = 0;
void draw(){
  calc();
  background(color(0,255,0, 150));   //環境光
  ambientLight(255, 0, 255);   //平行光
  directionalLight(255,0,255,1,1,1); 
  //drawMap();
  field.draw();
  player.draw();
  //enemy.draw();
}

void calc(){
  field.calc();
  player.calc();
  keyEM.calc(); 
  //enemy.calc();
}


class Point{
 int x,y,z; 
}

class PointObject{
  PVector pos;
  PointObject(float _x, float _y, float _z){
    pos = new PVector(_x,_y,_z);
  }
  PointObject(PVector _p){
    pos = _p;
  }
}
/*
abstract class Agent{
  PVector pos, dir;
  int theta;
  int pose;
  Agent(PVector _p){
    pos = _p;
    dir = new PVector(0.0f,0.0f,1.0f);
    pose=0;
  }
  
  abstract void draw();
  abstract void calc();
}

class Player extends Agent{
 int velocity;
 int condition;
 Player(){
    super(field.InitPosition());
 }

 void colleasionCheck(){
  }
  
    
  void turn(int d){
    theta+=d;
    if(theta>=360) theta-=360;
    else if(theta<0) theta+=360;
    dir.x = sin(radians(-theta));
    dir.z = cos(radians(-theta));
  }
  
  void move(float dx, float dz){
    collisionCheck(pos.x+dx, pos.z+dz);
    pos.x += dx;
    pos.z += dz;    
  }
  
  void moveForward(){
    move(velocity*dir.x, velocity*dir.z); 
  }
  
  void moveBack(){
    
  }
  
  void moveRight(){
  }
  
  void moveLeft(){
    
  }
  
  void action(){
    if(keyEM.isPushed('a')) moveLeft();
    if(keyEM.isPushed('d')) moveRight();
    if(keyEM.isPushed('w')) moveForward();
    if(keyEM.isPushed('s')) moveBack();
    if(keyEM.isPushed(' ')) moveJump();
    if(keyEM.isPushed(RIGHT)) turnRight();
    if(keyEM.isPushed(LEFT)) turnLeft();
    if(keyEM.isPushed(UP)) camera.moveUp();
    if(keyEM.isPushed(DOWN)) camera.moveDown();
    if(keyEM.isToggledOn(ENTER)) condition = actDIG;
    if(keyEM.isPushed(ESC)) exit(); 
  }  
}
*/

class Agent{
  color col;
  final int actWALK = 0, actDIG=1;
  PVector pos, dir;
  float speed=20, angSpeed = 15;
  float g;
  int pose;
  float mySize;
  int condition;
  Agent(){
    mySize = field.getCellSize()/6;
    pos = field.getInitPosition();
    dir = new PVector(0, 0, 1.0f);
    ground();
    pose = 0;
    condition = actWALK;
    col = color(255,255,255);
  }
 
  void turn(float d){
    pose += d;
    dir.x = sin(radians(-pose));
    dir.z = cos(radians(-pose));
  }
 
  void turnRight(){
    turn(angSpeed);
  }
 
  void turnLeft(){
    turn(-angSpeed);
  }
 
 void move(float dx, float dz){
   PVector cellpos = field.getCellPosition(pos);
   int i = int(cellpos.x);
   int k = int(cellpos.z);
   pos.x += dx;
   pos.z += dz;
   field.inRegion(pos); 
   int CELLSIZE = field.getCellSize();
   if(!field.collisionBlock(pos.x+1.2*dx, pos.y, pos.z+1.2*dz)){
     pos.x = min(max(i*CELLSIZE, pos.x), (i+1)*CELLSIZE-1);
     pos.z = min(max(k*CELLSIZE, pos.z), (k+1)*CELLSIZE-1); 
   }
 }
 
 void moveJump(){
   g = -50;
 }
 
 void moveForward(){
   move(speed*dir.x, speed*dir.z);
 }
 
 void moveBack(){
   move(-speed*dir.x, -speed*dir.z);
 } 
 
 void moveRight(){
   move(-speed*dir.z, speed*dir.x);
 }
 
 void moveLeft(){
   move(speed*dir.z, -speed*dir.x);
 }
 
 void ground(){   
   pos.y += g; 
   g=min(field.getCellSize()/2, g+15);
   pos.y = min(field.getHmap(pos.x,pos.y,pos.z) - mySize, pos.y);
 }

 void draw(){
   drawBody();
   if(condition >= actDIG && condition <= actDIG+6)   animationDig();
 }
 
 void drawBody(){
   float headSize = mySize/3*2;
   fill(col);
   pushMatrix();
   translate(pos.x, pos.y, pos.z);
   pushMatrix();
   rotateY(-radians(pose) );
   rotateY(radians(condition*60));
   box(2*mySize, 2*mySize, mySize);
   translate(0, -mySize-mySize/2, 0);
   noStroke();
   sphere(headSize);
   popMatrix();
   popMatrix();
   stroke(0);
 }
 
 void animationDig(){   
   attack();
   pushMatrix();
   translate(pos.x, pos.y-mySize/2, pos.z);
   rotateY(-radians(pose));
   rotateY(radians(condition*60));
   box(5*mySize, mySize/2, mySize/2);
   popMatrix();
   condition = (condition+1)%6;
 }
 
 void attack(){
   field.damageBlock(pos.x+speed*dir.x, pos.y, pos.z+speed*dir.z);
 }

void calc(){}
}


int[] dx = {-1, 0, +1, 0, -1,-1,+1,+1};
int[] dz = { 0,-1,  0,+1, -1,+1,-1,+1};

class Path{
 int x,z;
 Path prev;
 Path(int _x, int _z){
   x = _x;
   z = _z;
   prev = null;
 }
 
 Path(int _x, int _z, Path _prev){
   x = _x;
   z = _z;
   prev = _prev;
 }
}

class Enemy extends Agent{
  int actTHINK = 10;
  Agent target;
  float[][] value;
  int loop;
  PVector prevPos;
  ArrayList path;
  Enemy(){
   super();
   pos = field.getRandomPosition();
   prevPos = field.getCellPosition(pos);
   col = color(50,200,150);
   speed = 10;
   target = player;
   int msize = field.getMapSize();
   value = new float[msize][msize];
   loop = 0;
   condition = actTHINK;
   path = new ArrayList();
  }
 
  void dfs(){
    int msize = field.getMapSize();
    boolean[][] checked = new boolean[msize][msize];
    ArrayList stack = new ArrayList();
    PVector cellPos = field.getCellPosition(pos);
    PVector cG      = field.getCellPosition(field.goal);
    int g_x = int(cG.x), g_z = int(cG.z);
    Path optPath = null;
    stack.add(new Path(int(cellPos.x), int(cellPos.z)));
    while(stack.size()!=0){
      ArrayList st = new ArrayList(stack);
      stack.clear();
      for(int i=0; i<st.size(); i++){
        Path p = (Path)st.get(st.size()-1);
        if(p.x == cG.x && p.z == cG.z){ println("aaa");optPath = new Path(p.x, p.z, p.prev); break;}
        checked[p.x][p.z] = true;
        for(int j=0; j<8; j++){
          int nx = p.x+dx[j];
          int nz = p.z+dz[j];
          if(nx<0 || nz<0 || nx>=msize || nz>=msize || checked[nx][nz]) continue;
          if( HeightMap[nx][nz] > HeightMap[p.x][p.z]+1) continue;
          checked[nx][nz] = true;
          stack.add(new Path(nx,nz, p));
        }
      }
    }
    
    while(optPath != null){
     path.add(optPath);
     optPath = optPath.prev; 
    }
    println(path.size());
    condition = actWALK;
  }
 
  void moveJump(){
    if(pos.y >= field.getHmap(pos.x,pos.y,pos.z) - mySize)  g = -30;
  }
 
  void poseChange(PVector dire){
    float _x = dire.x;
    float _z = dire.z;
    float dx = _x - pos.x; 
    float dz = _z - pos.z;
    if(dx == 0 && dz == 0) return;
    float d = sqrt(dx*dx + dz*dz);  
    
    int theta = dx<0 ? int(180*acos(dz/d)/PI) : int(-180*acos(dz/d)/PI);
   pose =theta;
    dir.x = sin(radians(-pose));
    dir.z = cos(radians(-pose));
  }
  
  void setPose(int p){
    pose = p;
    dir.x = sin(radians(-pose));
    dir.z = cos(radians(-pose));
  }
  
  void randomWalk(){
    setPose(int(random(360))); 
  }
  
  void searchJuel(){
    poseChange(field.goal);
  }
  
  void trackTarget(){    
     poseChange(target.pos);
     if(pos.dist(target.pos)>field.getCellSize()*10) {target=null; condition = actWALK; return;}    
  }
  
  void draw(){
   drawBody();
   if(condition >= actDIG && condition <= actDIG+6)   animationDig();
   if(path != null) drawPath();
 }
 
 void drawPath(){
   int csize = field.getCellSize();
  for(int i=0; i<path.size(); i++){
   Path p = (Path)path.get(i);
   pushMatrix();
   translate(p.x*csize, -(HeightMap[p.x][p.z]+3)*csize, p.z*csize);
   box(csize);
   popMatrix();
  } 
   
 }
  
  void updateValue(){
    int msize = field.getMapSize();
    float alpha=0.1, gamma = 0.9;
    for(int i=0; i<msize; i++){
      for(int j=0; j<msize; j++){
        value[i][j] *=0.8;
      }
    }
    PVector cG = field.getCellPosition(field.goal);
    value[int(cG.x)][int(cG.z)] +=10;
  }
  
  void move(float dx, float dz){
   PVector cellpos = field.getCellPosition(pos);
   int i = int(cellpos.x);
   int k = int(cellpos.z);
   pos.x += dx;
   pos.z += dz;
   field.inRegion(pos); 
   int CELLSIZE = field.getCellSize();
   if(!field.collisionBlock(pos.x+1.2*dx, pos.y, pos.z+1.2*dz)){
     pos.x = min(max(i*CELLSIZE, pos.x), (i+1)*CELLSIZE-1);
     pos.z = min(max(k*CELLSIZE, pos.z), (k+1)*CELLSIZE-1);
     moveJump(); 
   }
 }

 void thinking(){
  dfs();
   condition = actWALK;
 }

 
  
  void nextCell(){
  } 
  
  
  void animationDig(){   
   attack();
   pushMatrix();
   translate(pos.x, pos.y-mySize/2, pos.z);
   rotateY(-radians(pose));
   rotateY(radians(condition*60));
   box(5*mySize, mySize/2, mySize/2);
   popMatrix();
   condition = (condition)%6 + 1;
 }
 
  void calc(){
   if(condition == actTHINK) thinking();
   //walk();
   field.inRegion(pos);
   ground();
   //player.camera.playerTrack(pos, dir);
 }
}

//--------------------------------------//
//              プレイヤー                //
//-------------------------------------//


class Player extends Agent{
  Camera camera;
  Player(){
    super();
    pos = field.getInitPosition();
    dir = new PVector(0, 0, 1.0f);
    camera = new Camera();
    //camera.playerTrack(pos, dir);
    col = color(150, 200, 150);
    camera.setTarget(this);
  }

  void draw(){
   drawBody();
   if(condition != actWALK)   animationDig();
 }
 
 void knockBack(float _x, float _z){
   pos.x+=_x;
   pos.z+=_z;
 }
 void drawBody(){
   float headSize = mySize/3*2;
   fill(col);
   pushMatrix();
   translate(pos.x, pos.y, pos.z);
   pushMatrix();
   rotateY(-radians(pose) );
   rotateY(radians(condition*60));
   box(2*mySize, 2*mySize, mySize);
   translate(0, -mySize-mySize/2, 0);
   noStroke();
   sphere(headSize);
   popMatrix();
   popMatrix();
   stroke(0);
 }
 
 void animationDig(){   
   attack();
   pushMatrix();
   translate(pos.x, pos.y-mySize/2, pos.z);
   rotateY(-radians(pose));
   rotateY(radians(condition*60));
   box(5*mySize, mySize/2, mySize/2);
   popMatrix();
   condition = (condition+1)%6;
 }
 
 void attack(){
   field.damageBlock(pos.x+speed*dir.x, pos.y, pos.z+speed*dir.z);
 }

 void walk(){ 
   if(keyEM.isPushed('a')) moveLeft();
   if(keyEM.isPushed('d')) moveRight();
   if(keyEM.isPushed('w')) moveForward();
   if(keyEM.isPushed('s')) moveBack();
   if(keyEM.isToggledOn(' ')) moveJump();
   if(keyEM.isPushed(RIGHT)) turnRight();
   if(keyEM.isPushed(LEFT)) turnLeft();
   if(keyEM.isPushed(UP)) camera.moveUp();
   if(keyEM.isPushed(DOWN)) camera.moveDown();
   if(keyEM.isToggledOn(ENTER)) condition = actDIG;
   if(keyEM.isPushed(ESC)) exit();
 }
 
 void calc(){
   walk();
   field.inRegion(pos);
   ground();
   //camera.playerTrack(pos, dir);
   camera.calc();
   if(field.goaled(pos))exit();
 }
 
}

class Camera{
 PVector pos, pose;
 float depth;
 float phi;
 Agent target;
 Camera(){
   pos  = new PVector(0.0f, 0.0f, 0.0f);
   pose = new PVector(0.0f, 1.0f,0.0f);
   depth = 200;
   phi = 45;
   target = null;
 }

 void moveUp(){
   phi = min(90, phi+10);
 }
 
 void moveDown(){
   phi = max(0, phi-10);
 }
 
 void calc(){
  pos.x = target.pos.x - depth*target.dir.x;   //ターゲットの後ろに
  pos.z = target.pos.z - depth*target.dir.z;
  pos.y = target.pos.y - depth*sin(radians(phi));
  camera(pos.x,pos.y,pos.z, target.pos.x, target.pos.y, target.pos.z, pose.x, pose.y, pose.z);
 }
 
 void setTarget(Agent tar){
   target = tar;
 } 
}

class Field{
  Cell[][] map;
  int MAPSIZE, CELLSIZE;
  PVector goal;
  
  Field(){
    MAPSIZE = 1<<6;
    CELLSIZE = 50;
    map = new Cell[MAPSIZE][MAPSIZE];
    HeightMap = new int[MAPSIZE][MAPSIZE]; //グローバル変数, 高さのみ保存; 
  }
  
  boolean collisionCheck(PVector pos, PVector vec, PVector nor){
    return false;
  } 
  
  void makeHmap(){
   for(int i=0; i<MAPSIZE; i++){
    for(int j=0; j<MAPSIZE; j++){
      HeightMap[i][j] = map[i][j].getHeight();
    }
   } 
  }
  
  boolean goaled(PVector p){
    PVector cP = getCellPosition(p);
    PVector cG = getCellPosition(goal);
   return cP.x == cG.x && cP.y == cG.y && cP.z == cG.z; 
  }
  
  int getMapSize(){
   return MAPSIZE; 
  }
  
  int getCellSize(){
   return CELLSIZE; 
  }
  
  PVector getCellPosition(PVector pos){
   return new PVector(floor(pos.x/CELLSIZE), floor(-pos.y/CELLSIZE), floor(pos.z/CELLSIZE)); 
  }
  
  void createMap(int level){
   split(0,0, MAPSIZE-1, MAPSIZE-1, level);
   //ゴールの宝物を作成
   
   int gx,gy,gz;
   gx = int(random(MAPSIZE-1)+1);
   gz = int(random(MAPSIZE-1)+1);
   gy = int(map[gx][gz].getHeight()-1);
   goal = new PVector(gx*CELLSIZE + CELLSIZE/2,-gy*CELLSIZE,gz*CELLSIZE + CELLSIZE/2);
   ((Block)map[gx][gz].blocks.get(gy)).setType(5);
  }
  
  void split(final int x1,final  int z1,final  int x2,final int z2, int n){
    if(x1==x2 || z1==z2) return;
    int sum=0;
    int[] x = new int[4];
    int[] z = new int[4];
    int srand = 8, rand=4;
    x[0] = x[1] = x1; x[2] = x[3] = x2;
    z[0] = z[2] = z1; z[1] = z[3] = z2;
    
    for(int i=0; i<4; i++){
      if(map[x[i]][z[i]]==null)  map[x[i]][z[i]] = new Cell(int(random(srand))+1); 
      sum += map[x[i]][z[i]].getHeight();
    }
   
    int nx = floor((x1+x2)/2), nz = floor((z1+z2)/2);
    map[nx][nz]   = new Cell(sum/4 + int(random(rand)) + 3);
    map[nx+1][nz] = new Cell(sum/4 + int(random(rand)) +3);
    map[nx][nz+1] = new Cell(sum/4 + int(random(rand)) + 3);
    map[nx+1][nz+1] = new Cell(sum/4 + int(random(rand)) + 3);
    if(n==0){
      merge(x1,z1,x2,z2);
    }
    else{
      split(x1   ,z1  , nx, nz, n-1);
      split(nx+1 ,z1  , x2, nz, n-1);
      split(x1   ,nz+1, nx, z2, n-1);
      split(nx+1 ,nz+1, x2, z2, n-1);
    }
  }
  
  void merge(final int x1, final int z1, final  int x2, final int z2){
    if(x1==x2 || z1==z2) return;
    int nx = floor((x1+x2)/2), nz = floor((z1+z2)/2);
    map[nx][z1] = new Cell(floor( (map[x1][z1].getHeight()+map[x2][z1].getHeight())/2));
    map[nx][z2] = new Cell(floor( (map[x1][z2].getHeight()+map[x2][z2].getHeight())/2));
    map[x1][nz] = new Cell(floor( (map[x1][z1].getHeight()+map[x1][z2].getHeight())/2));
    map[x2][nz] = new Cell(floor( (map[x2][z1].getHeight()+map[x2][z2].getHeight())/2));
    bilinearMerge(x1, z1, nx, nz);
    bilinearMerge(x1, nz, nx, z2);
    bilinearMerge(nx, z1, x2, nz);
    bilinearMerge(nx, nz, x2, z2);
  }

  void bilinearMerge(final int x1, final int z1, final  int x2, final int z2){
    float d = (x2-x1)*(z2-z1);
    for(int i=x1; i<=x2;i++){
      for(int j=z1;j<=z2;j++){
        int var = round((map[x1][z1].getHeight()*(x2-i)*(z2-j) + map[x2][z1].getHeight()*(i-x1)*(z2-j) 
                       + map[x1][z2].getHeight()*(x2-i)*(j-z1) + map[x2][z2].getHeight()*(i-x1)*(j-z1))/d);
        map[i][j] = new Cell(max(1,var));
      }
    }
  }
  
  void inRegion(PVector pos){
    pos.x = min(max(0, pos.x), MAPSIZE*CELLSIZE-1);
    pos.z = min(max(0, pos.z), MAPSIZE*CELLSIZE-1);
  }

  float getHeight(float x, float y, float z){
    int i = floor(x/CELLSIZE);
    int j = floor(-y/CELLSIZE);
    int k = floor(z/CELLSIZE);
    if(i<0 || k<0 || i>=MAPSIZE || k>=MAPSIZE) return -1;

    return -j*CELLSIZE;
  }
  
  int getHmap(float x, float y, float z){
    int i = floor(x/CELLSIZE);
    int j = floor(-y/CELLSIZE);
    int k = floor(z/CELLSIZE);
    if(i<0 || k<0 || i>=MAPSIZE || k>=MAPSIZE) return-1;
    if(map[i][k].getHeight() <= j) return -map[i][k].getHeight()*CELLSIZE;
    int l = j<0? 0:j;
    for(; l<map[i][k].getHeight(); l++){
      if(map[i][k].collisionBlock(l)) return -l*CELLSIZE;
    }
    return -map[i][k].getHeight()*CELLSIZE;
  }
  
  boolean collisionBlock(float x, float y, float z){
    int i = floor(x/CELLSIZE);
    int j = floor(-y/CELLSIZE);
    int k = floor(z/CELLSIZE);
    if(i<0 || k<0 || i>=MAPSIZE || k>=MAPSIZE || j<0) return false;
    
    if(map[i][k].getHeight() <= j){
      return true;
    }
  
    return map[i][k].collisionBlock(j) ;//|| Hmap[i][k].collisionBlock(j+1);
  }
  
  void damageBlock(float x, float y, float z){
    int i = floor(x/CELLSIZE);
    int j = floor(-y/CELLSIZE);
    int k = floor(z/CELLSIZE);
    if(i<0 || k<0 || i>=MAPSIZE || k>=MAPSIZE || j<0) return;
   
    if(map[i][k].getHeight() < j+1) return;
    
    ((Block)map[i][k].blocks.get(j)).damage();
  }
  
  void calc(){ 
  }
  
  void drawTest(){
    fill(0);
    pushMatrix();  
    translate(0, -300, 0);  // 物体を並進（ローカル座標系）
    // モデル-ビュー行列を取得
    PMatrix3D builboardMat = (PMatrix3D)g.getMatrix();
    // 回転成分を単位行列に
    builboardMat.m00 = builboardMat.m11 = builboardMat.m22 = 1;
    builboardMat.m01 = builboardMat.m02 = 0;
    builboardMat.m10 = builboardMat.m12 = 0;
    builboardMat.m20 = builboardMat.m21 = 0;
    resetMatrix();
    applyMatrix(builboardMat);
    fill(255,35,150);
    //stroke(255);
    //textFont(font, 24);
    textAlign(CENTER);
    text("Hello, World!", 0, 0);
    popMatrix();
    //stroke(0);  
  }
  void draw(){
    //drawTest();
    
    fill(255);
    pushMatrix();
    translate(CELLSIZE/2, 0, CELLSIZE/2);
    for(int i=0; i<MAPSIZE; i++){
      for(int j=0; j<MAPSIZE; j++){
        pushMatrix();
        translate(CELLSIZE*i,0,CELLSIZE*j); //bottom is 0
        map[i][j].draw();
        popMatrix();
      }
    }
    popMatrix();
    
  }

  PVector getInitPosition(){
   return new PVector(CELLSIZE/2, map[0][0].getHeight()*CELLSIZE-10, CELLSIZE/2); 
  }
  
  PVector getRandomPosition(){
    int _x = int(random(MAPSIZE-2))+1;
    int _z = int(random(MAPSIZE-2))+1;
   return new PVector( _x*CELLSIZE + CELLSIZE/2, map[_x][_z].getHeight()*CELLSIZE-10,_z*CELLSIZE + CELLSIZE/2);
  }
  
  class Cell{
    ArrayList blocks;
    Cell(int hei){
      blocks = new ArrayList();
      for(int i=0; i<hei;i++){
        blocks.add(new Block());
      }
    }
    int getHeight(){
      return blocks.size();
    }
   
    boolean collisionBlock(int j){
      if(blocks.size()<j+1) return true;
      return ((Block)blocks.get(j)).canPass();
    }
    
    void draw(){
      pushMatrix();
      translate(0,-CELLSIZE/2,0);
      for(int i=0; i<blocks.size();i++) {
        Block b = (Block)blocks.get(i);
        b.draw();
        translate(0,-CELLSIZE, 0);
      }
      popMatrix();
   }
  }
  
  class Block{
    int type;
    int hp;
    
    Block(){
      type = int(random(5));
      hp = 10;
    }
    
    Block(int _type){
      type = _type;
      hp = 10;
    }
    
    void draw(){
      if(hp<=0 || (keyEM.isPushed('g') && type !=5)) return;
      
      if(type == 5){
        fill(type*50, 0,255);
        noStroke(); 
        sphere(CELLSIZE/3*2);
        stroke(0);
      }
      else{ 
        fill(type*50, 120,180); 
        box(CELLSIZE);
      }
    }
    
    boolean canPass(){
      if(type == 5) return true;
      if(hp<=0) return true;
      else return false;
    }
   
    void damage(){
      hp = 0;
    }
    
    void setType(int _type){
     type = _type; 
    }
  }
}


void mousePressed(){
 saveFrame("image.png"); 
}

//-------------------------------------//
//        キーボードイベントの管理クラス    //
//-------------------------------------//
class KeyEventManager{
  int pushed_key, prev_key; //押されたキー, 最大32キーまで登録可能
  int keyNum;
  HashMap<Integer, Integer> keyMap;
  
  KeyEventManager(){
    pushed_key = prev_key = 0;
    keyMap = new HashMap<Integer, Integer>();
    keyNum = 0;
  }
  
  void initialize(){
    registerKey('a');
    registerKey('d');
    registerKey('w');
    registerKey('s');
    registerKey(' ');
    registerKey(UP);
    registerKey(DOWN);
    registerKey(RIGHT);
    registerKey(LEFT);
    registerKey(ENTER);
    registerKey(ESC);
    registerKey('g');
  }

  //_keyを使用する事を登録, ASCIIで表現できる奴はこっち
  void registerKey(char _key){
    keyMap.put(int(_key), (1<<keyNum)); //n bit目をトグルする値を登録
    keyNum++;
  }
  
  //_keyを使用する事を登録, 特殊キーはこっち
  void registerKey(int _key){
    keyMap.put(_key, (1<<keyNum)); //n bit目をトグルする値を登録
    keyNum++;
  }
  
  //_keyが押された事を知らせる
  void pushKey(int _key){
    if(!keyMap.containsKey(_key)) return;
    pushed_key |= keyMap.get(_key); // _keyに対応するビットをたてる
  }
 
 
 //_keyが話された事を知らせる
  void releaseKey(int _key){
    if(!keyMap.containsKey(_key)) return;
    pushed_key &= ~keyMap.get(_key);  //_keyに対応するビットを下げる
  }
  
  //_keyが押されているかを返す
  boolean isPushed(char cha){
    int _key = int(cha);
    if(!keyMap.containsKey(_key)) return false;
    return (pushed_key & keyMap.get(_key)) == keyMap.get(_key);
  }
  
  //_keyが押されているかを返す
  boolean isPushed(int _key){
    if(!keyMap.containsKey(_key)) return false;
    return (pushed_key & keyMap.get(_key)) == keyMap.get(_key);
  }
  
  //_keyが今押されたかを返す
  boolean isToggledOn(int _key){
    if(!keyMap.containsKey(_key)) return false;
    return ((pushed_key&keyMap.get(_key))&(~prev_key&keyMap.get(_key))) == keyMap.get(_key) ;
  }
  
  //_keyが今押されたかを返す
  boolean isToggledOn(char cha){
    int _key = int(cha);
    if(!keyMap.containsKey(_key)) return false;
    return ((pushed_key&keyMap.get(_key))&(~prev_key&keyMap.get(_key))) == keyMap.get(_key) ;
  }
 
 //現在のキーボード情報を保存
  void calc(){
   prev_key = pushed_key; 
  }
}

//---------------キーボードが押されたら----------------------//
void keyPressed(){
  int k = key==CODED ? int(keyCode) : int(key);  //特殊キーか通常キーか調べる
  keyEM.pushKey(k);  //押された事を知らせる
}

//--------------キーボードが話されたら-----------------------//
void keyReleased(){
  int k = key==CODED ? int(keyCode) : int(key);
  keyEM.releaseKey(k);    //離れた事を知らせる
}

