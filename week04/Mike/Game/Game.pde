Mover mover;

float rotationX = 0.0;
float rotationZ = 0.0;

float plateWidth = 250;
float plateLength = 250;
float plateHeight = 10;

float ballRadius = 5;
Mover ball = new Mover();
 
void settings() {
   size(500, 500, P3D);
}

void setup() {
   frameRate(30);
   noStroke();
}

void draw() {
    background(200);
    lights();
    camera(width/2, 0, 350, 
    width/2, height/2, 0, 
    0, 1, 0);
    
    translate(width/2, width/2, 0);
    rotateX(rotationX);
    rotateZ(rotationZ);
    fill(100, 255, 100);
    box(plateWidth, plateHeight, plateLength);
    translate(0, -10 - ballRadius, 0); // on met la boule à hauteur du plateau
    ball.update();
    translate(ball.location.x, ball.location.y, ball.location.z);  // on place la boule au bon endroit
    fill(100, 100, 100);
    sphere(10);
    
}

float speed = 0.025;

void mouseDragged()
{
  if (pmouseY < mouseY)
    rotationX -= speed;
  else if (pmouseY > mouseY)
    rotationX += speed;
  if (pmouseX < mouseX)
    rotationZ += speed;
  else if (pmouseX > mouseX)
    rotationZ -= speed;
    
  if (rotationX >= PI/3)
    rotationX = PI/3;
  if (rotationX <= -PI/3)
    rotationX = -PI/3;
  if (rotationZ >= PI/3)
    rotationZ = PI/3;
  if (rotationZ <= -PI/3)
    rotationZ = -PI/3;
}

void mouseWheel(MouseEvent event){
  //System.out.println("test : " + event.getCount() + "  " + speed);
  if (event.getCount() > 0)
    speed -= 0.0001;
  else if (event.getCount() < 0)
    speed += 0.0001;
  if (speed < 0)
    speed = 0;
  if (speed > 0.1)
    speed = 0.1;
}