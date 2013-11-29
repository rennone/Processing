

int W_size = 400; // screen size 
int N = 50; // Node number 
int Loop = 20; // Loop number 
Node[] WS_Node;
int R;

void setup() {
  size(W_size, W_size);
  background(0);
  smooth();
  frameRate(30); //フレームレートはゆっくり

  reset();
}

void reset(){
  WS_Node = new Node[N];
  //nodes
  for(int i=0; i<N; i++) {
    int k1 = int(W_size/2 + W_size/2.5*cos(2*PI*i/N));
    int k2 = int(W_size/2 - W_size/2.5*sin(2*PI*i/N));
    WS_Node[i] = new Node(k1,k2);
    WS_Node[i].link_number = 2;
    for(int j=0; j<2; j++) {
      WS_Node[i].link[j] = (i+j+1)%N;
    }
  }
}

//main
void draw() {

  //reset
  background(0);
  //connect a link to another node
  for(int i=0; i<Loop; i++){
  R = int(random(N));
    WS_Node[R].link[int(random(2))] = (R + int(random(N/6,N/2)))%N;
  }
  
  //draw links
  fill(255);
  for(int j=0; j < N; j++) {
    WS_Node[j].draw();
    text(j,int(W_size/2 + W_size/2.3*cos(2*PI*j/N)),int(W_size/2 - W_size/2.3*sin(2*PI*j/N)));
    for(int i=0; i< WS_Node[j].link_number; i++) {
      stroke(255);
      line(WS_Node[j].xpos, WS_Node[j].ypos, WS_Node[WS_Node[j].link[i]].xpos, WS_Node[WS_Node[j].link[i]].ypos);
    }
  }


  //saveFrame("image/node"+nf(N,3)+".png");
  //N+=10;
  //if(N>100) exit();
  //reset();
}


class Node {

  int xpos;
  int ypos;
  int link_number;
  int [] link = new int[N];
  int size;
  Node(int xp, int yp) {
    xpos = xp;
    ypos = yp;
    size = max(1, (int)(W_size/5*2*PI/N));
  }
  void draw() {
    noStroke();
    fill(0,0,255);
    ellipse(xpos,ypos,size,size);
  } 
}

