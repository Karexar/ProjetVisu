import processing.video.*;

PImage img;
Capture cam;

/********************************************************/
/***                      SETTINGS                    ***/  
/********************************************************/
/**/      int MIN_VOTES      =   170;                      
/**/      boolean CAM_ACTIVE =   false;
/**/      int IMAGE_NB       =   2;
/**/      int MIN_HUE        =   81;  // 81 normalement
/**/      int MAX_HUE        =   140; // 140 normalement
/**/      int MIN_BRIGHTNESS =   10;
/**/      int MAX_BRIGHTNESS =   220;
/**/      int MIN_SATURATION =   70;
/**/      int MAX_SATURATION =   255;
/**/      int MIN_INTENSITY  =   100;
/**/      int MAX_INTENSITY  =   255;
/**/      int BEST_LINE_NB   =   4;
/**/      int MIN_AREA       =   30000;
/**/      int MAX_AREA       =   1500000;
/********************************************************/

void settings() 
{
  if (CAM_ACTIVE)
    size(640 + 400, 360);
  else
    size(800 + 400, 600);
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
  
  //image(img, 0, 0);
  
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
  image(img_sobel, 0, 0);
  
  //--- On applique hough
  ArrayList<PVector> lines = hough(img_sobel, BEST_LINE_NB);
  println("lines : " + lines);
  QuadGraph graph = new QuadGraph();
  graph.build(lines, width-400, height);
  List<int[]> cycles = graph.findCycles();
  println("cycles : " + cycles.size());
  List<int[]> quads = new ArrayList<int[]>();
  List<PVector[]> final_quads = new ArrayList<PVector[]>();
  // On garde uniquement les cycles de taille 4
  for (int[] c : cycles)
    if (c.length == 4)
      quads.add(c);
  println("quads : " + cycles.size());
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
    /*if (graph.isConvex(c12, c23, c34, c41) && 
        graph.validArea(c12, c23, c34, c41, MAX_AREA, MIN_AREA) &&
        graph.nonFlatQuad(c12, c23, c34, c41)) 
        {
          PVector[] q = {c12, c23, c34, c41};
          final_quads.add(q);
        }*/
    PVector[] q = {c12, c23, c34, c41};
    println("intersections : " + c12 + " " + c23 + " " +c34 + " " +c41);
    final_quads.add(q);
  }
  
  //--- On affiche les quads
  for (PVector[] q : final_quads)
  {
    // Choose a random, semi-transparent colour
    Random random = new Random();
    fill(color(min(255, random.nextInt(300)),
                min(255, random.nextInt(300)),
                min(255, random.nextInt(300)), 50));
    
    quad(q[0].x, q[0].y, q[1].x, q[1].y, q[2].x, q[2].y, q[3].x, q[3].y); 
    //quad(c12.x,c12.y,c23.x,c23.y,c34.x,c34.y,c41.x,c41.y);
  }
}