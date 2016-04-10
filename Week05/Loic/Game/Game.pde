float depth = 1000;
//rx, rz speedRot used for the rotation of the board
float rx = 0.0;
float rz = 0.0;
float speedRot = 1.0;

boolean mode = false;
ArrayList<PVector> cylinders = new ArrayList();

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
  cylinder();
  noStroke();
  ball = new Mover();
  
}

void draw() { 
  //SHIFT mode
  if (mode) {
    background(255);
    fill(100);
    rect(width/4, height/4, width/2, width/2);
    
    pushMatrix();
    translate(map(ball.location.x, -boardDimXZ/2, boardDimXZ/2, width/4, 3*width/4), map(ball.location.z, -boardDimXZ/2, boardDimXZ/2,height/4, width/2 + height/4));
    fill(0);
    ball.display();
    fill(255);
    popMatrix();
    
    //dessiner les cylindres
    for(int i=0; i < cylinders.size(); ++i){
      pushMatrix();
      translate(map(cylinders.get(i).x, -boardDimXZ/2, boardDimXZ/2,width/4.,3*width/4), map(cylinders.get(i).y, -boardDimXZ/2, boardDimXZ/2, height/4.,width/2. +height/4.));
      rotateX(-PI/2);
      drawCyl();
      popMatrix();
    }

  }else{ 
    pushMatrix();
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
    
    pushMatrix();
    
    //board
    translate(width/2, height/2, 0);
    rotateX(rx);
    rotateZ(rz);
    box(boardDimXZ, boardDimY, boardDimXZ);
    
    pushMatrix();
    for(int i=0; i < cylinders.size(); ++i){
      pushMatrix();
      translate(cylinders.get(i).x, -boardDimY/2, cylinders.get(i).y);
      drawCyl();
      popMatrix();
    }
    popMatrix();
    
    //ball
    ball.update(rx, rz);
    ball.checkEdges(dimSphere, boardDimXZ, boardDimXZ);
    translate(ball.location.x, - dimSphere-boardDimY/2, ball.location.z);
    ball.display();
    
    popMatrix();
    popMatrix();
  }
}

void mouseClicked() {
  if(mode){
    if(mouseX > width/4. && mouseX < 3*width/4. && mouseY > height/4. && mouseY < width/2. + height/4.){
      float x =map(mouseX,width/4.,3*width/4., -boardDimXZ/2, boardDimXZ/2);
      float y =map(mouseY,height/4.,width/2. +height/4., -boardDimXZ/2, boardDimXZ/2);

      PVector n = new PVector(x - ball.location.x,0, y - ball.location.z);
      float n_size = sqrt(n.x*n.x + n.z*n.z);
      float limite = cylinderBaseSize + dimSphere;
      if (n_size > limite){
          cylinders.add(new PVector(x,y,0));
      }
    }
  }
}


void mouseDragged() {
  if(!mode) {
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
}

void mouseWheel(MouseEvent event) {
  if(!mode){
    float inc = 0.0;
    if (event.getCount() < 0)
      inc = 0.2;
    else if (event.getCount() > 0)
      inc = -0.2;
    speedRot = constrain(speedRot + inc, 0.2, 1.5);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      mode = true;
    } 
  }
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      mode = false;
    } 
  }
}