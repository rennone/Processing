
int Length = 500;
int normal_number = 0;
int sick_number = 0;
int Max_Human = 500; //画面に登場させる人間の数
int Sick = 98; //病気にならない確率
int time = 0;
int[][] MAP = new int[Length][Length];
ArrayList deadManList = new ArrayList();
Human[] UofT_Human = new Human[Max_Human];

//初期化部
void setup() {
  size(Length,Length+100);
  background(0);
  frameRate(30);
  //ここで人間を生成

  for(int i=1; i < Max_Human; i++){
    int k1 = int(random(100));
    //乱数を生成し、Sick以下ならば健常者、それ以外なら病気
    if(k1 < Sick){
      k1 = 1;
    }
    else{
      k1 = 2;
    }
     //動きのための初期設定
     //k2,k3は出現座標
     int k2 = int(random(Length));
     int k3 = int(random(Length));

     //k4,k5は速度ベクトル
     int k4 = 0;
     int k5 = 0;
     if(k1 == 1){
       k4 = 3 - int(random(5));
       if(k4 == 0) k4 = 1;
       k5 = 3 - int(random(5));
       if(k5 == 0) k5 = 1;
     }
     else{
       k4 = 2 - int(random(4));
       if(k4 == 0) k4 = 1;
       k5 = 2 - int(random(4));
       if(k5 == 0) k5 = 1;
     }
     
    UofT_Human[i] = new Human(i,k1,k2,k3,k4,k5);
  }
  
 
  //空間の状態管理配列
  for(int i=0; i< Length; i++){
    for(int j=0; j< Length; j++){
      MAP[i][j] = 0;
    }
  }
 
}


//メインループ
void draw() {
 background(0);
 time++;
 
 //人間を描画
 for(int j=1; j < Max_Human; j++){
     UofT_Human[j].draw();
  }

  //人間を動かす
  for(int j=1; j < Max_Human; j++){
     UofT_Human[j].drive();
  }
 
  //人間同士の衝突判定
  for(int j=1; j < Max_Human; j++){
     UofT_Human[j].coll();
  }
  
  //現在の状況をカウント
   normal_number = 0;
   sick_number = 0;
  for(int j=1; j < Max_Human; j++){  
    if(UofT_Human[j].condition == 1){
      normal_number++;
    }
    else{
      sick_number++;
    }
  }
  
  //reborn();
  //PFont font = loadFont("AgencyFB-Reg-24.vlw");
  //textFont(font);
  fill(255, 255, 255);
  text("Time= " + time  , 50, 530);
  text("normal=" + normal_number , 50,550);
  text( "sickness=" + sick_number , 50,570);
  text("deadMan="+deadManList.size(),50, 590 );
 //text("normal=", 50,525);
  
  
}

//人間のクラスを定義
class Human
{
  int id;
  int xpos; //x座標
  int ypos; //y座標
  int xvel; //x方向の速さ
  int yvel; //y方向の速さ
  int condition; //健康かそれとも病気かのパラメータ
  int time;
  Human(int i, int c, int xp, int yp, int xv, int yv) {
    id = i;
    xpos = xp;
    ypos = yp;
    xvel = xv;
    yvel = yv;
    condition = c;
    time = 0;
  }

 //もし健康ならば青、病気ならば赤を描画
  void draw () {
    if(condition ==1){
      fill(0,0,255);
      ellipse(xpos,ypos,4,4);
    }
    else if(condition == 2){
      fill(255,0,0);
      ellipse(xpos,ypos,4,4);
    } 
  }

  void drive () {
    
    if(condition == 2){
      time = (time+1)%301;
      if(random(300)<1){
        condition = 3;
        deadManList.add(id);
      }
      if(random(300)<1 || time==300){
       condition=1;
      } 
    }
    MAP[xpos][ypos] = 0;
    xpos = (xpos + xvel + Length) % Length;
    ypos = (ypos + yvel + Length) % Length;
    MAP[xpos][ypos] = condition;
  }
 
  //衝突判定を行う部分
  void coll () {
    if(condition == 3) return;
    for(int i = -2; i < 3; i++){
      for(int j = -2; j < 3; j++){
        if ((MAP[(xpos+i+Length)%Length][(ypos+j+Length)%Length] > 0) && (i != 0) && (j != 0)){
          xvel = -xvel;
          yvel = -yvel;
          if(MAP[(xpos+i+Length)%Length][(ypos+j+Length)%Length] == 2){
            condition = 2;
          }
        }
      }
    }
  }
}

void reborn(){
 if(deadManList.size()==0 || random(100) > 1) return;
 int deadMan = (Integer)deadManList.get(0);
 deadManList.remove(0);
 UofT_Human[deadMan].condition = 1;
}


void mousePressed() {
 saveFrame("sample_4.png"); 
}


