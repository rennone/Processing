final int MAX_HUMAN = 50, MAX_MEAL = 10;
final int None=-1,Meal=-2, Protestant=0, Catholic=1;
Agent[][] MAP;
ArrayList HumanList;
ArrayList MealList;
final int WINTER=0, SPRING=1, SUMMER=2, AUTUMN=3;
final color[] SeasonColor={color(160,160,160), color(255,174,201), color(24 ,242,19 ), color(200,68 ,21 )};
final color[] HumanColor = {color(255,0,0,255), color(0,0,255,255)};
int season=2;
int day;

void setup(){
 colorMode(RGB);
  size(400, 400);
  MAP = new Agent[width][height];
  HumanList = new ArrayList();
  MealList = new ArrayList();
  day = 0;
  season = 0;
  frameRate(30);
  
  for(int i=0; i<MAX_HUMAN; i++){
    HumanList.add(new Human((int)random(2)));
  }
  
  for(int i=0; i<MAX_MEAL; i++){
    MealList.add(new Meal());
  }
  
  for(int i=0; i<width; i++){
    for(int j=0; j<height;j++){
      MAP[i][j] = null;
    }
  }

  background(SeasonColor[season], 10);
}

void draw(){
  //背景を描画
  background(SeasonColor[season], 10);
  calc();
  
  for(int i=0; i<HumanList.size();i++){
    ((Human)HumanList.get(i)).draw();
  }
  
  for(int i=0; i<MealList.size();i++){
    ((Meal)MealList.get(i)).draw();
  }
  
  text(HumanList.size(), 0, height-10);
}

void calc(){
  for(int i=0; i<HumanList.size();i++){
    if(!((Human)HumanList.get(i)).calc()){
      HumanList.remove(i); i--;
    }
  }
  
  for(int i=0; i<MealList.size();i++){
    ((Meal)MealList.get(i)).calc();
  }
  popMeal();
  day = (day+1)%1800;
  season = floor(day/450);
}

class Agent{
 int x,y;
 int type;
 Agent(int _x, int _y, int _type){
   x = _x;
   y = _y;
   type = _type;
 }
}

final int DEAD=-1, WALK=0, ACTION=1;
int humanId=0;
class Human extends Agent{
int life;
int timer;       //体内時計
int hp;         //体力
int vx,vy;
int search;
color body;
int condition;
int id;
Human(int _type){
  super((int)random(width),(int)random(height), _type);
  id = humanId++;
  vx=(int)random(3)-1; 
  vy=(int)random(3)-1;
  hp = 1000+int(random(200));
  timer = int(random(5));
  search = 50;
  condition = WALK;
}

Human(int _type, int _x, int _y){
 this(_type);
 x = _x; y=_y; 
}

//人間を描画する部分
  void draw () {
    if(condition==DEAD) return;
    smooth();
    noStroke();
    if(type==Protestant)
      fill(255,0,0,255*hp/1000);
    else
      fill(0,0,255,255*hp/1000);
    if(condition==WALK)animationWalk();
    else animationAction();
    fill(255);
  }
  
//人間を動かす部分
  boolean calc() {
    if(condition==DEAD) return false;
    hp--; 
    if(hp<0) {dead(); return false;}
    timer++;
    if(hp>2000){ hp-=500; HumanList.add(new Human(type, (x+1)%width, (y+1)%height));}
    if(condition==WALK){
      collision();
      eating();
      move();
    }
    else if(condition==ACTION){
      action();
    }
    return true;
  }
  
  void move(){
    if(random(100) < 5){
      int dir = (int)random(5);
      vx=int(dir==1)-int(dir==3);
      vy=int(dir==2)-int(dir==4);
    }
    MAP[x][y]=null;
    x=(x+vx+width)%width; y=(y+vy+height)%height;
    MAP[x][y]=this;
  }
  
  void action(){
   boolean flag = false;
    for(int i=-9; i<10; i++){
      for(int j=-9; j<10; j++){
        if( !isEnemy(x+i,y+j)) continue;        
        ((Human)Map(x+i,y+j)).damaged(1);
        flag=true;
      }
    }

   if(hp<300 | !flag) condition = WALK;
   
  }
  
  void damaged(int d){
    hp-=d;
    if(hp<0) dead(); 
  }
  void collision(){
    int dis=width+height;
    for(int i=-9; i<10; i++){
      for(int j=-9; j<10; j++){
        if( isEnemy(x+i,y+j)  && hp>300){
          condition = ACTION;
          return;
        }
        if( (i|j)==0 || !isFamily(x+i,y+j) || dis<(abs(i)+abs(j))) continue;
        if( abs(i)>abs(j) )  
          vx = (int(i<0) - int(i>0));
        else 
          vy = (int(j<0) - int(j>0));
        dis = abs(i)+abs(j);
      }
    }
  }
  
  boolean isFamily(int i, int j){
    return Map(i,j)!=null && Map(i,j).type==type;
  }
  
  boolean isEnemy(int i, int j){
   return Map(i,j) != null && Map(i,j).type != Meal && Map(i,j).type != type;
  }
  
  void eating(){
    int dismin = search, near=-1;
    for(int i=0; i<MealList.size();i++){
      int dis = distance(this, (Meal)MealList.get(i));
      if(dis < search && dis < dismin){
        dismin = dis;
        near = i;
      }
    }
    
    if(near == -1) return;
    Meal meal = (Meal)MealList.get(near);
    if(!meal.canEat(this)) return;
    meal.setEater(this);
    int _vx = meal.x - x;
    int _vy = meal.y - y;
    vx = vy = 0;
    if(abs(_vx) > abs(_vy))    
      vx = int(_vx>0)-int(_vx<0);
    else
      vy = int(_vy>0)-int(_vy<0);
    
    if((vx|vy)==0) {
      MealList.remove(near);
      hp+=500;
    }
  }
  
  void dead(){
    condition = DEAD; 
    MAP[x][y] = null;
  }
  
  void animationWalk(){
    int time = ((timer)/10)%5;
    ellipse(x,y,6,6);
    rect(x-3,y+3,6,5); //胴体
    switch(time){    
      case 0:
        rect(x-3,y+8,3,5); //左足
        rect(x-4,y+3,2,5); //左腕
        rect(x+2,y+3,2,5); //右腕    
        break;
      case 1:
        rect(x-3,y+8,3,4);
        rect(x,y+8,3,1);        
        break;
      case 2:
        rect(x-3,y+8,3,3);
        rect(x,y+8,3,3);
        break;
      case 3:
        rect(x-3,y+8,3,1);
        rect(x,y+8,3,4);
        break;
      case 4:        
        rect(x,y+8,3,5);
        rect(x-4,y+3,2,5); 
        rect(x+2,y+3,2,5); 
        break;        
    }    
  }
  
  void animationAction(){
    int time = ((timer)/10)%2;
    ellipse(x,y,6,6);
    rect(x-3,y+3,6,5); //胴体
    rect(x-3,y+8,3,5); //左足
    rect(x,y+8,3,5);
    switch(time){    
      case 0:
        rect(x-6,y-3,2,10); //左腕 
        rect(x+4,y+3,2,10); //右腕    
        break;
      case 1:
        rect(x-6,y+3,2,10); //左腕 
        rect(x+4,y-3,2,10); //右腕     
        break;
    }    
  }
};

class Meal extends Agent{
  Human eater = null;
  
 Meal(){
  super((int)random(width), (int)random(height), Meal);
 }
 
 Meal(int w, int h){
   super(w, h, Meal);
 }
 
 void setEater(Human human){
   eater = human;
 }
 
 boolean canEat(Human human){
   return eater == null || eater.type != type || eater == human;
 }
 
 void draw(){
   fill(220,150,15);
   ellipse(x,y,10,10);
   fill(235,150,15);
   ellipse(x,y,8,8);
   fill(245,150,15);
   ellipse(x,y,5,5);
   stroke(15,255,35);
   line(x-1,y-5,x-1,y-8);
   line(x,y-5,x,y-7);
   noStroke();    
 }
 
 void calc(){
    MAP[x][y] = this;   
 }
}

void mousePressed() {
 //saveFrame("image.png"); 
 MealList.add(new Meal(mouseX, mouseY));
}

Agent Map(int x, int y){
 return MAP[(x+width)%width][(y+height)%height]; 
}

int distance(Agent a, Agent b){
 return abs(a.x-b.x)+abs(a.y-b.y); 
}

void popMeal(){
  if(random(100) > season*season+1) return;
  MealList.add(new Meal());
}




