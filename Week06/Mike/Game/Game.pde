
float rotationX = 0.0;
float rotationZ = 0.0;

float plateWidth = 250;
float plateLength = 250;
float plateHeight = 10;
float speed = 0.025;

float ballRadius = 10;
Mover ball = new Mover();

Cylinder cylinder;
ArrayList<PVector> cylinders = new ArrayList<PVector>();

final float FRAMERATE = 30;
enum Mode{
 PLAY, 
 EDIT
};
Mode mode = Mode.PLAY;

int score;
int lastScore;

PGraphics pg_dataBar;
  int dataBarHeight = 100;
PGraphics pg_game;
PGraphics pg_mini;
  int miniMapHeight = dataBarHeight-10;
  int miniMapWidth = Math.round((plateWidth/plateLength) * miniMapHeight);
PGraphics pg_score;
PGraphics pg_chart;
Chart chart;
PGraphics pg_scrollbar;
  int scrollBarWidth;
  int scrollBarHeight;
HScrollbar scrollbar;
long start;
long current;


void settings() {
   size(600, 600, P3D);
}

void setup() {
   frameRate(FRAMERATE);
   
   start = System.nanoTime();
   current = start;
   
   cylinder = new Cylinder();
   score = 0;
   lastScore = 0;
   pg_dataBar = createGraphics(width, 100, P2D);
   pg_game = createGraphics(width, height-dataBarHeight, P3D);
   pg_mini = createGraphics(miniMapWidth, miniMapHeight, P2D);
   pg_score = createGraphics(80, dataBarHeight-10, P2D);
   pg_chart = createGraphics(width - 5 - miniMapWidth - 15 - 80 - 15 -5, dataBarHeight-27, P2D);
   scrollBarWidth = width - 5 - miniMapWidth - 15 - 80 - 15 - 5;
   scrollBarHeight = 12;
   pg_scrollbar = createGraphics(scrollBarWidth, scrollBarHeight);
   scrollbar = new HScrollbar(5 + miniMapWidth + 15 + 80 + 15, height - 17, 
                              scrollBarWidth, scrollBarHeight);
   chart = new Chart(pg_chart.width, pg_chart.height, 160, 3, scrollbar.getPos(), 100);
}

void draw() {      
  drawGame();   
  drawDataVisuBar();
  drawMini();
  drawScore();
  if (System.nanoTime() - current > 1e9 && mode != Mode.EDIT)
  {
    current = System.nanoTime();
    chart.update(score);
  }
  drawChart();
  scrollbar.update();
  scrollbar.display(pg_scrollbar);
}

// A AMELIORER !!!
// Permet d'ajuster les coordonnées de la souris pour
// contrer l'effet de perspective lorsque l'on souhaite
// afficher le cylindre à l'endroit de la souris
// NE FONCTIONNE PAS AVEC D'AUTRES DIMENSIONS DU PLATEAU
PVector mapMouse(int x, int y)
{
  int tailleApparente = 310; // obtenu en plaçant la souris sur le bord
  // visible du plateau en mode EDIT, et en regardant ses coordonnées
  // entre le bord gauche et le bord droit (et haut et bas)
  return new PVector(x*plateWidth / tailleApparente, 
                     0, 
                     y*plateLength / tailleApparente);
}

void keyPressed()
{
  if (key == CODED)
    if (keyCode == SHIFT)
      mode = Mode.EDIT;
}

void keyReleased()
{
  if (key == CODED)
    if (keyCode == SHIFT)
    {
      mode = Mode.PLAY;
      current = System.nanoTime();
    }
}

void mouseDragged()
{
  switch(mode)
  {
    case PLAY:
    if (pmouseY < pg_game.height)
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
      break;
    default:
      break;
  }
}

void mouseWheel(MouseEvent event){
  switch(mode)
  {
    case PLAY:
      if (event.getCount() > 0)
        speed = speed * 0.9;
      else if (event.getCount() < 0)
        speed = speed * 1.1;
      if (speed < 0.001)
        speed = 0.001;
      if (speed > 0.1)
        speed = 0.1;
      break;
    default:
      break;
  }
}

void mousePressed()
{
  switch(mode)
  {
    case EDIT:
      PVector mapped = mapMouse(mouseX-pg_game.width/2, mouseY-pg_game.height/2);
      PVector d = new PVector(mapped.x - ball.location.x, 
                              0, 
                              mapped.z - ball.location.z);
      float d_size = sqrt(d.x*d.x + d.z*d.z);
                              
      if (mouseButton == LEFT && d_size > ballRadius + cylinder.getBaseSize() &&
          mapped.x >= -plateWidth/2 && mapped.x <= plateWidth/2 &&
          mapped.z >= -plateLength/2 && mapped.z <= plateLength/2)
      {
        cylinders.add(new PVector(mapped.x, 0, mapped.z));
      }
      else if (mouseButton == RIGHT)
      {
        for (int i = 0 ; i < cylinders.size() ; ++i)
        {
          PVector n = new PVector(cylinders.get(i).x - mapped.x, 
                                  0,
                                  cylinders.get(i).z - mapped.z);
          float n_size = sqrt(n.x*n.x + n.z*n.z);
          if (n_size < cylinder.getBaseSize())
          {
            cylinders.remove(i);
          }
        }
      }
      break;
    default:
      break;
  }
}