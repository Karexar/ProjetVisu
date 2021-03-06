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
        elasticiteObstacle = 0.9;
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
        
        checkEdges();
        checkCylinderCollision();
        
        location.add(velocity);
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
      
      // A AMELIORER : Parfois ça bug, la balle est aspirée par un cylindre
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
            PVector v1 = velocity;
            velocity = v1.sub(n_norm.mult(2*(v1.dot(n_norm))));
            //velocity = velocity.mult(elasticiteObstacle);
          }
        }
      }
      /*void checkCylinderCollision() {
        int i = 0;
        boolean freePath = true;
        while (i < cylinders.size() && freePath)
        {
          PVector n = new PVector(cylinders.get(i).x - location.x, 
                                  0,
                                  cylinders.get(i).z - location.z);
          float n_size = sqrt(n.x*n.x + n.z*n.z);
          float limite = cylinder.getBaseSize() + ballRadius;
          if (n_size < limite)
          {
            PVector n_norm = n.normalize();
            PVector v1 = velocity;
            velocity = v1.sub(n_norm.mult(2*(v1.dot(n_norm))));
            //velocity = velocity.mult(elasticiteObstacle);
            
          }
          ++i;
        }
      }*/
}