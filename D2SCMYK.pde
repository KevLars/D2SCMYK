///////////////////////////////////////////////////////////////////////////////////////////////////////
// My Drawbot, "Death to Sharpie"
// Jpeg to gcode simplified (kinda sorta works version, v3.2 (beta))
//
// Scott Cooper, Dullbits.com, <scottslongemailaddress@gmail.com>
//
// PDF Export added by Jan Krummrey, jan.krummrey.de
//
// CMYK layer support added by Lars Poort
//
// Open creative GPL source commons with some BSD public GNU foundation stuff sprinkled in...
// If anything here is remotely useable, please give me a shout.
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Constants set by user, or maybe your sister.
final float   paper_size_x = 32 * 25.4;
final float   paper_size_y = 40 * 25.4;
final float   image_size_x = 30 * 25.4;
final float   image_size_y = 35 * 25.4;
final float   paper_top_to_origin = 417;  //mm

// Super fun things to tweak.  Not candy unicorn type fun, but still...
final int     squiggle_total = 1000;     // Total times to pick up the pen for each layer
final int     squiggle_length = 100;    // Too small will fry your servo
final int     half_radius = 3;          // How grundgy
final int     adjustbrightness = 2;     // How fast it moves from dark to light, over draw
//lower brightness focusses the drawn squiggles more, higher brightness means the squiggles are spread out
final float   sharpie_dry_out = 0.03;  // Simulate the death of sharpie, zero for super sharpie

final String picture = "korra"; //filename must have extension -"color".jpg, 
//otherwise change individual layers below

StringList piclayer;
String pic = "0";
int rgb = #FFFFFF;

float percentCyan = 0.25;
float percentMagenta = 0.25;
float percentYellow = 0.25;
float percentBlack = 0.25;

//These are colors that i think my sharpies have
//Nothing is changed to the output files, only your preview changes
int DrawColorgreen = #00FF00;
int DrawColorlightblue = #00c5ff; //colors given in hex
int DrawColoryellow = #FFFF00;
int DrawColorpink = #FF00DD;
int DrawColorblack = #000000;
int DrawColorred = #FF0000;
int DrawColorblue = #0000FF;

//Every good program should have a shit pile of badly named globals.
int    screen_offset = 4;
float  screen_scale = 1.0;
int    steps_per_inch = 10;
int    x_old = 0;
int    y_old = 0;
PImage img;
int    darkest_x = 100;
int    darkest_y = 100;
float  darkest_value;
int    squiggle_count;
int    x_offset = 0;
int    y_offset = 0;
float  drawing_scale;
float  drawing_scale_x;
float  drawing_scale_y;
int    drawing_min_x =  9999999;
int    drawing_max_x = -9999999;
int    drawing_min_y =  9999999;
int    drawing_max_y = -9999999;
int    center_x;
int    center_y;
boolean is_pen_down;
PrintWriter OUTPUT;       // instantiation of the JAVA PrintWriter object.

int i=0;
int k=0;

int squiggle_count_total;

import processing.pdf.*;


///////////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  size(900, 975, P2D);
  noSmooth();
  colorMode(RGB, 100);
  background(100, 100, 100);  
  frameRate(120);

  piclayer = new StringList();
  piclayer.append("pics/"+ picture +"-cyan.jpg"); //change file extensions if saved in other formats here
  piclayer.append("pics/"+ picture +"-magenta.jpg");
  piclayer.append("pics/"+ picture +"-yellow.jpg");
  piclayer.append("pics/"+ picture +"-black.jpg");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  println(squiggle_count);
  noFill();
  scale(screen_scale);
  if (k==0) {
    if (i==0) {
      pic = piclayer.get(0);
      rgb = DrawColorlightblue;
      OUTPUT = createWriter(picture+"-cyan.txt");
      beginRecord(PDF, picture+"-cyan.PDF"); 
      pen_up();
      setup_squiggles();
      img.loadPixels();
      i=i+1;
    }
    if (squiggle_count >= percentCyan*squiggle_total) {
      i=0;
      k=k+1;
      dump_some_useless_stuff_and_close();
    }
  }
  if (k==1) {
    if (i==0) {
      pic = piclayer.get(1);
      rgb = DrawColorpink;
      OUTPUT = createWriter(picture+"-magenta.txt");
      beginRecord(PDF, picture+"-magenta.PDF"); 
      pen_up();
      setup_squiggles();
      img.loadPixels();
      i=i+1;
    }
    if (squiggle_count >= percentMagenta*squiggle_total) {
      i=0;
      k=k+1;
      dump_some_useless_stuff_and_close();
    }
  }
  if (k==2) {
    if (i==0) {
      pic = piclayer.get(2);
      rgb = DrawColoryellow;
      OUTPUT = createWriter(picture+"-yellow.txt");
      beginRecord(PDF, picture+"-yellow.PDF"); 
      pen_up();
      setup_squiggles();
      img.loadPixels();
      i=i+1;
    }
    if (squiggle_count >= percentYellow*squiggle_total) {
      i=0;
      k=k+1;
      dump_some_useless_stuff_and_close();
    }
  }
  if (k==3) {
    if (i==0) {
      pic = piclayer.get(3);
      rgb = DrawColorblack;
      OUTPUT = createWriter(picture+"-black.txt");
      beginRecord(PDF, picture+"-black.PDF"); 
      pen_up();
      setup_squiggles();
      img.loadPixels();
      i=i+1;
    }
    if (squiggle_count >= percentBlack*squiggle_total) {
      i=0;
      k=k+1;
      dump_some_useless_stuff_and_close();
    }
  }
  random_darkness_walk();
  if (squiggle_count_total >= squiggle_total) {
    //endRecord();
    //grid();
    println("DONE DONE DONE DONE DONE DONE DONE DONE DONE DONE DONE DONE");
    println("DONE DONE DONE DONE DONE DONE DONE DONE DONE DONE DONE DONE");
    noLoop();
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
void setup_squiggles() {
  img = loadImage(sketchPath("") + pic);  // Load the image into the program  
  img.loadPixels();

  drawing_scale_x = image_size_x / img.width;
  drawing_scale_y = image_size_y / img.height;
  drawing_scale = min(drawing_scale_x, drawing_scale_y);

  println("Picture: " + pic);
  println("Image dimensions: " + img.width + " by " + img.height);
  println("adjustbrightness: " + adjustbrightness);
  println("squiggle_total: " + squiggle_total);
  println("squiggle_length: " + squiggle_length);
  println("Paper size: " + nf(paper_size_x, 0, 2) + " by " + nf(paper_size_y, 0, 2) + "      " + nf(paper_size_x/25.4, 0, 2) + " by " + nf(paper_size_y/25.4, 0, 2));
  println("Max image size: " + nf(image_size_x, 0, 2) + " by " + nf(image_size_y, 0, 2) + "      " + nf(image_size_x/25.4, 0, 2) + " by " + nf(image_size_y/25.4, 0, 2));
  println("Calc image size " + nf(img.width * drawing_scale, 0, 2) + " by " + nf(img.height * drawing_scale, 0, 2) + "      " + nf(img.width * drawing_scale/25.4, 0, 2) + " by " + nf(img.height * drawing_scale/25.4, 0, 2));
  println("Drawing scale: " + drawing_scale);

  // Used only for gcode, not screen.
  x_offset = int(-img.width * drawing_scale / 2.0);  
  y_offset = - int(paper_top_to_origin - (paper_size_y - (img.height * drawing_scale)) / 2.0);
  println("X offset: " + x_offset);  
  println("Y offset: " + y_offset);  

  // Used only for screen, not gcode.
  center_x = int(width  / 2 * (1 / screen_scale));
  center_y = int(height / 2 * (1 / screen_scale) - (steps_per_inch * screen_offset));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void grid() {
  // This will give you a rough idea of the size of the printed image, in inches.
  // Some screen scales smaller than 1.0 will sometimes display every other line
  // It looks like a big logic bug, but it just can't display a one pixel line scaled down well.
  stroke(0, 50, 100, 30);
  for (int xy = -30*steps_per_inch; xy <= 30*steps_per_inch; xy+=steps_per_inch) {
    line(xy + center_x, 0, xy + center_x, 200000);
    line(0, xy + center_y, 200000, xy + center_y);
  }

  stroke(0, 100, 100, 50);
  line(center_x, 0, center_x, 200000);
  line(0, center_y, 200000, center_y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void dump_some_useless_stuff_and_close() {
  println ("Extreams of X: " + drawing_min_x + " thru " + drawing_max_x);
  println ("Extreams of Y: " + drawing_min_y + " thru " + drawing_max_y);
  squiggle_count = 0;
  endRecord();
  OUTPUT.flush();
  OUTPUT.close();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

