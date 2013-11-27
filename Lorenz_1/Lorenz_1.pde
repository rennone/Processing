/*int dNum=2000;
Dot[] dot = new Dot[dNum];

float aa = 10.0;
float bb = 8.0/3.0;
float rr = 28.0;
float delt=0.01;
float angle = random(-180,180);
float s = random(5,10);

void setup(){
  size(600,600,P3D);
  background(255);
  for(int i=0;i<dNum;i++){
    dot[i]=new Dot(aa,bb,rr);
  }
}

void draw(){
  background(255);
  translate(width/2,height/2);
  rotate(radians(angle));
  scale(s);
  for(int i=0;i<dNum;i++){
    dot[i].update();
  }
}

void mouseReleased(){
  background(255);
  s = random(5,10);
  aa = random(2,30);
  rr = random(10,200);
  angle = random(-180,180);
  println("s=" + s + " aa=" + aa + " rr=" + rr);
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
    
    col = color(
    random(0,31)+random(0,31)+random(0,31)+random(0,31)+random(0,31),
    random(0,40)+random(0,40)+random(0,40)+random(0,40)+random(0,40),
    random(0,51)+random(0,51)+random(0,51)+random(0,51)+random(0,51),
    30);
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
    strokeWeight(5);

    stroke(col);
    line(nx,ny,nz,ox,oy,oz);
    ox=nx;
    oy=ny;
    oz=nz;
  }
}
*/
int dNum=2000;
Dot[] dot = new Dot[dNum];

float aa = 10.0;
float bb = 8/3;
float rr = 28.0;
float delt=0.01;
float angle = random(-180,180);
float s = random(5,10);

void setup(){
  size(600,600,P3D);
  background(255);
  
  for(int i=0;i<dNum;i++){
    dot[i]=new Dot(aa,bb,rr);
  }
}

void draw(){
  background(255); //nai
  translate(width/2,height/2);
  rotate(radians(angle));
  scale(s);
  for(int i=0;i<dNum;i++){
    dot[i].update();
  }
}

void mouseReleased(){
  background(255);
  s = random(5,10);
  aa = random(2,30);
  rr = random(10,200);
  angle = random(-180,180);
  println("s=" + s + " aa=" + aa + " rr=" + rr);
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
    col = color(
    random(0,31)+random(0,31)+random(0,31)+random(0,31)+random(0,31),
    random(0,40)+random(0,40)+random(0,40)+random(0,40)+random(0,40),
    random(0,51)+random(0,51)+random(0,51)+random(0,51)+random(0,51),
    30);
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
    strokeWeight(5);
    stroke(col);
    line(nx,ny,nz,ox,oy,oz);
    ox=nx;
    oy=ny;
    oz=nz;
  }
}
