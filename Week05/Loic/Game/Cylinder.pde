
float cylinderBaseSize = 50;
float cylinderHeight = 60;
int cylinderResolution = 40;
PShape openCylinder = new PShape();
PShape bottomCylinder = new PShape();
PShape topCylinder = new PShape();


void cylinder() {
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  
  //get the x and y position on a circle for all the sides
  for(int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  bottomCylinder = createShape();
  bottomCylinder.beginShape(TRIANGLE_FAN);
  bottomCylinder.vertex(0,0,0);
  topCylinder = createShape();
  topCylinder.beginShape(TRIANGLE_FAN);
  topCylinder.vertex(0,-cylinderHeight,0);
  
  //draw the borderand top, bottom of the cylinder
  for(int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], 0 , y[i]);
    openCylinder.vertex(x[i], -cylinderHeight, y[i]);
    bottomCylinder.vertex(x[i], 0 , y[i]);
    topCylinder.vertex(x[i], -cylinderHeight, y[i]);
  }
  openCylinder.endShape();
  topCylinder.endShape();
  bottomCylinder.endShape();
}

void drawCyl(){
  shape(openCylinder);
  shape(topCylinder);
  shape(bottomCylinder);
}