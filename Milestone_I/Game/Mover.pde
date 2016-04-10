class Mover {
      PVector location;
      PVector velocity;
      float gravityConstant;
      float elasticiteBord;
      float elasticiteObstacle;
      PVector gravity;
      
      
      Mover() {
        location = new PVector(0, 0, 0);
        velocity = new PVector(0, 0, 0);
        gravity = new PVector(0, 0, 0);
        gravityConstant = 9.81;
        elasticiteBord = 0.5;
        elasticiteObstacle = 0.8;
      }
      
      void update() {
        gravity.x = sin(rotationZ) * gravityConstant / FRAMERATE;
        gravity.z = -sin(rotationX) * gravityConstant / FRAMERATE;
        velocity.add(gravity);
        float normalForce = 1;
        float mu = 0.05; // par défaut 0.01
        float frictionMagnitude = normalForce * mu;
        PVector friction = velocity.copy();
        friction.mult(-1);
        friction.normalize();
        friction.mult(frictionMagnitude);
        
        velocity.add(friction);
        location.add(velocity);
        checkEdges();
        checkCylinderCollision();
        //checkLocation();
      }
      
      void checkEdges() {
        if (location.x > plateWidth/2) {
          location.x = plateWidth/2;
          velocity.x = velocity.x*-1*elasticiteBord;
        }
        else if (location.x < -plateWidth/2) {
          location.x = -plateWidth/2;
          velocity.x = velocity.x*-1*elasticiteBord;
        }
        if (location.z > plateLength/2) {
          location.z = plateLength/2;
          velocity.z = velocity.z*-1*elasticiteBord;
        }
        else if (location.z < -plateLength/2) {
          location.z = -plateLength/2;
          velocity.z = velocity.z*-1*elasticiteBord;
        }
      } 
      
      void checkCylinderCollision() {
        for (int i = 0 ; i < cylinders.size() ; ++i)
        {
          PVector n = new PVector(cylinders.get(i).x - location.x, 
                                  0,
                                  cylinders.get(i).z - location.z);
          float n_size = sqrt(n.x*n.x + n.z*n.z);
          float limite = cylinder.getBaseSize() + ballRadius;
          if (n_size < limite)
          {
            PVector n_norm = n.normalize();
            PVector v1 = velocity.copy();
            PVector v2 = velocity.copy();
            velocity = v1.sub(n_norm.mult(2*(v1.dot(n_norm))));
            velocity.mult(elasticiteObstacle);
            location.sub(v2);
          }
        }
      }
      
      void checkLocation()
      {
        for (int i = 0 ; i < cylinders.size() ; ++i)
        {
          // On calcule le vecteur sortant du cylindre en direction de la boule
          PVector n = new PVector(location.x - cylinders.get(i).x, 
                                  0,
                                  location.z - cylinders.get(i).z);
          float n_size = sqrt(n.x*n.x + n.z*n.z);
          float limite = cylinder.getBaseSize() + ballRadius;
          while (n_size < limite)
          {
            location.add(n.mult(0.01));
            n = new PVector(location.x - cylinders.get(i).x, 
                                  0,
                                  location.z - cylinders.get(i).z);
            n_size = sqrt(n.x*n.x + n.z*n.z);
          }
        }
      }
}