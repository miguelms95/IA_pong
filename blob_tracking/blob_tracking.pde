import processing.video.*;



Capture video;



color trackColor; 

float threshold = 25;

float distThreshold = 50;



ArrayList<Blob> blobs = new ArrayList<Blob>();

Pelota pelota;

void setup() {

  size(1280, 720);

  String[] cameras = Capture.list();

  printArray(cameras);

  video = new Capture(this, 1280, 720);

  video.start();

  trackColor = color(255, 0, 0);
  
  pelota = new Pelota(100,100);
  
}



void captureEvent(Capture video) {
  video.read();
}



void keyPressed() {

  if (key == 'a') { // aumenta distancia del umbral 
    distThreshold += 5;
  } else if (key == 'z') { // disminuye distancia del umbral 
    distThreshold -= 5;  
  }

  if (key == 's') { // aumenta umbral
    threshold+=5;
  } else if (key == 'x') {  // disminuye umbral
    threshold-=5;
  }

  println(distThreshold);
}



void draw() {
  video.loadPixels();
  image(video, 0, 0);
  blobs.clear();
  
  pelota.pintar();

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;

      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      
      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {
        boolean found = false;

        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }

  for (Blob b : blobs) {
    if (b.size() > 500) {
      b.show();
    }
  }

  textAlign(RIGHT);
  fill(0);
  text("distance threshold: " + distThreshold, width-10, 25);
  text("color threshold: " + threshold, width-10, 50);
}

// Custom distance functions w/ no square root for optimization
float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}