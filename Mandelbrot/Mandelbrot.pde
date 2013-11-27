float objX, objY;    //オブジェクトのx, y座標
float disX, disY;    //mouse座標とオブジェクトの距離
float tempX, tempY;    //mouseが押されたときに、一時的にx, y座標を保存しておくための変数
float delay = 2.0;    //マウスに遅れる度合い
/*
float a = -0.51;
float b = 0.6130209;
float w = 0.00001;
*/
int h;
float a = 0.0;
float b = 0.0;
float w = 1.0;
void setup(){
  size(400,400);
  colorMode(RGB,512);
  //colorMode(HSB); //HSB色空間にセット
  background(0);
  h = width / 2;
}

void draw(){
  
  int n = 1024;
  //n = 50;
  int c;
  
  int i,j,l,cc;
  float x, y, zx, zy, u, v, mx;
  
  for(i=-h; i<=h; i++){
      u = (w * i / h) + a;
      for(j=-h; j<=h; j++){
        v = (w * j / h) + b;
        
        x = 0.0;
        y = 0.0;
        
        for(l=1; l<=n; l++){
          zx = x * x - y * y + u;
          zy = 2 * x * y     + v;
          x = zx;
          y = zy;
          mx = x * x + y * y;
          if (mx >= 10.0){
            break;
          }
        }
          c = int (512 * l / n);
          stroke(c * 2, c + 100 , c + 100 );
          //c = int(256*l/n);
          //stroke(c, 256, 256);
          point(200+i, 200-j);
        
      }
  }
}

void mousePressed() {
  tempX = mouseX;
  tempY = mouseY;
}

void mouseReleased(){
  tempX = mouseX - 200;
  tempY = -mouseY + 200;
  float _x = w*tempX/h + a;
  float _y = w*tempY/h + b;
  // println("a = " + _x + " b= " + _y);
   
  a = _x;
  b = _y;
  println("a = " + a+ " b= " + b + " w= " + w);
}

void keyPressed(){
  if(keyCode == UP) {  //上に動く
      w*=2.0;
   }else if (keyCode == DOWN) {    //下に動く
      w/=2.0;
   }
  println("a = " + a+ " b= " + b + " w= " + w);
}

