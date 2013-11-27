ArrayList prison = new ArrayList();
int hSize = 15, wSize = 50;
void setup(){
  size(500,500);
  background(0);
  stroke(255);
  scenario1();
  int pNum = prison.size();  
  int[] sumPoint = new int[pNum];
  for(int i=0; i<prison.size();i++){ 
    text(((Prisoner)prison.get(i)).name, wSize, (i+2)*hSize);
    text(((Prisoner)prison.get(i)).name, (i+2)*wSize,hSize);
  }

  text("Sum", (pNum+2)*wSize,hSize);
  String score = "";
  for(int i=0; i<prison.size();i++){
    for(int j=i+1; j<pNum; j++){
      Game game = new Game((Prisoner)prison.get(i), (Prisoner)prison.get(j));     
      game.calc();
      text(((Prisoner)prison.get(j)).getPoint(), (i+2)*wSize, (j+2)*hSize);
      text(((Prisoner)prison.get(i)).getPoint(), (j+2)*wSize, (i+2)*hSize);
      sumPoint[i] += ((Prisoner)prison.get(i)).getPoint();
      sumPoint[j] += ((Prisoner)prison.get(j)).getPoint();
      ((Prisoner)prison.get(i)).reset(); ((Prisoner)prison.get(j)).reset();
    }
    text(sumPoint[i], (pNum+2)*wSize,(i+2)*hSize);
  }
}

void scenario4(){
  for(int i=0; i<9; i++)
    prison.add(new TFTPrisoner());
  for(int i=9; i<12; i++)
    prison.add(new CooperatePrisoner());
  for(int i=12; i<18; i++)
    prison.add(new BetrayPrisoner());   
}

void scenario1(){
  prison.add(new TFTPrisoner());
  for(int i=0; i<4;i++)  prison.add(new BetrayPrisoner());
}

void scenario2(){
  prison.add(new TFTPrisoner());
  for(int i=0; i<4; i++) prison.add(new CooperatePrisoner()); 
}

void scenario3(){
  prison.add(new TFTPrisoner());
  prison.add(new CooperatePrisoner());
  prison.add(new CooperatePrisoner());
  prison.add(new BetrayPrisoner());
  prison.add(new BetrayPrisoner());
}
void draw(){
  
}

final int Cooperate=1, Betray=0;
final int[] pointTable = {1, 5, 0, 3};

abstract class Prisoner{
  protected ArrayList myScore;
  protected ArrayList partScore;
  protected int point;
  protected String name;
  Prisoner(){
   myScore = new ArrayList();   
   partScore = new ArrayList();   //enemy Score
   point=0;
  }
  void setScore(int me, int part){
    myScore.add(me);
    partScore.add(part);
    point+= pointTable[(me<<1)|part];
  }
  void reset(){
   point=0;
   myScore = new ArrayList();
   partScore = new ArrayList(); 
  }
  int getPoint(){
   return point; 
  }
  abstract int calc();
};

int TFTnum = 0;
class TFTPrisoner extends Prisoner{
  TFTPrisoner(){
    super();
    name = "TFT" + (TFTnum++);
  }
  int calc(){
   if(partScore.size()==0) 
     return Cooperate;
   return (Integer)partScore.get(partScore.size()-1);
  }
};

int BetNum = 0;
class BetrayPrisoner extends Prisoner{
  BetrayPrisoner(){
   super();
   name="BET" + (BetNum++);
  }
  int calc(){
    return Betray;
  }
}

int CooNum = 0;
class CooperatePrisoner extends Prisoner{
  CooperatePrisoner(){
   super();
   name="COO" + (CooNum++);
  }
  int calc(){
    return Cooperate;
  }
}

class Game{
 Prisoner A, B;
 int time;
   Game(Prisoner _A, Prisoner _B){
    A = _A;
    B = _B;
    time=0;
   }
   
   void calc(){
     for(int t=0; t<5; t++){
      int a = A.calc();
      int b = B.calc();
      A.setScore(a,b);
      B.setScore(b,a);
     }
   }
}

