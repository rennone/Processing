import processing.opengl.*;
 
//回転角度
float a;
 
//立方体の数
int NUM = 128;     
float offset = PI/NUM;
//色のグラデーションを格納する配列
color[] colors = new color[NUM];
 
void setup() { 
    size(400, 400, OPENGL);
    noStroke();
    colorMode(HSB,360,100,100,100);
    frameRate(30);
    //色のグラデーションを定義
    for(int i=0; i<NUM; i++) {
    colors[i] = color(i*2+100,70,100,25);
    }
}
 
void draw() {     
    background(0);
     
    //ライティング
    ambientLight(63, 31, 31);
    directionalLight(255,255,255,-1,0,0);
    pointLight(63, 127, 255, mouseX, mouseY, 200);
    spotLight(100, 100, 100, mouseX, mouseY, 200, 0, 0, -1, PI, 2);
 
    //座標を中心に
    translate(width/2, height/2, -20);
 
    //マウスで全体を回転
    rotateX(mouseX / 200.0);
    rotateY(mouseY / 100.0);
 
    //少しずつ回転角度をずらしながら、立方体を描画
    for(int i=0; i<NUM; i++) {
      pushMatrix();
      fill(colors[i]);
      rotateY(a+offset*i);
      rotateX(a/2+offset*i);
      rotateZ(a/3+offset*i);
      box(width/2);
      popMatrix();
    }
 
    //角度を更新
    a+=0.01;  
} 
