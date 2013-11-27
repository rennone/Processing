import java.util.*;

final int W=0, S=1, G=2, L=3;
final color CellColor[] = {color(150,150,150), color(0,0,150),
                           color(150,0,0),  color(0,0,0) };
final String[] CellName = {"Wall", "Start", "Goal", "Load"};
final int MAPSIZE = 400, miniMAPISZE = MAPSIZE/5;
final int left=50,top=50;
final int[] dx = {0, -1, 0, 1, 0};
final int[] dy = {-1, 0, 1, 0, 0};

int SIZE, CELL, miniCELL;
int start,goal;
int[][] Map;
int select=W;
boolean gameStart=false;
Player player;

void setup(){
  size(800,600);
  SIZE = 8;
  CELL = MAPSIZE/SIZE;
  miniCELL = CELL/5;
  reset();
}

void reset(){
  gameStart=false;
  Map = new int[SIZE][SIZE];
  for(int i=1; i<SIZE-1;i++){
    for(int j=1; j<SIZE-1;j++){
      Map[i][j] = L;
    }
  }
  start = (1<<4)|1;
  goal = ((SIZE-2)<<4)|(SIZE-2);
  Map[start>>4][start&0xF] = S;
  Map[goal>>4][goal&0xF] = G;
}

void draw(){
  background(0);
  stroke(255);
  for(int i=0; i<SIZE; i++){
    for(int j=0; j<SIZE; j++){
      fill(CellColor[Map[i][j]]);
      stroke(255);
      rect(i*CELL+left, j*CELL+top, CELL,CELL);
      fill(255,255,0);
    }
  }
  if(gameStart){
    player.draw();
    player.calc();    
  }
  else{
    drawBlockButton();
    drawStButton();
  }
}

void drawBlockButton(){
  fill(255,255,0);
  rect(select*(CELL+10)+left-5, (SIZE+1)*CELL+top-5, CELL+10,CELL+10);
  for(int i=0; i<4; i++){
    fill(CellColor[i]);
    stroke(255);
    rect(i*(CELL+10)+left, (SIZE+1)*CELL+top, CELL,CELL);
    textSize(16); fill(255);
    text(CellName[i], i*(CELL+10)+left, (SIZE+2)*CELL+top);
  }
}

void drawStButton(){
  fill(255,0,0);
  rect(width-150, height-80, 80,20);
  fill(255);
  textSize(16);
  text("Start", width-125, height-65); 
}

void mousePressed(){
  if(gameStart) return;
  changeStGl();
  changeMap();
  changeSelect();
  clickStart();
  saveFrame("aaa.png");
}

void mouseDragged(){
  if(gameStart) return;
  changeMap();
}

void changeSelect(){
  int i = (mouseX-left)/(CELL+10);
  int j = (mouseY-top-(SIZE+1)*CELL)/CELL; 
  if(i<0 || i>=4 || j!=0) return;
  select = i;
}

void changeStGl(){
  int i = (mouseX-left)/CELL;
  int j = (mouseY-top)/CELL; 
  if(!inMap(i,j)) return;
  if(start == (i<<4|j)) select = S;
  else if(goal == (i<<4|j))select = G; 
}

void changeMap(){
  int i = (mouseX-left)/CELL;
  int j = (mouseY-top)/CELL; 
  if(i<0 || i>=SIZE || j<0 || j>=SIZE) return;
  Map[i][j] = select;
  int cel = (i<<4)|j;
  Map[start>>4][start&0xF] = L;
  Map[goal>>4][goal&0xF] = L;
  if(select==S)   start = cel;
  else if(select==G)   goal=cel;
  Map[start>>4][start&0xF] = S;
  Map[goal>>4][goal&0xF] = G;
}

void clickStart(){
 if(mouseX < width-150 || mouseX>width-70 || mouseY<height-80 || mouseY>height-55) return;
 gameStart=true;
 frameRate(5);
 player = new optPlayer(start>>4, start&0xF);
 //player = new miniPlayer(start>>4, start&0xF);
}

abstract class Player{
  int x,y;
  Player(int _x, int _y){
    x=_x;
    y=_y;
  }
  abstract void draw();
  abstract void calc();  
}

class miniPlayer extends Player{
 int[][] myMap;
 float[][] myValue;
 boolean[][] visited;
 final float[] CellVal={0.0f, 5.0f, 20.0f, 5.0f};
 final float[] CellR = {-1.0f, 1.0f, 10.0f, 1.0f};
 miniPlayer(int _x, int _y){
  super(_x,_y);
  myMap = new int[SIZE][SIZE];
  myValue = new float[SIZE][SIZE];
  visited = new boolean[SIZE][SIZE];
  for(int i=0;i<SIZE;i++){
    for(int j=0;j<SIZE;j++){
      myMap[i][j] = -1;
      myValue[i][j] = 1.0f;
    }
  }
 }
 
 void draw(){
   fill(255,255,0);
   ellipse( (x+0.5)*CELL+left, (y+0.5)*CELL+top, CELL/2, CELL/2);
   for(int i=0; i<SIZE; i++){
     for(int j=0; j<SIZE; j++){
       if(myMap[i][j] < 0) continue;
       fill(CellColor[myMap[i][j]]);
       stroke(255);
       rect(i*miniCELL+left+500, j*miniCELL+top, miniCELL,miniCELL);
       fill(255);
       //text(myValue[i][j], i*CELL + left, j*CELL+top + 0.5*CELL);
     }
   }
 }
 
 void calc(){
   if(goal == (x<<4|y)) reset();
   visited[x][y] = true;
   updateMap();
   float maxval = -MAX_FLOAT;
   int dir = 4;
   for(int i=0; i<4; i++){
     int nx = x+dx[i];
     int ny = y+dy[i];
     if(!inMap(nx,ny) || Map[nx][ny]==W) continue;
     if(myValue[nx][ny]>maxval){
      dir = i;
      maxval = myValue[nx][ny];
     }
   }
   x+=dx[dir];
   y+=dy[dir];
 }
 
 void updateMap(){
   search();
   myValue[x][y] = -10;
   float alpha = 0.1, gamma = 0.9;
   for(int i=0; i<SIZE;i++){
     for(int j=0; j<SIZE;j++){
       if(myMap[i][j] == W)continue;
       gamma = int(myValue[i][j]>=-2)*0.1;
       for(int k=0; k<4; k++){
         int nx = i+dx[k];
         int ny = j+dy[k];
         if(!inMap(nx,ny)) continue;
         float r = myMap[nx][ny] < 0 ? 5 : CellR[myMap[nx][ny]];
         float c = myMap[nx][ny] < 0 ? 5 : CellVal[myMap[nx][ny]];
         myValue[i][j] = (1-alpha)*myValue[i][j] + alpha*( r + gamma*(myValue[nx][ny] + c));
       }
       if(!visited[i][j]) myValue[i][j] += 10;
     }
   }
 }
 
 void search(){
   //myMap[x][y] |= 0x10;  //search check
   for(int i=-2; i<3;i++){
     for(int j=-2; j<3;j++){
       int nx = x+i;
       int ny = y+j;
       if(inMap(nx, ny) && myMap[nx][ny]<0) {
         myMap[nx][ny]   =  Map[nx][ny];
         myValue[nx][ny] = CellVal[Map[nx][ny]];
       }
     } 
   }
 }

}

class optPlayer extends Player{
  ArrayList myRoute;
 optPlayer(int _x, int _y){
  super(_x,_y);
  myRoute = new ArrayList();
  dfs();
 }
 
 void draw(){
  fill(255,255,0);
  ellipse( (x+0.5)*CELL+left, (y+0.5)*CELL+top, CELL/2, CELL/2);
  for(int i=0; i<myRoute.size(); i++){
    int nx = (Integer)(myRoute.get(i))>>4;
    int ny = (Integer)(myRoute.get(i))&0x0F;
    fill(0,255,0);
    ellipse(CELL*(nx+0.5)+left,CELL*(ny+0.5)+top,10,10);
  }
 }
 
 void calc(){
   if(goal == (x<<4|y)) reset();
   if(myRoute.size()==0) return;
   int cell = (Integer)myRoute.get(myRoute.size()-1);
   x = cell>>4;
   y = cell&0x0F;
   myRoute.remove(myRoute.size()-1);
 }
 
 void dfs(){
   int[][] checked = new int[SIZE][SIZE];
   for(int i=0; i<SIZE;i++){
     for(int j=0; j<SIZE; j++){
       checked[i][j] = -1;
     }
   }
   ArrayList next = new ArrayList();
   next.add(start);
   checked[start>>4][start&0x0F] = -1;
   while(next.size() !=0 ){
    ArrayList stack = new ArrayList(next);
    next.clear();
    for(int i=stack.size()-1;i>=0;i--){
      int cell = (Integer)stack.get(i);  
      for(int j=0;j<4;j++){
        int nx = (cell>>4)+dx[j];
        int ny = (cell&0x0F) + dy[j];
        if(!inMap(nx,ny) || Map[nx][ny] == W || checked[nx][ny] !=-1) continue;
        checked[nx][ny] = cell;
        next.add((nx<<4)|ny);
      }
    }
  }
  
  int prev = goal;
  while(prev != start){
   if(prev < 0) {reset(); return;}
   myRoute.add(prev);    
   prev = checked[prev>>4][prev&0x0F]; 
  }
 }

}

boolean inMap(int i, int j){
 return i>=0 && i<SIZE && j>=0 && j<SIZE; 
}

