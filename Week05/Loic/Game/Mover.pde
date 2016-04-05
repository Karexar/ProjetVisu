class Mover {

  PVector location;
  PVector velocity;
  PVector gravityForce;
  float gravityConstant = 9.81;
  float delta = 1.0/30.0;
  float coefRebond = 0.5;

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
    float mu =0.05;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(friction);
    
    location.add(velocity);
  }
  
  void display() {
    sphere(dimSphere);
  }
  
  void checkEdges(float dimSphere, float dimX, float dimZ) {
    
    float diffXPos = location.x + dimSphere - dimX/2;
    float diffXNeg = location.x - dimSphere + dimX/2;
    if (diffXPos > 0) {
      velocity.x *= -coefRebond;
      location.x -= diffXPos;
      
    } else if (diffXNeg < 0){
      velocity.x *= -coefRebond;
      location.x -= diffXNeg;
      
    }
    
    float diffZPos = location.z + dimSphere/2 - dimZ/2;
    float diffZNeg = location.z - dimSphere/2 + dimZ/2;
    if (diffZPos > 0) {
      velocity.z *= -coefRebond;
      location.z -= diffZPos;
      
      
    } else if (diffZNeg < 0){
      velocity.z *= -coefRebond;
      location.z -= diffZNeg;
      
    }
    checkCylinderCollision();                  
    
  }
  
void checkCylinderCollision() {
    for(int i=0; i < cylinders.size(); ++i){
      
        PVector n = new PVector(cylinders.get(i).x - location.x, 
                                0,
                                cylinders.get(i).y - location.z);
        float n_size = sqrt(n.x*n.x + n.z*n.z);
        float limite = cylinderBaseSize + dimSphere;
        if (n_size < limite)
        {
            
          PVector n_norm = n.normalize();
          PVector v1 = velocity.copy();
          PVector v2 = velocity.copy();
          velocity = (v1.sub(n_norm.mult(2*(v1.dot(n_norm))))).mult(coefRebond);
            
          location.sub(v2);
        } 
    }
  }
}