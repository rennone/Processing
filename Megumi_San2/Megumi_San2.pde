
int sx, sy; 
float density = 65; //木の存在確率 
float moe = 100; //
int[][][] world; //各セルを管理する配列
int survivor = 0;
int prev;
int percolation;
int MaxNum = 10;
int time;
boolean[][] check;
int cellSize = 5;
boolean stop = false;
int wind, windPower;
int SOLID = 0, FIRE = 1, ASH = 2, A_WOOD = 3,B_WOOD = 4, C_WOOD = 5, D_WOOD = 6;
color wood_c[] = {color(255,50,50),
                  color(255,0,0),
                  color(150,150,150),
                  color(0,255,0),
                  color(200, 170, 0),
                  color(0,150,180),
                  color(255,255,255) };
int w_dx[] = {0, -1, 0, 0, 1, -1,  1, -1, 1};
int w_dy[] = {0, 0, -1, 1, 0, -1, -1,  1, 1};

int turn;
class Point{
 int x, y; 
 Point(int _x, int _y){
   x = _x;
   y = _y;
 }
}

//初期化部
void setup() 
{
  size(500, 500); //描画窓は300x300
  frameRate(30); //フレームレートは10
  sx = width/cellSize; //2次元セルの管理配列の横の長さ
  sy = height/cellSize; //2次元セルの管理配列の縦の長さ

  world = new int[sx][sy][2];
  check = new boolean[sx][sy];
  percolation = 0;
  time = 0;
  turn = 0;
  setField();
}

void setField(){
  setWind();
  survivor=0;
  for(int i = 0; i < sx; i++){
    for(int j = 0; j < sy; j++){
      if(random(10000) < density * 100){
        world[i][j][turn] = createTree();
        survivor++;
      }
     else{
       world[i][j][turn] = SOLID;  
     }
    }
  }
  prev = survivor;
  for(int i = 0; i < 3; i++){
    world[(int)random(sx)][(int)random(sy)][turn] = FIRE; 
  }  
}

int createTree(){
  int r = (int)random(3000);
  if(r < 2500) return A_WOOD;
  else if(r < 2750) return B_WOOD;
  else if(r < 2950)return C_WOOD;
  else return D_WOOD;
}

void restart(){
  if(++time >= MaxNum){
    println(density + " " + 100.0*percolation/MaxNum ) ;
    percolation = 0;
    density+=10;
    if(density > 90) exit();
    time=0;
  }
  setField();
}

 //メインループ
void draw() 
{ 
  background(0); //背景を黒にセット
  
 for (int x = 0; x < sx; x=x+1) { 
    for (int y = 0; y < sy; y=y+1) {   
      if ( World(x,y) != SOLID)
        drawTree(x,y);
    }
  } 
  
   stroke(255,255,255);
   drawWind();
   if(stop) return;
   calc();
}
void drawWind(){
  fill(255,0,255);
  int s = 25;
  triangle(50-15*windPower*w_dx[wind], 50-15*windPower*w_dy[wind], 
           50+ 3*windPower*w_dy[wind], 50- 3*windPower*w_dx[wind],
           50- 3*windPower*w_dy[wind], 50+ 3*windPower*w_dx[wind]);
}

void drawTree(int x, int y){
  stroke(wood_c[World(x,y)]);
  point(x*cellSize+2, y*cellSize);
  line(x*cellSize+1, y*cellSize+1, x*cellSize+3, y*cellSize+1);
  line(x*cellSize+1, y*cellSize+2, x*cellSize+3, y*cellSize+2);
  line(x*cellSize, y*cellSize+3, x*cellSize+4, y*cellSize+3);
  point(x*cellSize+2, y*cellSize+4);  
}

void setWind(){
  wind = (int)random(9);
  windPower = (int)random(3)+1; 
}
void calc()
{
   prev = survivor;
   simulate();
  if(random(100) < 4){
    setWind();
  }
  
   /*
  if(Percolate()){
     saveFrame("Image/"+density + "-" + time+".png");
    percolation++;
    restart();
  }
  else if(survivor == prev) {
    saveFrame("Image/"+density + "-" + time+".png");
    restart();
  }
  */
}

void simulate(){
  // 各木の生死判定　
  for (int x = 0; x < sx; x=x+1) { 
    for (int y = 0; y < sy; y=y+1) { 
      if (alive(x,y) && burn(x,y)) { 
        if( random(100) < moe){
          world[x][y][(turn+1)%2] = (World(x,y) == C_WOOD ? ASH : FIRE);
          survivor--;
        }
        else{
          world[x][y][(turn+1)%2] = World(x,y);
        }
      }
      else if(World(x,y) == D_WOOD){
        reborn(x,y);
        world[x][y][(turn+1)%2] = World(x,y);
      }
      else if(World(x,y) == FIRE) 
        world[x][y][(turn+1)%2] = ASH;       //もし自分自身が燃えていたら、死ぬ      
      else
       world[x][y][(turn+1)%2] = World(x,y); 
    } 
 }
 turn = (turn+1)%2;  
}

void reborn(int x,int y){
  int i = (int)random(8)+1;
  int nx = (x+sx+w_dx[i])%sx, ny = (y+sy+w_dy[i])%sy;
  if(alive(nx,ny)) return;
  int t = createTree();
  world[nx][ny][turn] = t;
  world[nx][ny][(turn+1)%2] = t;
}

boolean alive(int x, int y){
 return (World(x,y)-ASH > 0); 
}

int World(int x, int y){
 return world[(x+sx)%sx][(y+sy)%sy][turn]; 
}

boolean burn(int x, int y){
 if(World(x,y) == D_WOOD) return false;
 
 int wood = (World(x,y) == B_WOOD ? 5 : 0);
 int count = 0;
 for(int i =0; i<5;i++)
   for(int j=1; j<=windPower; j++)
      count += World(x+w_dx[i] + j*w_dx[wind], y+w_dy[i] + j*w_dy[wind])==FIRE ? 1 : 0;
 return count > wood;
}

int dx[] = {1,0,-1,0};
int dy[] = {0,1,0,-1};
ArrayList stack;
boolean Percolate(){
 clearCheck();
 boolean perc = false;
 stack = new ArrayList();
 for(int i=0; i<sx; i++){
  if(World(i,0) == -1) stack.add(new Point(i,0)); 
 }
 if(search(0)) return true;
 
 clearCheck();
 stack = new ArrayList();
 for(int i=0; i<sy; i++){
  if(World(0,i) == -1) stack.add(new Point(0,i)); 
 }
 if(search(1)) return true;
 return false;
}

void clearCheck(){
 for(int i=0; i<sx; i++)
  for(int j=0;j<sy;j++)
    check[i][j] = false; 
}

boolean search(int d){
 while(stack.size() != 0){
  Point p = (Point)stack.get(stack.size()-1);
  stack.remove(stack.size()-1);
  if(d == 0 && p.y==sy-1) return true;
  if(d == 1 && p.x== sx-1) return true;
  if(p.x<0 || p.x>=sx || p.y<0 || p.y>=sy || check[p.x][p.y] || World(p.x,p.y) != ASH) continue;
  check[p.x][p.y] = true;
  for(int i=0; i<4;i++){
    int x = p.x + dx[i];
    int y = p.y + dy[i];
    if(y<0 || x<0 || x>=sx || y>=sy || check[x][y]) continue;
    stack.add(new Point(x,y));
   }
 }
  return false; 
}

void mousePressed(){
  //stop = !stop; 
  saveFrame(time+".png");
}


