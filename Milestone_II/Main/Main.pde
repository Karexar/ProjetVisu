import processing.video.*;

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


PImage img;
Capture cam;

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

  //--- On récupère le meilleur quad
  ArrayList<PVector[]> bestQuad = getBestQuad(lines, img_sobel);
  if (bestQuad != null)
  {
    PVector[] q_inter = bestQuad.get(0);
    PVector[] q_lines = bestQuad.get(1);

    //--- On affiche les lignes
    fill(255, 128, 0);
    display_lines(img, q_lines);

    //--- On affiche les intersections
    ellipse(q_inter[0].x, q_inter[0].y, 10, 10);
    ellipse(q_inter[1].x, q_inter[1].y, 10, 10);
    ellipse(q_inter[2].x, q_inter[2].y, 10, 10);
    ellipse(q_inter[3].x, q_inter[3].y, 10, 10);
  }

  // On affiche à droite le résultat du sobel
  image(img_sobel, RES_IMG_X + RES_ACC_X, 0);
}
