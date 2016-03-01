void settings() {
  size(1000, 1000, P2D);
}
void setup() {
}
void draw() {
  background(255,255,255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0); //The first vertex of your cuboid
  My3DBox input3DBox = new My3DBox(origin, 100,150,300);
  //rotated around x
float[][] transform1 = rotateXMatrix(PI/8);
input3DBox = transformBox(input3DBox, transform1);
projectBox(eye, input3DBox).render();
//rotated and translated
float[][] transform2 = translationMatrix(200, 200, 0);
input3DBox = transformBox(input3DBox, transform2);
projectBox(eye, input3DBox).render();
//rotated, translated, and scaled
float[][] transform3 = scaleMatrix(2, 2, 2);
input3DBox = transformBox(input3DBox, transform3);
projectBox(eye, input3DBox).render();
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  return new My2DPoint((p.x-eye.x)/((-p.z/eye.z)+1),(p.y-eye.y)/((-p.z/eye.z)+1));
  //return new My2DPoint(p.x+p.z, p.y +p.z*eye.y/eye.x);
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] points = new My2DPoint[box.p.length];
  for(int i = 0; i<box.p.length; ++i) {
    points[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(points);
}

//Transformations

  //Homogeneous Representation
float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z, 1};
  return result;
}

  //Transformation Matrices
float[][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0 , 0 , 0},
                        {0, cos(angle), sin(angle) , 0},
                        {0, -sin(angle) , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}

float[][] rotateYMatrix(float angle) {
  return(new float[][] {{cos(angle), 0 , sin(angle) , 0},
                        {0, 1, 0 , 0},
                        {-sin(angle), 0, cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}

float[][] rotateZMatrix(float angle) {
  return(new float[][] {{cos(angle), -sin(angle) , 0 , 0},
                        {sin(angle), cos(angle), 0 , 0},
                        {0, 0 , 1 , 0},
                        {0, 0 , 0 , 1}});
}

float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {{x, 0, 0, 0},
                        {0, y, 0, 0},
                        {0, 0, z, 0},
                        {0, 0, 0, 1}});
}

float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {{1, 0, 0 , x},
                        {0, 1, 0 , y},
                        {0, 0, 1 , z},
                        {0, 0 , 0 , 1}});
}

float[] matrixProduct(float[][] a, float[] b) {
  float[] result= new float[b.length];
  for(int i=0; i<a.length; ++i) {
     for(int k = 0; k< a[i].length; ++k) {
       result[i] += a[i][k] * b[k];
     }
  }
  return result;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DBox result = box;
  for(int i = 0; i < box.p.length; ++i) {
    result.p[i] = euclidian3DPoint(matrixProduct(transformMatrix, homogeneous3DPoint(result.p[i])));
  }
  return result;
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}