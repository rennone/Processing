//交通シミュレータ「ながれさん」プログラム
// 追い越しができるバージョン

int Length = 800; //道路の長さ 800画素に設定
int Max_Car = 10; //Max_Carに設定した台数が走るようになる
int Max_Traffic = 5; //Max_Carに設定した台数が走るようになる
int LaneY1 = 30, LaneY0=65;
int[][] X = new int[Length][2]; //道路状況を管理する配列
int[] T = new int[Length];
int[] F = new int[Length]; //road condition
int sag_st = 400, sag_end = 600;
Car[] myCar = new Car[Max_Car]; //車のクラスを定義
TrafficLight[] myTraffic = new TrafficLight[Max_Traffic];
final int RED = 2, YELLOW=1, GREEN = 0;
final int SLOW_SPEED = -2;
color RedCar = color(255,0,0), BlueCar = color(0,0,255);

void setup() {
  size(Length,100); //Length x 100 の窓を準備
  background(0); 
  
  frameRate(20); //フレームレートは20くらいに設定すると滑らか。私のパソコンでは

  //車を初期設定
  //追い越しありの場合、自分の走っているレーンの状態も管理します

   myCar[0] = new Car(RedCar,0, LaneY0,6,3, 0);
   myCar[1] = new Car(RedCar,0, LaneY1,5,3, 1);
  for(int i=2; i < Max_Car; i++){
    //各車ごとに、色をランダムに塗りましょう
    int k4 = int(random(5)+1); //Max_speed
    int k5 = int(random(3)+1); //現在のスピード
    int k6 = 0; // 0は右レーン、1は左レーン
    //車の初期位置をセット。まずは等間隔にならべましょう。
    myCar[i] = new Car(BlueCar,Length/Max_Car*i,LaneY0,k4,k5,k6);
  }

  for(int i=0; i<Max_Traffic;i++){
    myTraffic[i] = new TrafficLight(i*100+100);
  }
  //道路を管理する配列を初期化
  //2レーン分、管理しないといけません。
  for(int i=0; i< Length; i++){
    X[i][0] = 0;
    X[i][1] = 0;
    T[i] = 0;
    F[i] = (sag_st < i && i < sag_end) ? SLOW_SPEED : 0;
  }
}



//メインループ
void draw() {
  background(0); //画面を真っ黒に塗りつぶす
  draw_background(); //道路を描画
    
 //各車を描画、制御する
 for(int j=0; j < Max_Car; j++){
   myCar[j].draw(); //車を描画する

   if(myCar[j].change==0){
     myCar[j].drive(); //アクセルペダルの制御関数を呼び出し
   }
   myCar[j].move(); //レーンチェンジを開始
 }
 
 for(int i=0; i< Max_Traffic;i++){
    myTraffic[i].draw(); 
    myTraffic[i].next();
  }
  
  //道路を管理する配列をきれいに
  for(int i=0; i< Length; i++){
    X[i][0] = 0;
    X[i][1] = 0;
    T[i] = GREEN;
  }
  
  //もう一度、自分の位置をしっかり書き込みましょう。
  for(int i=0; i< Max_Car; i++){
      X[((myCar[i].xpos + width) % width)][myCar[i].lane] = 1;
  }
  
  for(int i=0; i<Max_Traffic; i++){
   T[(myTraffic[i].xpos + width)%width] = myTraffic[i].col;
  }
  
  fill(255,0,0);
  text("car1: " + myCar[0].run, 0,   90);
  fill(0,255,0);
  text("car2: " + myCar[1].run, 100, 90);
}



//車のクラスを定義
class Car
{
  color c; //車の色
  int xpos; //現在のx座標
  int ypos; //現在のy座標
  int Max_Speed;
  int xvel; //x方向へのスピード（現在は1次元なので車のスピードに相当）
  int lane; //現在のレーンの状態
  int change; //レーンチェンジの状態
  int run=0;
  
  Car(color c_, int xp, int yp, int mx, int xv, int l) {
    c = c_;
    xpos = xp;
    ypos = yp;
    Max_Speed = mx;
    xvel = xv;
    lane = l;
  }

  //車を描画する関数
  void draw () {
    stroke(0);
    fill(c); //各車の色をセット
    rect(xpos-7,ypos,15,10); //車のボディを書く
    stroke(0);
    fill(255); //車の天井部を白に塗る
    rect(xpos+2-7,ypos+2,5,6);
    
    //タイヤを描画する
    fill(0);
    rect(xpos+2-7,ypos-2,4,2);
    rect(xpos+8-7,ypos-2,4,2);
    rect(xpos+2-7,ypos+10,4,2);
    rect(xpos+8-7,ypos+10,4,2);
  }


  //アクセルペダルの制御関数
  void drive () {
      //前方をチェックするルーチン
      for(int i=xpos+1; i<xpos+15;i++){
        if(X[(i + width) % width][lane] >= 1){
         xvel=0; return; 
        }
      }
      
      int k = 0;
      for(int i = xpos + 15; i < xpos + 30; i++){
        if(T[(i+width)%width] == RED) { 
          xvel = max(0, min((i-xpos-15)/2, xvel-2)); //ブレーキをふむと 2速度が減少
          return;
        }
        if(X[(i+width) % width][lane] >= 1){
          lane_ch(i-xpos-15); //change lane if there are cars in front
          return;
        }
      }
      
     int maxSp = max(Max_Speed+F[xpos], 1);
      xvel = min(maxSp, xvel + 2); //アクセルを踏むとスピードが2上がる
  }
  
  void move(){
    run += xvel;
    if(change == 0){
      X[xpos][lane] = 0;
      xpos = (xpos + xvel) % width; //車の位置を移動
      X[xpos][lane] = 1;   //車の位置を道路管理配列に書き込む
      return;
    }
    else{
      X[xpos][lane] = 0;
      X[xpos][(lane+1)%2] &= 0x1;
      xpos = (xpos + xvel) % width; //車の位置を移動
      X[xpos][lane] = 1;   //車の位置を道路管理配列に書き込む
      X[xpos][(lane+1)%2] |= 0x2;
    }

   int yvel = (2*lane-1)*3;
   ypos += yvel;
   if(lane==0 && ypos<LaneY1){
     change=0; ypos = LaneY1;
     lane = 1;    
     X[xpos][0] = 0;
     X[xpos][1] = 1;
   }
   if(lane==1 && ypos>LaneY0){
    change=0; ypos=LaneY0; 
    lane = 0;         
    X[xpos][0] = 1;
    X[xpos][1] = 0;
   }
  }
  
  //追い越し（レーンチェンジ）を制御する関数
  void lane_ch(int dis){
    for(int i = xpos -50; i < xpos + 50; i++){
       if(X[(i+width)%width][(lane+1)%2] >= 1 || T[(i+width)%width] == RED ){
         xvel = max(0, min(dis/2, xvel-2)); //ブレーキをふむと 2速度が減少
         return;
       }
    }
    change = 1;
    return;
  }
  
    //ブレーキペダルの制御関する
  void breaking (int dis){
    xvel = max(0, min(dis/2, xvel-2)); //ブレーキをふむと 2速度が減少
  }
}


class TrafficLight{
  int col; //color
  int xpos; //現在のx座標
  int ypos; //現在のy座標
  int hei = 39;
  int wid = 10;
  int cycle;
  int timer;
  TrafficLight(int _x)
  {
    cycle = (int)random(500)+300;
    timer = (int)random(cycle);
    next();
    xpos = _x;
    ypos = 31;
  }
  
  void draw(){
    int a, b, c;
    a=b=c= color(0,0,0);
    if(col==GREEN) a = color(0,255,0);
    if(col==YELLOW) b = color(255,255,0);
    if(col==RED) c = color(2555,0,0);
    stroke(0);
    fill(color(200,200,200));
    rect(xpos, ypos, wid, hei);
    ellipseMode(CORNER);
    fill(a); //各車の色をセット
    ellipse(xpos, ypos+1, wid, wid);
    fill(b); //各車の色をセット
    ellipse(xpos, ypos+14, wid, wid);
    fill(c); //各車の色をセット
    ellipse(xpos, ypos+27, wid, wid);
  }
  
  void next(){
    timer = (timer+1)%cycle;
    if(timer < 0.45*cycle) col = GREEN;
    if(0.45*cycle <= timer && timer < 0.55*cycle) col=YELLOW;
    if(0.55*cycle <= timer) col=RED;
  }
};

//背景を描画する
void draw_background(){
  noStroke();
  
  //道路を描画
  fill(150,150,150);
  rect(0,10,Length,80);

  fill(50,150,150);
  rect(sag_st, 10, sag_end-sag_st, 80);
    
  //中央線を描画
  for(int j=0; j < 40; j++){
    fill(255,255,255);
    rect(0+j*20,50,15,2);
  }
 
}
 
 
void mousePressed() {
 saveFrame("sample_1.png"); 
}
