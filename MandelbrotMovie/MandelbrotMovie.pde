//マンデルブロ集合
//ムービー作成プログラム
// by Hajime Nobuhara

//初期座標の設定
//後ほどパラメータを調整
int frame_num = 200;  
float a = -0.5; //座標x方向の定数項a 
float b = 0.0; //座標x方向の定数項b 
float w = 1.8; //倍率の設定
float d_a = (-0.745427 - a)/frame_num;
float d_b = (0.113009  - b)/frame_num;
float d_w = (0.00001 - w)/frame_num;
int time=0;
// セットアップ部
void setup(){
  size(400,400); //400x400画素の描画窓を作成
  colorMode(RGB); //RGB色空間にセット
  background(0); //背景は黒にセット
  
  //Creatフォントで作成したフォントを読み込み
  PFont font = loadFont("Ayuthaya-24.vlw");
  textFont(font);
}

//描画部
void draw(){
   
  int h = width / 2; 
  int n = 50; //反復回数をセット
  int c; //カラー変数をセット
  
  int i,j,l;
  float x, y, zx, zy, u, v, mx;
  
  // 各座標点について計算してゆく
  for(i=-h; i<=h; i++){
      u = (w * i / h) + a; // x座標を動かす
      for(j=-h; j<=h; j++){
        v = (w * j / h) + b; // y座標を動かす
        
        x = 0.0;
        y = 0.0;
        for(l=1; l<=n; l++){
          zx = x * x - y * y + u;
          zy = 2 * x * y + v;
          x = zx;
          y = zy;
          mx = x * x + y * y;
          if (mx >= 10.0){
            break; // mxが10以上になったら発散と判定
          }
        }
        
        //発散のスピードが速ければ カラー変数 cの値は小さくなる
        c = int (256 * l / n); 
        
        //発散のスピードが速い程、黒に近い色になる
        stroke(c, c, c);
        point(200+i, 200-j);
        point(200+i, 200+j);
      }
  }

  PFont font = loadFont("Ayuthaya-24.vlw");
  textFont(font);
  text("a=" + nf(a,0,2) + ", b=" + nf(b,0,2) + ", w=" + nf(w,0,2), 50,385);
  //nf は小数点以下の桁数を制御する関数です
  a = a + d_a;
  b = b + d_b;
  w = w + d_w;
  saveFrame("./images/mandel-####.bmp");
  
}


