 
void settings() {
   size(500, 500, P3D);
}

void setup() {
   noStroke();
}

float rotationX = 0.0;
float rotationZ = 0.0;

void draw() {
    background(200);
    lights();
    camera(width/2, 0, 350, 
    width/2, height/2, 0, 
    0, 1, 0);
    
    translate(width/2, width/2, 0);
    rotateX(rotationX);
    rotateZ(rotationZ);
    box(250, 20, 250);
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
    
  if (rotationX >= PI/6)
    rotationX = PI/6;
  if (rotationX <= -PI/6)
    rotationX = -PI/6;
  if (rotationZ >= PI/6)
    rotationZ = PI/6;
  if (rotationZ <= -PI/6)
    rotationZ = -PI/6;
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