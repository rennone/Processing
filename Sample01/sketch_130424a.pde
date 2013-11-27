
//初期化部
void setup(){
  size(200,200); //サイズ200x200にセット
  background(255); //背景色を白にセット
  colorMode(RGB, 256); //カラーモードをRGB 256段階にセット
  noStroke();
  frameRate(15); //フレームレートを30枚/秒にセット
}

//メインループ
void draw(){
  //background(255);
 fadeToWhite(); //画面を白にフェードアウトさせる
 
  stroke( randomRGBColor()); //線の色をランダムに設定
  int x = int(random(width));
  int y = int(random(height));
  int sz = int(random(100));
  
  fill(randomRGBColor());
  ellipse(x,y,sz,sz);
 // rectLines(x, y, 30, 30); 
}

//ここから関数の定義

void rectLines(int x, int y, int w, int h){
  line (  x,  y,x+w,  y);
  line (  x,  y,  x,y+h);
  line (x+w,  y,x+w,y+h);
  line (x, y+h, x+w, y+h);
}

color randomRGBColor(){
  color c = color(random(256), random(256), random(256), 30);
  return c;
}

void fadeToWhite(){
  rectMode(CORNER);
  fill(255,30);
  rect(0,0,width,height);
}

