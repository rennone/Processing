int sx, sy; //2次元セルを管理する縦と横の長さ
float density = 60, Ddensity = 5; //木の存在確率 
float moe = 100; //
int[][][] world; //各セルを管理する配列
int survivor = 0;
int prev;
int percolation;
int MaxNum = 100;
int time;
boolean[][] check;
int cellSize = 1;
boolean stop = false;
PImage img;
int dx[] = {1,0,-1,0};
int dy[] = {0,1,0,-1};
int turn = 0;
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
  size(500,500); //描画窓は300x300
  frameRate(200); //フレームレートは10
  sx = width/cellSize; //2次元セルの管理配列の横の長さ
  sy = height/cellSize; //2次元セルの管理配列の縦の長さ
  img = createImage(sx,sy,RGB);
   //sx * sy の大きさの配列を2つ準備
   //ここで、1つめは現在の世代、2つめは次の世代を保管するために使う
  world = new int[sx][sy][2];
  check = new boolean[sx][sy];
  percolation = 0;
  time = 0;
  turn = 0;
  for(int i = 0; i < sx; i++){
     for(int j = 0; j < sy; j++){
       //木の存在確率よりも小さければ木を植える
       //大きければ木は存在しない
      if(random(10000) < density*100){
        world[i][j][turn] = 1; 
        survivor++;
      }
     else{
       world[i][j][turn] = 0;  
     }
    }
  }
  prev = survivor;
  //任意の3点から火事を起こす
  for(int i = 0; i < 3; i++){
    world[(int)random(sx)][(int)random(sy)][turn] = 2; 
  }  
} 

void restart(){
  if(++time >= MaxNum){
    println(density + " " + 100.0*percolation/MaxNum ) ;
    percolation = 0;
    density+=Ddensity;
    if(density > 90) exit();
    time=0;
  }
  survivor=0;
  for(int i = 0; i < sx; i++){
    for(int j = 0; j < sy; j++){
      if(random(10000) < density * 100){
        world[i][j][turn] = 1;
        survivor++;
      }
      else{
        world[i][j][turn] = 0;
      }
    }
  }
  prev = survivor;
  //任意の3点から火事を起こす
  for(int i = 0; i < 3; i++){
    int x =(int)random(sx);
    int y =  (int)random(sy);
    world[x][y][turn] = 2;
  } 
}
 
 //メインループ
void draw() 
{ 
  background(0); //背景を黒にセット
  
  img.loadPixels();
  for (int x = 0; x < sx; x=x+1) { 
    for (int y = 0; y < sy; y=y+1) { 
      if (world[x][y][turn] == -1) 
        img.pixels[x + y*sx] = color(200,200,200);        //木が燃え尽きていれば灰色をプロット
      else if (world[x][y][turn] == 1) 
        img.pixels[x + y*sx] = color(0,255,0);
      else if (world[x][y][turn] == 2) 
        img.pixels[x + y*sx] = color(255,0,0);
      else
        img.pixels[x + y*sx] = color(0,0,0);  
    } 
  }
  img.updatePixels(); //applicate change
  image(img,0,0,width,height);
  stroke(255,255,255);
  text(survivor, 0, height);
  if(stop) return;
  calc();
}


void calc()
{
   prev = survivor;
   simulate();
  if(Percolate()){
    saveFrame("Image/"+density + "-" + time+".png");
    percolation++;
    restart();
  }
  else if(survivor == prev) {
     saveFrame("Image/"+density + "-" + time+".png");
     restart();
  }
}

void simulate(){
  // 各木の生死判定　
  for (int x = 0; x < sx; x=x+1) { 
    for (int y = 0; y < sy; y=y+1) { 
      int count = neighbors(x, y); 

      if ((count > 0) && world[x][y][turn] == 1) { 
        float r = random(100);
        if(moe > r){
          world[x][y][(turn+1)%2] = 2;
          survivor--;
        }
        else{
          world[x][y][(turn+1)%2] = 1;
        }
      } 
      else if (world[x][y][turn] == 2){ 
        world[x][y][(turn+1)%2] = -1;       //もし自分自身が燃えていたら、死ぬ
      }
      else{
       world[x][y][(turn+1)%2] = world[x][y][turn]; 
      }
    } 
 }
 turn = (turn+1)%2;
}
//周囲の木の燃え具合を判定する関数
//周囲4方向で燃えている木が1本でもあれば
//1以上の値を返す

int neighbors(int x, int y) 
{ 
  int i = 0;
  
  if(world[(x + 1) % sx][y][turn] == 2){
    i++;
  }
  if(world[x][(y + 1) % sy][turn] == 2){
    i++;
  }
  if(world[(x + sx - 1) % sx][y][turn] == 2){
    i++;
  }
 if(world[x][(y + sy - 1) % sy][turn] == 2){
   i++;
 }
 return i;
} 

ArrayList stack;
boolean Percolate(){

 clearCheck();
 boolean perc = false;
 stack = new ArrayList();
 for(int i=0; i<sx; i++){
  if(world[i][0][turn] == -1) stack.add(new Point(i,0)); 
 }
 if(search(0)) return true;
 
 clearCheck();
 stack = new ArrayList();
 for(int i=0; i<sy; i++){
  if(world[0][i][turn] == -1) stack.add(new Point(0,i)); 
 }
 if(search(1)) return true;
 return false;
}

//d : horizonal or vertical 
boolean search(int d){
 while(stack.size() != 0){
  Point p = (Point)stack.get(stack.size()-1);
  stack.remove(stack.size()-1);
  if(d == 0 && p.y==sy-1) return true;
  if(d == 1 && p.x== sx-1) return true;
  if(p.x<0 || p.x>=sx || p.y<0 || p.y>=sy || check[p.x][p.y] || world[p.x][p.y][turn] != -1) continue;
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

void clearCheck(){
 for(int i=0; i<sx; i++)
  for(int j=0;j<sy;j++)
    check[i][j] = false; 
}

void mousePressed(){
  stop = !stop; 
}


