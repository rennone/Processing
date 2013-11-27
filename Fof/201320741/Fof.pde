void setup(){
  size(400,400);
  colorMode(RGB); //RGB濶ｲ遨ｺ髢薙↓繧ｻ繝�ヨ
  background(0); //閭梧勹縺ｯ鮟偵↓繧ｻ繝�ヨ
  frameRate(10);
}
//
float f = 0.3;
float w = 2*PI*f;
float w_noise = 2*PI/f;
float t = 0.0;
 
void draw(){

  int fire_int;
  t = t + 0.1;
  float wave = sin(w*t);
  wave = wave + noise();
  fire_int = int(abs(150 * wave));
  fill(fire_int, 0, 0);
  
  rect(150, 150, 100, 100);
  println(t + " " + fire_int);
}

float noise(){
 float wave = cos(w_noise*t)+2*sin(w_noise*t);
 return 0.3*wave;
}



