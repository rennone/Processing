
final float scl = 40;
final float del = 0.1;
final int min=-10, max=10;
final int LoopNum = 200;
final int mode=7;
ArrayList fixedPoints = new ArrayList();

class Point{
 float x, y;
 Point(float _x, float _y){
   x = _x;
   y = _y;
 } 
 void draw(){
   fill(255,0,0);
  ellipse(transX(x), transY(y), 10,10); 
 }
};

void setup(){
  size(20*int(scl),20*int(scl));
  drawPhasePlane();
  saveFrame(mode+".png");
}

void drawAxis(){
  stroke(255);
  for(int i=min; i<max; i++){
    line(transX(i), 0, transX(i), height);
    line(0, transY(i), width, transY(i));
  } 
  stroke(0);
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
}

void drawPhasePlane(){
  drawAxis();

  for(float i=min; i<=max; i+=2){
    for(float j=min; j<=max; j+=2){
      trajection(i,j);
    }
  }
  
  for(int i=0; i<fixedPoints.size(); i++){
    Point p = (Point)fixedPoints.get(i);
    p.draw();
  }  
}

// xdot equation 
float xdot(float x, float y){
  switch(mode){
    case 0:  return x-y;
    case 1:  return sin(y);
    case 2:  return 1+y-exp(-x);
    case 3:  return y+x-x*x*x;
    case 4:  return sin(y);
    case 5:  return x*y-1;
    case 6: return -2*x;
    case 7: return -2*x;
    default: return y*y*y - 4*x;
  }
}

// ydot equation 
float ydot(float x, float y){
  switch(mode){
    case 0: return x*x-4;
    case 1: return x-x*x*x;
    case 2: return x*x*x - y;
    case 3: return -y;
    case 4: return cos(x);
    case 5: return x-y*y*y;
    case 6: return -2*y;
    case 7: return 2*y;
    default :return y*y*y - y - 3*x; 
  }
}

void trajection(float x0, float y0){
  float fx1=x0, fy1=y0;
  float fx2,fy2;
  float fd, fdx,fdy;
  fill(0,0,0);
  for(int i=0; i<LoopNum; i++){
    fdx = xdot(fx1,fy1); fdy=ydot(fx1,fy1);
    fd = sqrt(sq(fdx)+sq(fdy));
    if(fd == 0){
      fixedPoints.add(new Point(fx1,fy1));
      return;
    }
    fx2 = fx1+fdx/fd*del;
    fy2 = fy1+fdy/fd*del;
    //point(transX(x1),transY(y1));
    line(transX(fx1), transY(fy1),transX(fx2), transY(fy2));
    if(i%LoopNum == 10)draw_arrow(fx1,fy1,fx2,fy2);
    fx1 = fx2; fy1 = fy2;
 }
 
  float bx1=x0, by1=y0;
  float bx2, by2;
  float bd;
  float bdx, bdy; 
 //backword todo
 for(int i=0; i<LoopNum;i++){
   bdx = xdot(bx1,by1); bdy = ydot(bx1,by1);
   bd = sqrt(sq(bdx) + sq(bdy));
   if(bd == 0){
      fixedPoints.add(new Point(bx1,by1));
      return;     
    }
   bx2 = bx1 - bdx/bd*del;
   by2 = by1 - bdy/bd*del;
   line(transX(bx1), transY(by1),transX(bx2), transY(by2));
   if(i%LoopNum == 10) draw_arrow(bx2,by2,bx1,by1);
   bx1=bx2; by1=by2;  
 }
 
 
}

void draw_arrow(float x1, float y1, float x2, float y2){
  strokeWeight(1);
  fill(0);
  x1 = transX(x1); y1 = transY(y1);
  x2 = transX(x2); y2 = transY(y2);
  float d_x = x2-x1, d_y=y2-y1;
  float x3 = x1+0.5*d_x - d_y, x4 = x1+0.5*d_x + d_y;
  float y3 = y1+0.5*d_y + d_x, y4 = y1+0.5*d_y - d_x;
  triangle(x2,y2,x3,y3,x4,y4); 
}

float transX(float x){
  return scl*x + width/2;
}

float transY(float y){
  return -scl*y + height/2;
}

void mousePressed(){
 saveFrame(mode+".png");
}


/*
void drawX(){
  stroke(255,0,0);
 for(float y=-10; y<10; y+=0.1){
  line(transX(pow(y,3)/4.0), transY(y), transX(pow(y+0.1, 3)/4.0), transY(y+0.1));
 } 
}

void drawY(){
  stroke(0,0,255);
 for(float y=-10; y<10; y+=0.1){
  line(transX((pow(y,3)-y)/3.0), transY(y), transX((pow(y+0.1,3)-y-0.1)/3.0), transY(y+0.1));
 } 
}
*/
