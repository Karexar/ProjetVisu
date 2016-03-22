class Mover {
      PVector location;
      PVector velocity;
      float gravityConstant;
      float elasticite;
      PVector gravity;
      
      
      Mover() {
        location = new PVector(0, 0, 0);
        velocity = new PVector(0, 0, 0);
        gravity = new PVector(0, 0, 0);
        gravityConstant = 9.81;
        elasticite = 0.5;
      }
      
      void update() {
        gravity.x = sin(rotationZ) * gravityConstant / FRAMERATE;
        gravity.z = -sin(rotationX) * gravityConstant / FRAMERATE;
        
        float normalForce = 1;
        float mu = 0.05; // par défaut 0.01
        float frictionMagnitude = normalForce * mu;
        PVector friction = velocity.get();
        friction.mult(-1);
        friction.normalize();
        friction.mult(frictionMagnitude);
        
        velocity.add(gravity);
        velocity.add(friction);
        location.add(velocity);
        
        checkEdges();
      }
       
      /*void display() {
        stroke(0);
        strokeWeight(2);
        fill(127);
        ellipse(location.x, location.y, 48, 48);
      }*/
      
      void checkEdges() {
        if (location.x > plateWidth/2) {
          location.x = plateWidth/2;
          velocity.x = velocity.x*-1*elasticite;
        }
        else if (location.x < -plateWidth/2) {
          location.x = -plateWidth/2;
          velocity.x = velocity.x*-1*elasticite;
        }
        if (location.z > plateLength/2) {
          location.z = plateLength/2;
          velocity.z = velocity.z*-1*elasticite;
        }
        else if (location.z < -plateLength/2) {
          location.z = -plateLength/2;
          velocity.z = velocity.z*-1*elasticite;
        }
      } 
}