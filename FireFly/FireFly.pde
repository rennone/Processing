//最も基本的なセルオートマトンのプログラム
 
int rule; //rule number
int end;  //end of generation
int Npattern = 8;
int scl = 2;
int num=0;
int N = 100;
int W_size = 400; // screen size 
int loop;
int time;
Node[] FireFly;
int turn;
int[] initState = new int[N];
boolean replay_mode;
int iteration = 100;
int shortcut = 20;
int[] sync = new int[256];
final int Generate = 10000;
void setup() {
  size(W_size, W_size);
  background(0);
  smooth();
  frameRate(30); //フレームレートはゆっくり
  strokeWeight(1);
  replay_mode = true;
  time=0; rule=0;
  for(int i=0; i<256;i++)sync[i]=0;
  
  if(replay_mode){
   //inputState();
   reset();
  }
  else{
    reset();
    simulate();
  }
}

void reset(){
  turn = 0;
  loop = 0;
  initFireFly();
}

void initFireFly(){
  FireFly = new Node[N];
  for(int i=0; i<N; i++) {
    int x = int(W_size/2 + W_size/2.5*cos(2*PI*i/N));
    int y = int(W_size/2 - W_size/2.5*sin(2*PI*i/N));
    FireFly[i] = new Node(x,y);
    FireFly[i].makeLink(i);
    initState[i] = FireFly[i].state[turn];
  }
  /*
  for(int i=0; i<shortcut; i++){
    int R = int(random(N));
    FireFly[R].RandomLink(R);
  }  
  */
}

void inputState(){
 String[] lines = loadStrings("state.txt");
 N = int(lines[0]);
 rule = int(lines[1]);
 String[] init = split(lines[2], " ");
 reset();
 frameRate(5);
 for(int i=0; i<N; i++){
  FireFly[i].state[turn] = int(init[i]);
  String[] lnk = split(lines[i+3], " ");
  FireFly[i].link[0] = int(lnk[0]);
  FireFly[i].link[1] = int(lnk[1]);
  FireFly[i].link[2] = int(lnk[2]);
 }
  
}
void finish(){
  PrintWriter out = createWriter("ruleState-noSC.txt");
  for(int i=0; i<256; i++){
    out.println(i + " " +sync[i]);
  }
  out.flush();
  out.close();
  exit();
}

void simulate(){
  int rules[] = {3,7,17,21,27,31,39,53,63,83,87,117,119};
  for(rule=0; rule<256;rule++){
    for(time=0; time<100;time++){
      for(loop=0; loop<Generate; loop++){
        for(int i=0; i<N; i++)   FireFly[i].calc();
        turn = (turn+1)%3;
        if(loop>3 && synchro()){
          sync[rule]++;
          break;
        }
      }
      initFireFly();
    }
    println(rule + " " + sync[rule]);
  }
  finish();
}

//メインループ
void draw() {
  background(0);
  for(int i=0; i<N; i++)
   FireFly[i].calc();
  
  for(int i=0; i<N; i++)
   FireFly[i].draw();
  
  turn = (turn+1)%3;
/*
  if(loop>3 && synchro() && !replay_mode){
    sync[rule]++;
    if((++time%100)==0) rule++;
    if(rule>=256) finish();
    reset();
    drawStatus();
  }
  if(++loop > 400 && !replay_mode){
    if((++time%100)==0) rule++;
    if(rule>=256) finish();
    reset();
    drawStatus();
  }
  */
}

void drawStatus(){
   fill(255);
  text("Loop: " + loop,0,height-10);
  text("time: "+time , 80, height-10);
  text("rule: "+rule, 160, height-10);
}

boolean synchro(){
  int now=0,pre=0,prepre=0;
  for(int i=0; i<N;i++){
    now += FireFly[i].state[turn%3];
    pre += FireFly[i].state[(turn+2)%3];
    prepre += FireFly[i].state[(turn+1)%3];
  }
  
  if(now!=prepre || abs(now-pre)!=N) 
    return false;
  else
    return true;
  //saveState();
}

void saveState(){
  saveFrame("rule"+nf(rule,3)+".png"); 
  PrintWriter out = createWriter("state2.txt");
  out.println(N);
  out.println(rule);
  for(int i=0; i<N; i++)
    out.print(initState[i]+" ");
  out.println();
  for(int i=0; i<N; i++){
   out.println(FireFly[i].link[0] + " " + FireFly[i].link[1] + " " + FireFly[i].link[2]); 
  }
  out.flush();
  out.close();
}

class Node {
  int xpos;
  int ypos;
  int link_number = 3;
  int[] link;
  int[] state;
  int size;
  
  Node(int xp, int yp){
    xpos = xp;
    ypos = yp;
    size = max(1, (int)(W_size/5*2*PI/N));
    state = new int[3];
    state[turn] = (int)random(2);
    link = new int[link_number];
  }
  
  void makeLink(int id){
    for(int i=0; i<link_number;i++)
     link[i] = (id+i-1+N)%N;
  }
  
  void calc(){
    int n=0;
    for(int i=0; i<link_number; i++)
      n |= (FireFly[link[i]].state[turn]<<i);
      
    state[(turn+1)%3] = (rule&(1<<n))>>n;
  }
  
  void RandomLink(int R){
    link[(int)random(link_number)] = (R + int(random(N/6,N/2)))%N;
  }
  
  void draw() {
    for(int i=0; i< link_number; i++) {
      stroke(255);
      line(xpos, ypos, FireFly[link[i]].xpos, FireFly[link[i]].ypos);
    }
    noStroke();
    if(state[turn] == 0)
      fill(255,0,0);
    else
      fill(0,255,0);
   
    ellipse(xpos,ypos,size,size);
  } 
}

void mousePressed(){
 saveFrame("image.png");
}
