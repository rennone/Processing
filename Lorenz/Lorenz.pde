int dNum=10000;
Dot[] dot = new Dot[dNum];

float aa = 10.0;
float bb = 8/3;
float rr = 28.0;
float delt=0.01;
float Yangle;
float Xangle;
float dx = 0;
float dy = 0;

void setup(){
  size(600,600,P3D);
  background(255);
  colorMode(RGB,256); //HSB色空間にセット
  for(int i=0;i<dNum;i++){
    dot[i]=new Dot(aa,bb,rr);
  }
}

void draw(){
  background(255);
  translate(width/2,height/2);
  scale(10);
  dx +=(mouseX-dx)*0.1;
  dy +=(mouseY-dy)*0.1;
  Yangle = (dx-width/2)/2;
  Xangle = (height/2-dy)/2;
  rotateY(radians(Yangle));
  rotateX(radians(Xangle));
  for(int i=0;i<dNum;i++){
    dot[i].update();
  }
}

void mouseReleased(){
  background(255);
  aa = random(2,30);
  rr = random(10,50);
  for(int i=0;i<dNum;i++){
    dot[i]=new Dot(aa,bb,rr);
  }
}

class Dot{
  float A,B,R,a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,ox,oy,oz,nx,ny,nz;
  color col;
  Dot(float aa,float bb,float rr){
    A=aa;
    B=bb;
    R=rr;
    ox = random(-50.0,50.0);
    oy = random(-50.0,50.0);
    oz = random(-10.0,10.0);
    col = color(0,0,0,50);
  }
  void update(){
    a1=A*(oy-ox);
    a2=-ox*oz+R*ox-oy;
    a3=ox*oy-B*oz;
    b1=A*(oy+a2*delt/2-(ox+a1*delt/2));
    b2=-(ox+a1*delt/2)*(oz+a3*delt/2)+R*(ox+a1*delt/2)-(oy+a2*delt/2);
    b3=(ox+a1*delt/2)*(oy+a2*delt/2)-B*(oz+a3*delt/2);
    c1=A*(oy+b2*delt/2-(ox+b1*delt/2));
    c2=-(ox+b1*delt/2)*(oz+b3*delt/2)+R*(ox+b1*delt/2)-(oy+b2*delt/2);
    c3=(ox+b1*delt/2)*(oy+b2*delt/2)-B*(oz+b3*delt/2);
    d1=A*(oy+c2*delt/2-(ox+c1*delt/2));
    d2=-(ox+c1*delt/2)*(oz+c3*delt/2)+R*(ox+c1*delt/2)-(oy+c2*delt/2);
    d3=(ox+c1*delt/2)*(oy+c2*delt/2)-B*(oz+c3*delt/2);
    nx=ox+(a1+2*b1+2*c1+d1)*delt/6.0;
    ny=oy+(a2+2*b2+2*c2+d2)*delt/6.0;
    nz=oz+(a3+2*b3+2*c3+d3)*delt/6.0;
    float in = nx*nx+ny*ny+nz*nz;
    float red = 550*abs(nz)*abs(ox)/in;
    float green = 550*abs(nz)*abs(oy)/in;
    float blue = 550*abs(ny)*abs(oz)/in;
    col = color(red,green,blue,255);
    stroke(col);
    line(nx,ny,nz,ox,oy,oz);
    ox=nx;
    oy=ny;
    oz=nz;
  }
}
