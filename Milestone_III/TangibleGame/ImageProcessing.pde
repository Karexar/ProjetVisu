void process_image()
{
  //--- On filtre le hue, la saturation, et la brightness
  filter_image(img, MIN_HUE, MAX_HUE, Filter.HUE);  // le vert est officiellement entre 81 et 140
  filter_image(img, MIN_BRIGHTNESS, MAX_BRIGHTNESS, Filter.BRIGHTNESS);  
  filter_image(img, MIN_SATURATION, MAX_SATURATION, Filter.SATURATION);
  filter_image(img, 0, 255, Filter.IF_NOT_X_THEN_Y);
  //--- On floute l'image
  PImage blurred_image = convolute(img);
  
  //--- On filtre l'intensité
  filter_image(blurred_image, MIN_INTENSITY, MAX_INTENSITY, Filter.INTENSITY);
  
  //--- On applique sobel
  PImage img_sobel = sobel(blurred_image);
  
  //--- On applique hough et on récupère les lignes
  ArrayList<PVector> lines = hough(img_sobel, BEST_LINE_NB);
  println(lines.size());
   
  //--- On récupère le meilleur quad
  ArrayList<PVector[]> bestQuad = getBestQuad(lines, img_sobel);
  if (bestQuad != null)
  {
    // On trie le quad
    List<PVector> sortedCorners = sortCorners(Arrays.asList(bestQuad.get(0)));
    // On affiche les angles
    TwoDThreeD tmp = new TwoDThreeD(RES_VIDEO_GAME_X, RES_VIDEO_GAME_Y);
    PVector angles = tmp.get3DRotations(sortedCorners);
    println("affichage des angles : ");
    println(Math.toDegrees(angles.x));
    println(Math.toDegrees(angles.y));
    println(Math.toDegrees(angles.z));
    
    rotationX = angles.x;
    rotationZ = angles.y;
    
    PVector[] q_inter = bestQuad.get(0);
    PVector[] q_lines = bestQuad.get(1);
    
    //--- On affiche les lignes
    loadPixels();
    pg_video.beginDraw();
    pg_video.fill(255, 128, 0);
    display_lines(img, q_lines);
    
    //--- On affiche les intersections
    pg_video.ellipse(q_inter[0].x, q_inter[0].y, 10, 10);
    pg_video.ellipse(q_inter[1].x, q_inter[1].y, 10, 10);
    pg_video.ellipse(q_inter[2].x, q_inter[2].y, 10, 10);
    pg_video.ellipse(q_inter[3].x, q_inter[3].y, 10, 10);
    
    println("TESTESE");
    
    pg_video.endDraw();
    updatePixels();
    image(pg_video, RES_VIDEO_GAME_X, 0);
  }
}