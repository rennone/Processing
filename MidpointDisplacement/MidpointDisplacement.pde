//import the controlP5 library for the controls
//Download from http://www.sojamo.de/libraries/controlP5/
import controlP5.*; 

ControlP5 controlP5;

int depthSlider = 6; //controls the reciursive depth
int MIN_DEPTH = 1;
int MAX_DEPTH = 20;

//Controls the linear displacement of the lines. Expressesed as a 
// percentage of the overall length of the line segment
float jitterSlider = .40;
float MIN_JITTER = 0.2;
float MAX_JITTER = 0.7;

//Class to define a point on a plane
class Point { 
 float x,y;
 
 Point ( float _x, float _y) {
 x = _x;
 y = _y;
 }
}

//Class to define a line segment
class Line {
 Point p1,p2;
 float jitter;
 
 Line (Point _p1, Point _p2, float _jitter) {
 p1 = _p1;
 p2 = _p2;
 jitter = _jitter;
 }
 
 // Draws a filled parallelogram with the line at the top and the lower bound of the sketch at the bottom
 void drawLine() {
 stroke(#ffffff);
 fill(#ffffff); 
 beginShape();
 vertex(p1.x, p1.y);
 vertex(p2.x, p2.y);
 vertex(p2.x, 300);
 vertex(p1.x, 300);
 endShape(CLOSE);
 }
 
 // Compute a random offset based on a percentage of the length of the line
 float getJitter() {
 float len = sqrt((p1.x - p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
 return jitter*len*random(-1,1);
 }
 
}

//Returns the center point between the two given points
Point findCenter(Point a, Point b) {
 return new Point ( (a.x+b.x)/2.0, (a.y+b.y)/2.0);
}

//Recursively define the mountain
void fractal(Line l, int N) {
 if (N == 0) {
 //Draw the filled p-gram based on the current line segment
 l.drawLine();
 } else {
 // Split the current line into 2 parts with a random offset
 Point p = findCenter(l.p1,l.p2); //find a new center point
 p.y += l.getJitter(); // Randomly displace the center point up or down
 fractal (new Line(l.p1,p, jitterSlider), N-1); //recurse on left side
 fractal (new Line(p, l.p2, jitterSlider), N-1); //recurse on right side
 
 }
}

//This is here just to keep the sketch listening for new keypresses 
void draw() {
}

//Draws the landscape -- a new one appears each time you press a key
void keyPressed() {
 fill(#000000); 
 rect(0,0,400,300);
 fill(#ffffff);
 Point a = new Point(0,200);
 Point b = new Point(400,200);
 fractal( new Line(a,b, jitterSlider), depthSlider);
}

// Set up the drawing area and add the control elements 
void setup() {
 size (400,300);
 controlP5 = new ControlP5(this);
 controlP5.addSlider("depthSlider",MIN_DEPTH,MAX_DEPTH,depthSlider,20,20,100,10);
 Slider s2 = (Slider)controlP5.controller("depthSlider"); //Get a handle to the new slider
 s2.setNumberOfTickMarks(6); // Set tick marks
 s2.setLabel("Recursive Depth");
 controlP5.addSlider("jitterSlider",MIN_JITTER,MAX_JITTER,jitterSlider,20,50,100,10);
 s2 = (Slider)controlP5.controller("jitterSlider"); //Get a handle to the new slider
 s2.setLabel("Jitter");
 keyPressed();
}
