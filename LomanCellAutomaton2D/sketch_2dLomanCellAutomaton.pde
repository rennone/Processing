
int sx, sy; 
float density = 0.5; 
int[][][] world;
int b_size = 10;
int counter = 0;

void setup() 
{ 
  size(300, 300);
  colorMode(HSB,100);
  background(100);
  frameRate(15);
  sx = width;
  sy = height;
  world = new int[sx][sy][2]; 
  stroke(255); 
  noStroke();
  smooth();
  
  for (int i = 0; i < sx * sy * density; i++) { 
    world[(int)random(sx)][(int)random(sy)][1] = 1; 
  } 
} 
 
void draw() 
{ 
  fadeToWhite(); 
  counter = counter + 1;
  
  if((counter % 3) == 1){
 
  for (int x = 0; x < width; x=x + b_size) { 
    for (int y = 0; y < height; y=y + b_size) { 
   
      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1)) 
      { 
        world[x][y][0] = 1; 
 
          fill(60,90,100);  
          ellipse(x, y, b_size, b_size);

      } 
      if (world[x][y][1] == -1) 
      { 
        world[x][y][0] = 0; 
      } 
      world[x][y][1] = 0; 
    } 
  } 


  for (int x = 0; x < width; x=x+b_size) { 
    for (int y = 0; y < height; y=y+b_size) { 
      int count = neighbors(x, y); 
      if (count == 3 && world[x][y][0] == 0) 
      { 
        world[x][y][1] = 1; 
      } 
      if ((count < 2 || count > 3) && world[x][y][0] == 1) 
     { 
        world[x][y][1] = -1; 
      } 
    } 
  }
  }
} 

 

int neighbors(int x, int y) 
{ 
  return world[(x + b_size) % sx][y][0] + 
         world[x][(y + b_size) % sy][0] + 
         world[(x + sx - b_size) % sx][y][0] + 
         world[x][(y + sy - b_size) % sy][0] + 
         world[(x + b_size) % sx][(y + b_size) % sy][0] + 
         world[(x + sx - b_size) % sx][(y + b_size) % sy][0] + 
         world[(x + sx - b_size) % sx][(y + sy - b_size) % sy][0] + 
         world[(x + b_size) % sx][(y + sy - b_size) % sy][0]; 
} 

void fadeToWhite(){
  rectMode(CORNER);
  fill(60,10,100,5);
  rect(0,0,width,height);
}
