//最も基本的なセルオートマトンのプログラム
 
CA ca;   // セルオートマトンのクラスの定義
int rule=0; //rule number
int end;  //end of generation
int Npattern = 8;
int rules[] = {22,  30,  45,  54,  60,  75,  86,  89,  90, 102,
              105, 106, 110, 120, 121, 126, 129, 135, 137, 146,
              147, 149, 150, 151, 153, 161, 165, 182, 183, 193, 
              195, 225};
int num=0;
//初期化部
void setup() {
  size(800,800);
  frameRate(30);
  background(0);
  end = height / 2;
  rule=0;
  ca = new CA(rules[num]);
}

void reset(){
  num = (num+1)%32;
  ca = new CA(rules[num]);
}

//メインループ
//画面の一番下にいっても描画し続けるので永久に止まらない
void draw() {
  //
  for(int i=0; i<end; i++){
    ca.render();    // セルオートマトンの描画関数を呼び出す
    ca.generate();  // 次の世代のセルオートマトンを計算する関数を呼び出し
  }
  saveFrame("Image3/rule-"+nf(rules[num],3) + ".png");
  reset();
}


//セルオートマトンのクラスを定義
class CA {
  int[] cells;     // セルが格納される配列
  int generation;  // 何世代目かを示す指標
  int scl = 2;     // セルの描画サイズの指標　セルは正方形でその一辺に相当
  int rule;        //number of rule
  CA(int r){
   rule = r;
   cells= new int[width/scl];
   restart(); 
  }
  // セルオートマトンの初期化を行う関数
  void restart() {
    for (int i = 0; i < cells.length; i++) {
      cells[i] = int(random(2)); //初期世代のセルをランダムに設定
    }
    generation = 0; //世代をあらわす変数を0にセット
  }

  //次の世代を計算する関数
  void generate() {
    //次の世代のセルを格納するための配列を確保
    int[] nextgen = new int[cells.length];
    final int len=cells.length;

    for(int i=0; i<len; i++){
      //binary transformation
      int n = cells[(i-1+len)%len] + (cells[i]<<1) + (cells[(i+1)%len]<<2);
      nextgen[i] = (rule&(1<<n))>>n;
    }
    // すべてが計算し終わったら、次の世代を現在の世代にコピーする
    cells = (int[]) nextgen.clone();
    generation++;
  }
  //セルの描画部
  void render() {
    //sclの大きさの正方形を、水平方向に左から右へ描画
    //世代が大きくなるほど、画面下に描画されるようになる
    for (int i = 0; i < cells.length; i++) {
      if (cells[i] == 1) fill(255);
      else               fill(0);
      noStroke();
      rect(i*scl,generation*scl, scl, scl); 
    }
  }
}
