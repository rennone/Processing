//交通シミュレータ「ながれさん」プログラム
//追い抜きなしバージョン
// by Hajime Nobuhara

int Length = 800; //道路の長さ 8000画素に設定
int Max_Car = 10; //Max_Carに設定した台数が走るようになる
int Max_Traffic = 2; //Max_Carに設定した台数が走るようになる
int[] X = new int[Length]; //道路状況を管理する配列 
Car[] myCar = new Car[Max_Car]; //車のクラスを定義
TrafficLight[] myTraffic = new TrafficLight[Max_Traffic];
int RED=4, YELLOW=2, GREEN=0;

void setup() {  color(HSB);
  size(Length,100); // 設定した長さと幅100のウィンドウを作成  
  frameRate(20); //フレームレートは20くらいに設定すると滑らかに見えます。私のパソコンでは。
  
   //車を初期設定
   for(int i=0; i < Max_Car; i++){
    //各車ごとに、色をランダムに塗りましょう
    // k1, k2, k3 は色を指定するパラメータ
    int k1 = int(random(255)); 
    int k2 = int(random(255));
    int k3 = int(random(255));
    int k4 = int(random(3) + 3); //最大速度
    int k5 = int(random(3)+1); //初期スピード
    
    color tempcolor = color(k1,k2,k3);
    //車の初期位置をセット。まずは等間隔にならべましょう。
    myCar[i] = new Car(tempcolor, Length/Max_Car*i,65,k4,k5);
  }  
  
  //道路を管理する配列を初期化
  for(int i=0; i< Length; i++){
    X[i] = 0;
  }
  
  int range = Length/Max_Traffic;
  for(int i=0; i<Max_Traffic;i++){
    myTraffic[i] = new TrafficLight(int(random(range)+i*range));
  }
    
}


//メインループ
void draw() {
  background(0); //画面を真っ黒に塗りつぶす
  
  draw_background(); //道路の描画
    
  //各車を描画、制御する
   for(int j=0; j < Max_Car; j++){
       myCar[j].draw(); //車を描画する
       myCar[j].drive(); //アクセルペダルの制御関数を呼び出し
   }
   for(int i=0; i< Max_Traffic;i++){
    myTraffic[i].draw(); 
    myTraffic[i].next();
   }
   
 }  

//車のクラスを定義
class Car
{
  color c; //車の色
  int xpos; //現在のx座標
  int ypos; //現在のy座標
  int Max_Speed;
  int xvel; //x方向へのスピード（現在は1次元なので車のスピードに相当）
 
  Car(color c_, int xp, int yp, int mx, int xv) {
    c = c_;
    xpos = xp;
    ypos = yp;
    Max_Speed = mx;
    xvel = xv;
  }

  //車を描画する関数
  void draw () {
    stroke(0);
    fill(c); //各車の色をセット
    rect(xpos,ypos,15,10); //車のボディを書く
    stroke(0);
    fill(255); //車の天井部を白に塗る
    rect(xpos+2,ypos+2,5,6);
    
    //タイヤを描画する
    fill(0);
    rect(xpos+2,ypos-2,4,2);
    rect(xpos+8,ypos-2,4,2);
    rect(xpos+2,ypos+10,4,2);
    rect(xpos+8,ypos+10,4,2);
  }


  //アクセルペダルの制御関数
  void drive () {
      //前方15画をチェックするルーチン
      boolean accel = true;
      for(int i = xpos+1; i < xpos + 15; i++){
        int road = X[(i + width) % width];
        if( (road & 0xE) == RED){
          //xvel = 0; return;
        }
        if((road & 1) == 1){
          xvel = 0; return;
        }
      }
      
      for(int i = xpos + 15; i < xpos + 30; i++){
        int road = X[(i + width) % width];
        if( (road & 0xE) == RED){
          xvel = max(0, min(xvel-2, (i-xpos-15)/2));
          accel = false;
          break;
        }
        else if((road & 1) == 1){
          xvel = max(0, min(xvel-2, (i-xpos-15)/2));
          accel = false;
          break;
        }
      }
      
      //もし前方に車があれば、kは0よりも大きくなる
      if(accel) {
        xvel = min(Max_Speed, xvel + 2); //アクセルを踏むとスピードが2上がる
      }
    
      X[xpos] &= 0xE; 

      xpos = (xpos + xvel) % width; //車の位置を移動
      
      X[xpos] |= 1;   //車の位置を道路管理配列に書き込む
  }
    
   
  //ブレーキペダルの制御関する
  void breaking (){
    //前方に車がいるかどうかを判定
    for(int i = xpos + 1; i < xpos + 20; i++){
      //車がいれば、ブレーキをふむ
      if(X[(i+width)%width] == 1){
        xvel = xvel - 2; //ブレーキをふむと 2速度が減少
        if(xvel < 0) xvel = 0;
      }
    }
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
    if(col==RED) c = color(255,0,0);
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
    if(timer < 0.65*cycle) col = GREEN;
    if(0.65*cycle <= timer && timer < 0.75*cycle) col=YELLOW;
    if(0.75*cycle <= timer)   col=RED;
    
    X[xpos] = (X[xpos]&1) | col;
  }
};

//背景を描画する
void draw_background(){
  noStroke();
  
  //道路を描画
  fill(150,150,150);
  rect(0,10,Length,80);
  
  //中央線を描画
   fill(256,52,43);
  rect(0,50,Length,3);
}
 
void mousePressed() {
 saveFrame("sample_1.png"); 
}


