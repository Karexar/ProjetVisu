float depth = 1000;
//rx, rz speedRot used for the rotation of the board
float rx = 0.0;
float rz = 0.0;
float speedRot = 1.0;

//board dimensions
float boardDimXZ = 600;
float boardDimY = 30;

//ball
Mover ball;
float dimSphere = 20;

void settings() {
  size(1000,800,P3D);
}

void setup() {
  noStroke();
  ball = new Mover();
}

void draw() {
  camera(width/2, height/2, depth, width/2, height/2, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, 1, 0);
  ambientLight(102, 102, 102);
  background(255);
  
  //text
  pushMatrix();
  translate(-200, -200, 0);
  textSize(20); 
  text("angle x: " + map(rx,-PI/3,PI/3, -60,60) + "  angle z: " + map(rz,-PI/3,PI/3, -60,60) + "  vitesse : " + speedRot, 10, 60);
  popMatrix();
  
  //board
  translate(width/2, height/2, 0);
  rotateX(rx);
  rotateZ(rz);
  box(boardDimXZ, boardDimY, boardDimXZ);
  
  //ball
  ball.update(rx, rz);
  ball.checkEdges(dimSphere, boardDimXZ, boardDimXZ);
  translate(ball.location.x, - dimSphere-boardDimY/2, ball.location.z);
  ball.display();
}

void mouseDragged() {
  //PI/180 est l'incrémentation de base. Valeur choisie aléatoirement
  float inc = speedRot*(PI/90);
  if(pmouseY > mouseY)
    rx = constrain(rx+inc, -PI/3, PI/3);
  else if (pmouseY < mouseY)
    rx = constrain(rx-inc, -PI/3, PI/3);
  if(pmouseX > mouseX)
    rz = constrain(rz-inc, -PI/3, PI/3);
  else if (pmouseX < mouseX)
    rz = constrain(rz+inc, -PI/3, PI/3);
}

void mouseWheel(MouseEvent event) {
  float inc = 0.0;
  if (event.getCount() < 0)
    inc = 0.2;
  else if (event.getCount() > 0)
    inc = -0.2;
  speedRot = constrain(speedRot + inc, 0.2, 1.5);
}