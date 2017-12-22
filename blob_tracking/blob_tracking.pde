import processing.video.*;

Capture video;


color trackColor; 

float threshold = 25;

float distThreshold = 50;

// No hace falta
ArrayList<Blob> blobs = new ArrayList<Blob>();

// Añadido Angela y Lucia
color color1 = 0;
Blob blob1 = null;
boolean asignada1 = false;

// Añadido Angela y Lucia
color color2 = 0;
Blob blob2 = null;
boolean asignada2 = false;

int marcadorIzq;
int marcadorDer;
boolean pause;

Pelota pelota;

void setup() {

  size(1280, 720);
  
  String[] cameras = Capture.list();
  
  printArray(cameras);

  video = new Capture(this, 1280, 720);
  
  video.start();
  
  // meter opacidad fondo.

  trackColor = color(255, 0, 0);

  marcadorIzq = 0;
  marcadorDer = 0;
  
  pause = false;  
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
  
  //No hace falta
  blobs.clear();

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;

      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      
          // No haria falta
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
          
      // Añadido Angela y Lucia
      if(color1 != 0 && trackColor == color1){
        pintarPala1(x,y,r1, g1, b1);
        trackColor = color2== 0? trackColor : color2;
      }
      
      if(color2 != 0 && trackColor == color2){
         pintarPala2(x, y, r1, g1, b1);
         trackColor = color1;
      }
    }
  }

      //No hace falta
      for (Blob b : blobs) {
        if (b.size() > 500) {
          b.show();
        }
      }

      pelota.pintar();
      pelota.aplicarMovimiento();

      imprimeMarcadores();
      
  //Añadido por Angela y Lucia
  if(blob1 != null){
      blob1.show();
  }
  if(blob2 != null){
     blob2.show(); 
  }
  
}

void imprimeMarcadores(){
  textAlign(RIGHT);
  fill(0);
  textSize(16);
  text("distance threshold: " + distThreshold, width-10, 25);
  text("color threshold: " + threshold, width-10, 50);
  
  //Linea central
  fill(0,0,0,180);
  rect(width/2-5, 0, 10,height);
  
  //Marcadores
  textAlign(CENTER);
  textSize(width/15);
  text(marcadorIzq,width/2-width/15, height/10);
  text(marcadorDer,width/2+width/15, height/10);
  
  //Simbolo de pausa
  if(pause){
    rect(25, 25, width/40, height/7);
    rect(45+width/40, 25, width/40, height/7);
  }
}

// Añadido por Angela y Lucia
void pintarPala1(float x, float y, float r1, float g1, float b1){
    float r2 = red(color1);
    float g2 = green(color1);
    float b2 = blue(color1);
        
    float d = distSq(r1, g1, b1, r2, g2, b2); 
    if (d < threshold*threshold ) {
      blob1 = color1 != 0? new Blob(x,y): blob1;
    }
}
void pintarPala2(float x, float y, float r1, float g1, float b1){
    float r2 = red(color2);
    float g2 = green(color2);
    float b2 = blue(color2);
        
    float d = distSq(r1, g1, b1, r2, g2, b2); 
    if (d < threshold*threshold ) {
      blob2 = color2 != 0? new Blob(x,y): blob2;
    }
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
  if (!paletasCreadas()){
    int loc = mouseX + mouseY*video.width;
    trackColor = video.pixels[loc];
    color2 = color2 == 0 && color1 != 0? trackColor: color2;
    color1 = color1 == 0? trackColor: color1;
  }
}

// Añadido por Anegela y Lucia
boolean paletasCreadas(){
 if (blob1 != null && blob2 != null){
  return true; 
 } else {
  return false; 
 }
}
