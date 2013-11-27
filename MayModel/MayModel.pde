// メイのモデルを作成

//コントロールパラメータaの変動範囲を設定
float a_min = 0; //aの最小値を0.0
float a_max = 4.0; //aの最大値を4.0
int maxT = 300;
int t=0;

void setup(){
  size(600,400); //600x400画素の描画窓を作成
  colorMode(RGB,256); //HSB色空間にセット
    //グラフの水平、垂直方向の軸を描画
    
  //y軸
  line(50,50,50,350);
  line(50,50,55,55);
  line(50,50,45,55);
  //x軸を描画
  line(50,350,550,350);
  line(550,350,545,345);
  line(550,350,545,355);
  
   stroke(255,0,0);
   int w = 600/40;
   float x = 0.700; //initialize
   for(int i=1; i<30;i++){
     line(i*w+50, 350 - 300*may(x,i), (i+1)*w+50, 350-300*may(x,i+1));
   }
   
   stroke(0,255,0);
   x = 0.701;//initialize
   for(int i=1; i<30;i++){
     line(i*w+50, 350 - 300*may(x,i), (i+1)*w+50, 350-300*may(x,i+1));
   }
   
   stroke(0,0,255);
   x = 0.702;//initialize
   for(int i=1; i<30;i++){
    // println(i + " " + may(x,i));
     line(i*w+50, 350 - 300*may(x,i), (i+1)*w+50, 350-300*may(x,i+1));
   }
   
}

float may(float x0, int n){
   
  float a=4.0;
 
  //コントロールパラメータの最大値と最小値の間を
 
   //ここでコントロールパラメータの1つの値に対し
   //複数回のプロットを行う。デフォルトで100回。
      
   //xの初期値をランダムに設定
  float x = x0;
      
  //ランダムに設定した初期値から100回反復計算
  for(int k=0;k<n;k++){
     x = a * x * (1.0 - x);
  }  
  return x;  
}


void draw(){
 //drawMovie(); 
}
void drawMovie(){
  colorMode(HSB); //HSB色空間にセット
  background(0); //背景は黒にセット
  
  stroke(255);
  
  //グラフの水平、垂直方向の軸を描画
  //y軸
  line(50,50,50,350);
  line(50,50,55,55);
  line(50,50,45,55);
  //x軸を描画
  line(50,350,550,350);
  line(550,350,545,345);
  line(550,350,545,355);
  
  
  float a;
  float x;
 
  //コントロールパラメータの最大値と最小値の間を
  //400に分割。400の分割を、描画する。
  for(int i=0; i < 400; i++){
    
    //現在のコントロールパラメータの値を計算
    a = a_min + i * (a_max - a_min) / 400.0;
 
   //ここでコントロールパラメータの1つの値に対し
   //複数回のプロットを行う。デフォルトで100回。
   
    for(int plot_number=0;plot_number<100;plot_number++){
      
      //xの初期値をランダムに設定
      x = random(1.0);
      
      //ランダムに設定した初期値から100回反復計算
      for(int k=0;k<100;k++){
        x = a * x * (1.0 - x);
      }  
      
      //色を適当に変更してプロット
      fill(i % 255,plot_number % 255,255);
      noStroke();
      ellipse(50 + i, 350 - (x * 300),2,2);
    } 
  }
  saveFrame("movie/"+nf(t,3,0)+".png");
  a_min +=3.855/maxT;
  a_max +=(3.860-4.0)/maxT;
  if(t==maxT) exit();
  t++;

}

