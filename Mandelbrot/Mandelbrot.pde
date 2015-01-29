float a = -0.5; //座標x方向の移動量 
float b = 0.0;  //座標y方向の移動量
float scale = 1.8; //倍率の設定

PImage image;

void setup(){
  size(400,400); //400x400画素の描画窓を作成
  colorMode(RGB); //RGB色空間にセット
  background(0); //背景は黒にセット
  
  image = createImage(width, height, RGB);
  
  noLoop();
}

int calc(float x0, float y0){
  float x=0.0, y=0.0;
  int iteration = 0;
  int max_iteration = 300;
  float sqrLimit = 10;
  while( x*x + y*y < sqrLimit && iteration < max_iteration){
    float xTmp = x*x - y*y + x0;
    y = 2*x*y + y0;
    x = xTmp;
    iteration+=1;
  }
  
  return int (255 * iteration / max_iteration); 
}

void update()
{
  image.loadPixels();
  float dx = scale/image.width;
  float dy = scale/image.height;
  
  for(int i=0; i<image.width; i++){
    float x0 = -scale*0.5 + i*dx + a;
    for(int j=0; j<image.height; j++){
      float y0 = -scale*0.5 + j*dy + b;
      int c = calc(x0, y0);
      image.pixels[j*image.width+i] = color(c);
    }
  }
  
  image.updatePixels();

}

//描画部
void draw(){
  background(0);
  update();
  image(image, 0, 0, width, height);
  
  fill(255,255,255);    
  text("up,down,right,left : moving", 1,20);
  text("               z,x : zooming", 1, 35);
}

void keyPressed()
{
  float speed = 0.1 * scale;
  if(key == CODED){
    switch(keyCode){
      case UP:
        b -= speed;
        break;
      case DOWN:
        b += speed;
        break;
      case RIGHT:
        a += speed;
        break;
      case LEFT:
        a -= speed;
        break;
    }
  }
  
  float zoomSpeed = 0.3; // 0~1.0の間
  switch(key)
  {
    case 'z':
      scale *= (1-zoomSpeed);      
      break;
    case 'x':
      scale *= (1+zoomSpeed);
      break;  
  }
  
  redraw();
}

