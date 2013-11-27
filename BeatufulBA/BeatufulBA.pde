// 複雑ネットワーク BAモデル サンプルプログラム
import java.util.Map;
import java.util.*;
int Length = 500;
int Max_Node = 100;
int Node_number = 2;
int total_degree;
final float dt = 0.1;
Node[] NodeList = new Node[Max_Node];
boolean stop = true;

int[] initX = {-1,-1,1, 1};
int[] initY = { 1,-1,1,-1};
//初期化部
void setup() {
  size(Length*2,Length);
  background(0);
  smooth();
  frameRate(30); //フレームレートはゆっくりに設定
  total_degree = 0;
  //Node_numberの数だけノードを配置します
  for(int i=0;i<Node_number;i++) {
    int x = Length/2 + 10*initX[i+1];
    int y = Length/2 + 10*initY[i+1];
    NodeList[i] = new Node(x,y);
  }
  
  for(int i=0; i<Node_number;i++){
    for(int j=i+1;j<Node_number;j++) {
      connect(i,j);
    }
  }
}


//メイン部分
void draw() {
  if(!stop){   
    stop = true;
    addNode();
  }
  //moving 
  for(int i=0; i<10;i++){
    replace();
    for(int j=0; j<Node_number;j++){
      NodeList[j].move();
    }
  }
     
  drawblack();
  drawHistgram();
  //リンク（エッジ）を描画します
  stroke(255);
  for(int i=0; i < Node_number; i++) {
    Node A = NodeList[i];
    Iterator it = A.link.iterator();
    while(it.hasNext()){
      Node B =NodeList[(Integer)it.next()];
      line(A.xpos,A.ypos, B.xpos, B.ypos);
    }
  }
    //ノードを描画します
  for(int j=0; j < Node_number; j++) {
    NodeList[j].draw();
  }
  
}

void addNode(){
  if(Node_number>=100) return;
  int i = random_link(), j;
  for(j=random_link(); j==i; j=random_link());
  Node_number++;
  float x = 0.5*(NodeList[i].xpos + NodeList[j].xpos)+random(20);
  float y = 0.5*(NodeList[i].ypos + NodeList[j].ypos)+random(20);
  NodeList[Node_number-1] = new Node(x,y);
  connect(Node_number-1, i);
  connect(Node_number-1, j);
  
  resetForce();
}

void drawHistgram(){
  fill(255);
  int ox=Length+60, oy=Length-80;
  int lx=(int)(0.6*Length), ly=(int)(0.6*Length);
 stroke(255); 
  line(ox, oy, ox+(int)(1.2*lx), oy);
  line(ox, oy, ox, oy-(int)(ly*1.2));
  stroke(255,0,0);   
  text("probability",ox+(int)(1.2*lx), oy-5);
  text("number of nodes", ox-50, oy-(int)(ly*1.2)-15);
  stroke(255); 
  
  //Hash for link num
  TreeMap<Integer, Integer> hash = new TreeMap<Integer, Integer>();
  for(int i=0; i<Node_number;i++){
    Integer lnk = NodeList[i].link.size();
    if(hash.containsKey(lnk))
      hash.put(lnk, hash.get(lnk)+1);
    else
      hash.put(lnk, 1);
  }
  //max value, max key, min width of neighbor bar
  int max_num=0, max_prob=0;
  int min_size=total_degree, prev=0;
  for(Map.Entry map : hash.entrySet()){
    max_prob = max(max_prob, (Integer)map.getKey());
    max_num  = max(max_num , (Integer)map.getValue());
    min_size = min(min_size, (Integer)map.getKey()-prev);
    prev = (Integer)map.getKey();
  }
  //int size =max(2, min(20,(int)(lx*min_size/max_prob/1.5)));
  int size = min(100,max(2, (int)(lx*min_size/max_prob)-5));

  int i=0;
  for(Map.Entry map : hash.entrySet()){
   int x= (int)(lx*(Integer)map.getKey()/max_prob);
   int y =(int)(lx*(Integer)map.getValue()/max_num);
    rect(ox+x-size/2,oy-y, size,y);
    if(size<10*digit(total_degree)){
      line(ox+x, oy-2, ox+(int)((i+0.5)*lx/10), oy+15);
      frac((Integer)map.getKey(), total_degree, ox+(int)((i+0.5)*lx/10), oy+30);
      i++;
    }
    else{
      frac((Integer)map.getKey(), total_degree, ox+x, oy+30);
    }
    text((Integer)map.getValue(), ox-45, oy-y+5);
  }
  
  for(i=1; i<=max_num; i++){
    stroke(0);
    line(ox-5, oy-(int)(i*ly/max_num), ox+1.2*lx, oy-(int)(i*ly/max_num));
    stroke(255);
    line(ox-5, oy-(int)(i*ly/max_num), ox+5, oy-(int)(i*ly/max_num));
    //text(i, ox-45, oy-(int)(i*ly/max_num)+5);
  }
  
}

void frac(int nume, int denomi, int x, int y){
  stroke(255);
  int d1=digit(nume), d2=digit(denomi);
  text(nume, x-2-3*d1, y);
  line(x-2-3*d2, y+3, x+2+3*d2, y+3);
  text(denomi, x-2-3*d2, y+15);
}

int digit(int a){
  int i;
 for(i=1; (a/=10)!=0;i++);
 return i;
}

//ノードのクラス
class Node
{
  float xpos; //x座標
  float ypos; //y座標
  TreeSet link = new TreeSet();
  float vx,vy;
  float fx, fy;
  float dfx, dfy;
  Node(float xp,float yp) {
    xpos = xp;
    ypos = yp;
    vx = vy = 0;
    fx = fy=0;
  }

  void draw () {
    int size = (int)(3*link.size()+10);
    stroke(255,0,0);
    fill(0,200,0);
    ellipse(xpos,ypos,size,size);
    fill(255);
    float prob = (float)((float)link.size() / (float)total_degree);
    frac(link.size(), total_degree, int(xpos), int(ypos-size-10));
    //text(prob, xpos - 10, ypos - 10);
    if(fx != 0 || fy != 0){ dfx = fx; dfy=fy;}
    //drawForce(xpos, ypos, dfx, dfy);
    
  }
  
  boolean setLink(int l){
    if(link.contains(l)) return false;
    link.add(l);
    return true;
  }

  void move(){
    //fx = abs(fx)<1 ? 0 : fx;
    //fy = abs(fy)<1? 0:fy;
    xpos += fx*dt;
    ypos += fy*dt;
    fx *= 0.7;
    fy *= 0.7;
  }  
}

void connect(int i, int j){
  if(NodeList[i].setLink(j)) total_degree++;
  if(NodeList[j].setLink(i)) total_degree++;
}

int random_link() {
  int sum = 0;
  float rand = random(total_degree); 
  for(int i=0; i<Node_number; i++){
    sum += NodeList[i].link.size();
    if(sum > rand)  return i;
  }
  return Node_number-1;
}


void drawblack() {
  rectMode(CORNER);
  fill(0);
  rect(0,0,width,height);
}

float baneL = 50;
final float backlash = 50.0;
final float bounce = 1.0;
float mu = 0.1;
float gx = Length/2, gy=Length/2, gL=Length*2/5;

void replace(){
  baneL = min(100,50 + Node_number);
  float dx, dy;
  float d, d2;
  float fx=0, fy=0;
 for(int i=0; i<Node_number; i++){
   Node A = NodeList[i];
  for(int j=i+1; j<Node_number; j++){
    if(i==j) continue;
    Node B = NodeList[j];
    dx = A.xpos - B.xpos;
    dy = A.ypos - B.ypos;
    d2 = dx*dx+dy*dy;
    d = sqrt(d2);
    dx=dx/d; dy=dy/d;
    if(d==0){
      fx = random(baneL);
      fy = random(baneL);
    }
    else if(A.link.contains(j)){
      fx = bounce*(baneL-d)*dx/baneL;
      fy = bounce*(baneL-d)*dy/baneL;
    }
    else{
      if(abs(d)>150) continue;;
      fx= backlash*dx/d;
      fy= backlash*dy/d;
    }
    A.fx+=B.link.size()*fx;
    A.fy+=B.link.size()*fy;
    B.fx-=A.link.size()*fx;
    B.fy-=A.link.size()*fy;
  }
  dx=(gx-A.xpos);
  dy=(gy-A.ypos); 
  d=sqrt(dx*dx+dy*dy);
  if(d > gL){
    A.fx += 10*(d-gL)*dx/d;
    A.fy += 10*(d-gL)*dy/d;
  }
 }
}

void resetForce(){
 for(int k=0;k<Node_number;k++) {NodeList[k].fx=0; NodeList[k].fy=0;} 
}

void mousePressed(){
  stop = false;
  saveFrame("image.png");
}

void mouseReleased(){
   // resetForce();
}

void drawForce(float xpos, float ypos, float dfx, float dfy, color c){
  stroke(c);
  fill(c);
   float f = sqrt(dfx*dfx+dfy*dfy);
    line(xpos, ypos, xpos+int(50*dfx/f), ypos+int(50*dfy/f));
    triangle(xpos+int(40*dfx/f+5*dfy/f) , ypos+int(40*dfy/f-5*dfx/f),
             xpos+int(40*dfx/f-5*dfy/f) , ypos+int(40*dfy/f+5*dfx/f),
             xpos+int(50*dfx/f), ypos+int(50*dfy/f));
}

