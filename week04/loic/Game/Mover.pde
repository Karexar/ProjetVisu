class Mover {

  PVector location;
  PVector velocity;
  PVector gravityForce;
  float gravityConstant = 0.981;
  float delta = 1.0/30.0;

  Mover() {
    location = new PVector(0,0,0);
    velocity = new PVector(0, 0, 0);
    gravityForce  = new PVector(0, 0,0);
  }
  
  void update(float rotX, float rotZ) {
    gravityForce.x = sin(rotZ) * gravityConstant;
    gravityForce.z = -sin(rotX) * gravityConstant;
    gravityForce.mult(delta);
    velocity.add(gravityForce);
      
    float normalForce = 1;
    float mu =0.01;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(friction);
    //velocity.mult(0.9);
    
    location.add(velocity);
  }
  
  void display() {
    sphere(dimSphere);
  }
  
  void checkEdges(float dimSphere, float dimX, float dimZ) {
    
    float diffXPos = location.x + dimSphere/2 - dimX/2;
    float diffXNeg = location.x - dimSphere/2 + dimX/2;
    if (diffXPos > 0) {
      velocity.x *= -1;
      //location.x -= diffXPos;
    } else if (diffXNeg < 0){
      velocity.x *= -1;
      //location.x -= diffXNeg;
    }
    
    float diffZPos = location.z + dimSphere/2 - dimZ/2;
    float diffZNeg = location.z - dimSphere/2 + dimZ/2;
    if (diffZPos > 0) {
      velocity.z *= -1;
      //location.z -= diffZPos;
    } else if (diffZNeg < 0){
      velocity.z *= -1;
      //location.z -= diffZNeg;
    }
  }
}