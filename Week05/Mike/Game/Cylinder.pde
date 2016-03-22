
PShape createCylinder()
{
  PShape cylinder;
  
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] z = new float[cylinderResolution + 1];
  //get the x and y position on a circle for all the sides
  for(int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    z[i] = cos(angle) * cylinderBaseSize;
  }
  noFill();
  cylinder = createShape();
  cylinder.beginShape(QUAD_STRIP);
  //draw the border of the cylinder
  for(int i = 0; i < x.length; i++) {
    cylinder.vertex(x[i], 0 , z[i]);
    cylinder.vertex(x[i], cylinderHeight, z[i]);
  }
  cylinder.endShape();
  return cylinder;
}

PShape createFan()
{
  PShape fan;
  
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] z = new float[cylinderResolution + 1];
  for(int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    z[i] = cos(angle) * cylinderBaseSize;
  }
  
  noFill();
  fan = createShape();
  fan.beginShape(TRIANGLE_FAN);

  for(int i = 0; i < x.length; i++) {
    fan.vertex(x[i], 0 , z[i]);
    fan.vertex(0, 0, 0);
  }
  fan.endShape();
  return fan;
}