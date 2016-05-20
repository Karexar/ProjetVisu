import processing.video.*;

PImage img;
Capture cam;

/********************************************************/
/***                      SETTINGS                    ***/  
/********************************************************/
/**/      int MIN_VOTES      =   150;                      
/**/      boolean CAM_ACTIVE =   false;
/**/      int IMAGE_NB       =   1;
/**/      int RES_IMG_X      =   600;
/**/      int RES_IMG_Y      =   450;
/**/      int MIN_HUE        =   81;  // 81 normalement
/**/      int MAX_HUE        =   140; // 140 normalement
/**/      int MIN_BRIGHTNESS =   10;
/**/      int MAX_BRIGHTNESS =   220;
/**/      int MIN_SATURATION =   70;
/**/      int MAX_SATURATION =   255;
/**/      int MIN_INTENSITY  =   100;
/**/      int MAX_INTENSITY  =   255;
/**/      int BEST_LINE_NB   =   6;
/**/      int MIN_AREA       =   50000;
/**/      int MAX_AREA       =   750000;
/********************************************************/

int RES_ACC_X = RES_IMG_Y;
int RES_ACC_Y = RES_IMG_Y;

void settings() 
{
  if (CAM_ACTIVE)
    size(640 + 400, 360);
  else
    size(RES_IMG_X + RES_ACC_X + RES_IMG_X, RES_IMG_Y);
}

void setup() 
{
  if (CAM_ACTIVE)
  {
    String[] cameras = Capture.list();
    if (cameras.length == 0) 
    {
      println("There are no cameras available for capture.");
      exit();
    } 
    else 
    {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) 
      {
        println(cameras[i]);
      }
      cam = new Capture(this, cameras[4]);
      cam.start();
    }
  }
  else
  {  
    img = loadImage("board" + IMAGE_NB + ".jpg");
    img.resize(RES_IMG_X, RES_IMG_Y);
    noLoop();
  }
}

void draw() 
{
  if (CAM_ACTIVE)
  {
    if (cam.available() == true) 
    {
      cam.read();
    }
    img = cam.get();
  }
  
  image(img, 0, 0);
  
  //--- On filtre le hue, la saturation, et la brightness
  filter_image(img, MIN_HUE, MAX_HUE, Filter.HUE);  // le vert est officiellement entre 81 et 140
  filter_image(img, MIN_BRIGHTNESS, MAX_BRIGHTNESS, Filter.BRIGHTNESS);  
  filter_image(img, MIN_SATURATION, MAX_SATURATION, Filter.SATURATION);
  filter_image(img, 0, 255, Filter.IF_NOT_X_THEN_Y);
  //image(img, 0, 0);
  
  //--- On floute l'image
  PImage blurred_image = convolute(img);
  //image(blurred_image, 0, 0);
  
  //--- On filtre l'intensité
  filter_image(blurred_image, MIN_INTENSITY, MAX_INTENSITY, Filter.INTENSITY);
  
  //--- On applique sobel
  PImage img_sobel = sobel(blurred_image);
  
  //--- On applique hough et on récupère les lignes
  ArrayList<PVector> lines = hough(img_sobel, BEST_LINE_NB);
  //--- On crée le quadgraph
  QuadGraph graph = new QuadGraph();
  graph.build(lines, img_sobel.width, img_sobel.height);
  //--- On récupère les cycles d'après les intersections de lignes
  List<int[]> cycles = graph.findCycles();
  // On garde uniquement les cycles de taille 4
  List<int[]> quads = new ArrayList<int[]>();
  for (int[] c : cycles)
    if (c.length == 4)
      quads.add(c);

  //--- On crée la liste des quads finaux, chaque étant un PVector des intersections
  List<PVector[]> final_quads = new ArrayList<PVector[]>();
  for (int[] quad : quads)
  {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    
    // (intersection() is a simplified version of the
    // intersections() method you wrote last week, that simply
    // return the coordinates of the intersection between 2 lines) 
    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);  
    PVector c41 = intersection(l4, l1);
    
    // On applique les critères pour garder uniquement les quads valides
    if (graph.isConvex(c12, c23, c34, c41) && 
        graph.validArea(c12, c23, c34, c41, MAX_AREA, MIN_AREA) &&
        graph.nonFlatQuad(c12, c23, c34, c41)) 
        {
          PVector[] q = {c12, c23, c34, c41};
          final_quads.add(q);
        }
  }
  
  //--- On garde uniquement le quad le plus grand
  if (final_quads.size() > 0)
  {
    PVector[] bestQuad = final_quads.get(0);
    float bestQuadArea = graph.area(bestQuad[0], bestQuad[1], bestQuad[2], bestQuad[3]);
    for (int i = 1 ; i < final_quads.size() ; ++i)
    {
      PVector[] q = final_quads.get(i);
      float qArea = graph.area(q[0], q[1], q[2], q[3]);
      if (qArea > bestQuadArea)
      {
        bestQuad = q;
        bestQuadArea = qArea;
      }
    }
   
    //On affiche le quad le plus grand
    PVector[] q = bestQuad;
    /*Random random = new Random();
    fill(color(min(255, random.nextInt(300)),
                min(255, random.nextInt(300)),
                min(255, random.nextInt(300)), 50));
    
    quad(q[0].x, q[0].y, q[1].x, q[1].y, q[2].x, q[2].y, q[3].x, q[3].y);*/
    
    // On affiche les intersections
    
    fill(255, 128, 0);
    ellipse(q[0].x, q[0].y, 10, 10);
    ellipse(q[1].x, q[1].y, 10, 10);
    ellipse(q[2].x, q[2].y, 10, 10);
    ellipse(q[3].x, q[3].y, 10, 10);
   
  }
  
  // On affiche à droite le résultat du sobel
  
  image(img_sobel, RES_IMG_X + RES_ACC_X, 0);
  
  /*//--- On affiche les quads
  for (PVector[] q : final_quads)
  {
    // Choose a random, semi-transparent colour
    Random random = new Random();
    fill(color(min(255, random.nextInt(300)),
                min(255, random.nextInt(300)),
                min(255, random.nextInt(300)), 50));
    
    quad(q[0].x, q[0].y, q[1].x, q[1].y, q[2].x, q[2].y, q[3].x, q[3].y); 
  }*/
  
}