//うつるんです、普通のシミュレーション
//下に状況を表すパラメータを表示

int Length = 500;
int normal_number, sick_number, dead_number;
int Max_Human = 100; //画面に登場させる人間の数
int notSick = 90; //病気にならない確率
int time = 0, num=0;
Human[] HumanList = new Human[Max_Human];
int[][] Normal = new int[Length][Length];
int[][] MAP = new int[Length][Length];
int wallSize = 10, holeSize=150;
int bounce = 1;
final int HEALTH = 1, SICK = 1<<1, DEATH = 1<<2, SPACE = Max_Human, BLOCK = Max_Human+1;
ArrayList wallList, deadManList;
final int WallX = 1<<1, WallY = 1<<2;
int bornTime = 300, deadP = 300, cureTime = 300;
ArrayList graph;
boolean stop;

class Wall{
 int x,y,w,h;
 int n;
 color c;
 Wall(int _x, int _y, int _w, int _h, int _n, color _c){
  x = _x;
  y = _y;
  w = _w;
  h = _h;
  n = _n;
  c = _c;
 }
 
 boolean inWall(int _x, int _y){
  return (x <= _x && _x < x+w && y <= _y && _y < y+h); 
 }
 
 void draw(){
  fill(c);
  stroke(c);
  rect(x,y,w,h); 
 }
}

void createBlock(int x, int y, int w, int h){

  color w_c = color(150,100,80);
  wallList.add(new Wall(x, y, w, h/2-holeSize, WallX, w_c));
  wallList.add(new Wall(x, y+h/2+holeSize, w, h/2-holeSize, WallX, w_c));

  color h_c = color(0,0,0);
  int th = min(5, holeSize/2);
  if(th==0) return;
  wallList.add(new Wall(x, y+h/2-holeSize, w, th, WallY, h_c));
  wallList.add(new Wall(x, y+h/2+holeSize-th, w, th, WallY, h_c));
}

void createWallBlock(){
  color w_c = color(200,100,0);
  wallList.add(new Wall(0, 0, 10, Length, WallX, w_c));
  wallList.add(new Wall(0, 0, Length, 10, WallY, w_c));
  wallList.add(new Wall(0,Length-10,Length,10, WallY, w_c));
  wallList.add(new Wall(Length-10,0,10,Length,WallX, w_c));
  
  createBlock(Length/2 - 15, 0       , 30, Length);
}

//初期化部
void setup() {
  size(Length,Length+150);
  background(0);
  frameRate(30);
  ellipseMode(CENTER); 

  initSetup();
}

void initSetup(){
  time = 0;
  dead_number=0;
  stop = false;
  wallList = new ArrayList();
  graph = new ArrayList();
  deadManList = new ArrayList();
  createWallBlock();
  for(int i=0; i<Length;i++){
    for(int j=0;j<Length;j++){
      Normal[i][j] =0;
      MAP[i][j] = 0;
      for(int k=0; k<wallList.size();k++){
        Wall wall = (Wall)wallList.get(k);
       if(wall.inWall(i,j)) {
         Normal[i][j] = wall.n;
         MAP[i][j] = BLOCK;
         break;
       }
      }
    }
  }
  
  for(int i=0; i < Max_Human; i++)
     HumanList[i] = createHuman(i);
}

Human createHuman(int i){
  int k = (int)random(100)<notSick ? HEALTH : SICK;
  int x;
  int y;
  do{
    x = int(random(Length));
    y = int(random(Length));
  }while(MAP[x][y] != 0);
  MAP[x][y] = k;
  int vx = (2*(int)random(2)-1)*((int)random(2)+1); //-2,-1,1,2
  int vy = (2*(int)random(2)-1)*((int)random(2)+1);
  return new Human(i,k,x,y,vx,vy);
}

void drawWall(){
 fill(0,255,0);
 stroke(0,255,0);
 for(int i=0; i<wallList.size(); i++){
   Wall wall = (Wall)wallList.get(i);
   wall.draw();
 }
}

void drawGraph(){
  stroke(255,255,255);
  fill(255,255,255);
  int ox = 150, oy = height-30;
  line(ox, oy, ox, Length);
  line(ox, oy, ox+300, oy);
  line(ox-5,oy-50, ox+5,oy-50);
  line(ox-5,oy-100, ox+5,oy-100);
  text("Max", ox-30, oy-95);  
  for(int i=0; i<=300;i+=50){
    line(ox+i,oy-5, ox+i,oy+5);
    text(max(i, time-300+i),ox+i-10, oy+20);
  }

  float a = 100.0/Max_Human;
  stroke(0,0,255);
  for(int i=0; i<graph.size()-2; i+=2){
    line(ox+i/2,oy-a*(Integer)graph.get(i), ox+i/2+1,oy-a*(Integer)graph.get(i+2));
  }
  stroke(255,0,0);
  for(int i=1; i<graph.size()-1; i+=2){
    line(ox+i/2,oy-a*(Integer)graph.get(i), ox+i/2+1,oy-a*(Integer)graph.get(i+2));
  }
}
//メインループ
void draw() {
  if(stop) return;
 background(0);
 time++;
 
 drawWall(); 
 countPeople();  //count normal and sickness
 drawGraph();
 
 if((time%bornTime) == 0) born();
 
 //人間を描画
 for(int j=0; j < Max_Human; j++){
     HumanList[j].draw();
  }
  //人間同士の衝突判定
  for(int j=0; j < Max_Human; j++){
     HumanList[j].coll();
  }
  //人間を動かす
  for(int j=0; j < Max_Human; j++){
     HumanList[j].drive();
  }
  
}

void countPeople(){
  normal_number = 0;
  sick_number = 0;
  for(int j=0; j < Max_Human; j++){  
    if(HumanList[j].condition == HEALTH){
      normal_number++;
    }
    else if(HumanList[j].condition == SICK){
      sick_number++;
    }
  }

  graph.add(normal_number);
  graph.add(sick_number); 
  if(graph.size() > 600){ graph.remove(0); graph.remove(0);}
  
  fill(255, 255, 255);
  text("Time= " + time  , 30, 530);
  text("normal=" + normal_number , 30,550);
  text( "sickness=" + sick_number , 30,570);
  text("dead="+dead_number, 30, 590);
  
  if(time > 1000 || sick_number == 0){
    println("("+holeSize+") " + normal_number+" "+sick_number+" "+dead_number);
    holeSize+=10;
    initSetup();
  }
}



int normalX(int x, int y, int vel){
  int _x = min(Length-1, max(0, x));
  int _y = min(Length-1, max(0, y));
 if((Normal[_x][_y]&WallX) == WallX) 
   return -vel;
 else 
   return vel;
}

int normalY(int x, int y, int vel){
  int _x = min(Length-1,max(0, x));
  int _y = min(Length-1,max(0, y));
  if((Normal[_x][_y]&WallY) == WallY) 
   return -vel;
  else 
   return vel;
}
//人間のクラスを定義
class Human
{
  int id;
  int xpos; //x座標
  int ypos; //y座標
  int xvel; //x方向の速さ
  int yvel; //y方向の速さ
  int condition; //健康かそれとも病気かのパラメータ
  int sickTime;
  Human(int i, int c, int xp, int yp, int xv, int yv) {
    id = i;
    sickTime = 0;
    xpos = xp;
    ypos = yp;
    xvel = xv;
    yvel = yv;
    condition = c;
  }

 //もし健康ならば青、病気ならば赤を描画
  void draw () {
    if(condition==HEALTH){
      fill(0,0,255);
      stroke(0,0,255);
      ellipse(xpos,ypos,4,4);
    }
    else if(condition==SICK){
      fill(255,0,0);
      stroke(255,0,0);
      ellipse(xpos,ypos,4,4);
    }
  }

  void drive () {
    if(condition == DEATH)  return;    
    
    if(condition==SICK){
      sickTime++;
     if(random(deadP) < 1){
       condition = DEATH;
       deadManList.add(id);
       dead_number++;
     }
     else if(sickTime > cureTime){
      condition = HEALTH;
     }
    }
    
    MAP[xpos][ypos] = 0;
    xpos = (xpos + xvel + Length) % Length;
    ypos = (ypos + yvel + Length) % Length;
    MAP[xpos][ypos] = condition;
  }
 
  //衝突判定を行う部分
  void coll () {
    if(condition == DEATH) return;    
    for(int i = -2; i < 3; i++){
      for(int j = -2; j < 3; j++){
        if(i==0 && j==0) continue;
        int nx = xpos+i, ny = ypos+j; 
        if ( map(nx,ny)==SICK || map(nx,ny)==HEALTH){
          xvel = (2*(int)random(2)-1)*((int)random(2)+1);
          yvel = (2*(int)random(2)-1)*((int)random(2)+1);
          if( map(nx,ny) == SICK){ condition = SICK; sickTime = 0;}
        }
      }
    }
    //collision wall
    xvel = normalX(xpos+xvel,ypos+yvel, xvel);
    yvel = normalY(xpos+xvel,ypos+yvel, yvel);      
  }
  
}
int map(int x, int y){
 return MAP[(x+Length)%Length][(y+Length)%Length];
}

void born(){
  if(deadManList.size() == 0) return;
  int id = (Integer)deadManList.get(0);
  deadManList.remove(0);
  HumanList[id] = createHuman(id);
}

void mousePressed() {
 saveFrame("sample_4.png"); 
}


