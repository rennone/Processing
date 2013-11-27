int sx, sy; //2次元セルを管理する縦と横の長さ
float density = 0.5; //初期状態の密度 
int[][][] world; //各セルを管理する配列
int time=0;
int[][] field;

//初期化部
void setup() 
{ 
  size(200, 200); //描画窓は200x200
  frameRate(6); //フレームレートは12
  sx = width; //2次元セルの管理配列の横の長さ
  sy = height; //2次元セルの管理配列の縦の長さ
 
  //sx * sy の大きさの配列を2つ準備
  //ここで、1つめは現在の世代、2つめは次の世代を保管するために使う
  world = new int[sx][sy][2];
  field = new int[sx][sy];
  
  stroke(255);   //点の色は白
   
  //初期化 sx * sy * densityの分だけ、生きているセルにセット
  for (int i = 0; i < sx * sy * density; i++) { 
    world[(int)random(sx)][(int)random(sy)][1] = 1; 
  } 

} 
 
 //メインループ
void draw() 
{ 
  background(0); //背景を黒にセット
  
  //描画ループ
  //world[x][y][1]の状態を初期化しながら
  //world[x][y][0]にworld[x][y][1]の状態をコピー
  for (int x = 0; x < sx; x=x+1) { 
    for (int y = 0; y < sy; y=y+1) { 
      if(world[x][y][1]==1) {
        point(x,y);
      }
       world[x][y][0]=world[x][y][1];
    } 
  } 
  
  // 各セルの生死判定　
  for (int x = 0; x < sx; x=x+1) { 
    for (int y = 0; y < sy; y=y+1) {
      //rule(x,y);
      rule3(x,y);
    } 
  }
  if(time++ > 400) exit();
  saveFrame("rule3/" + nf(time,4) + ".png");
} 

void rule(int x, int y){
//周囲のセルの生死状態をカウントする
  int count = neighbors(x, y); 
  //もし自分自身が死んでいて、周囲のセル3つが生きていたら復活する     
  if(count == 3 && world[x][y][0] == 0){ 
        world[x][y][1] = 1; 
  } 
  else if((count < 2 || count > 3) && world[x][y][0] == 1) { 
       //もし自分自身が生きていて、周囲のセルが1個以下、あるいは4個以上の
      //場合は、自分は死ぬ
        world[x][y][1] = 0; 
  }
}

void rule3(int x, int y){
 int cnt = neighbors(x,y);
 if((int)random(8) < cnt){
   world[x][y][1] = 1; 
 }
 else{
  world[x][y][1] = 0; 
 }
 
}

void rule2(int x, int y){
 int cnt = neighbors(x,y);
 if(4 < cnt){
   world[x][y][1] = 1; 
 }
 if(cnt < 4){
  world[x][y][1] = 0; 
 }
 
}

int neighborsInt(int x, int y){
 int sum = 0;
 for(int i=x-1; i<=x+1;i++){
  for(int j=y-1; j<=y+1; j++){
    sum = (sum<<1) + World(i,j);
  }
 }
 return sum;
}

//周囲のセルの生死を判定する関数
int neighbors(int x, int y) 
{
  return world[(x + 1) % sx][y][0] + 
         world[x][(y + 1) % sy][0] + 
         world[(x + sx - 1) % sx][y][0] + 
         world[x][(y + sy - 1) % sy][0] + 
         world[(x + 1) % sx][(y + 1) % sy][0] + 
         world[(x + sx - 1) % sx][(y + 1) % sy][0] + 
         world[(x + sx - 1) % sx][(y + sy - 1) % sy][0] + 
         world[(x + 1) % sx][(y + sy - 1) % sy][0]; 
} 

int bitCount(int bits)
{
    bits = (bits & 0x55555555) + (bits >> 1 & 0x55555555);
    bits = (bits & 0x33333333) + (bits >> 2 & 0x33333333);
    bits = (bits & 0x0f0f0f0f) + (bits >> 4 & 0x0f0f0f0f);
    bits = (bits & 0x00ff00ff) + (bits >> 8 & 0x00ff00ff);
    return ((bits & 0x0000ffff) + (bits >>16 & 0x0000ffff));
}

int World(int x, int y){
 return world[(x+sx)%sx][(y+sy)%sy][0]; 
}
