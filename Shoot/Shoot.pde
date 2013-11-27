abstract class Agent{
  int x, y;
  Agent(int _x, int _y){
    x = _x;
    y = _y;
  }
  
  abstract boolean calc();
  abstract void draw();
}

class Player extends Agent{
  ArrayList bullets;
  int hp;
  Player(int _x, int _y){
    super(_x,_y);
    bullets = new ArrayList();
    hp = 100;
  }
  
  boolean calc(){
    if(keyCode == LEFT) x=max(0,x-5);
    else if(keyCode == RIGHT) x=min(width, x+5); 
    else if(keyCode == UP) y=max(0,y-5);
    else if(keyCode == DOWN) y=min(height, y+5); 
    bullets.add(new Bullet(x,y-5));
    for(int i=0;i<bullets.size();i++){
     if( ((Bullet)bullets.get(i)).calc()) continue;
     bullets.remove(i);
     i--;
   }
   return hp>0;
  }
  
  void draw(){
    fill(255);
   ellipse(x,y,10,5);
   for(int i=0;i<bullets.size();i++){
     ((Bullet)bullets.get(i)).draw();
   }
   
  }
}

class Bullet extends Agent{
  Bullet(int _x, int _y){
   super(_x,_y); 
  }
  boolean calc(){
   if((y-=10) < 0) return false;
  return true; 
  }
  
  void draw(){
    fill(255,0,0);
   ellipse(x,y,5,10); 
  }
}

Player player;
void setup(){
 size(300,500);
  player = new Player(width/2, height/2);
}

void draw(){
  background(0);
  calc();
 
 player.draw();
}

void calc(){
  player.calc();
}

void keyPressed(){
 if(key != CODED) return;
 if(keyCode == LEFT) player.x-=5;
 else if(keyCode == RIGHT) player.x+=5; 
}




