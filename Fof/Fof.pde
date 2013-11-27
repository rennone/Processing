//
float f = 0.3;
float w = 2*PI*f;
float w_noise = 2*PI/f;
float light;
int t = 0;
int[] power = new int[256];
void setup(){
  size(400,400);
  colorMode(RGB); //RGB濶ｲ遨ｺ髢薙↓繧ｻ繝�ヨ
  background(0); //閭梧勹縺ｯ鮟偵↓繧ｻ繝�ヨ
  frameRate(10);
  for(int i=0; i<256;i++){
    power[i] = 0;
  }
  light = random(0.8)+0.1;
}

 
void draw(){
  int fire_int;
  t++;
  if(light < 0.5) {
    light =  light + 2*light*light;   
  } else {
    light = light - 2*(1-light)*(1-light);
  }

  int red = (int)(250*light) + 5;
  power[red] += 1;
  fill(red, 0, 0);
  if(t == 200){
    for(int i=0; i<256;i++){
      println(i + " " + power[i]);
    }
  }
  rect(150, 150, 100, 100);
}

float noise(){
 float wave = cos(w_noise*t)+2*sin(w_noise*t);
 return 0.3*wave;
}



