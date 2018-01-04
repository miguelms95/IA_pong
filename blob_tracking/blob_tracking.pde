import processing.video.*;

Capture video;


color trackColor; 
float threshold = 15;
float distThreshold = 10;

// Añadido Angela y Lucia
color color1 = 0;
Blob blob1 = null;
boolean asignada1 = false;

// Añadido Angela y Lucia
color color2 = 0;
Blob blob2 = null;
boolean asignada2 = false;

// Lado de cada pala. TRUE = derecha / FALSE = izquierda.
boolean lado;

int marcadorIzq;
int marcadorDer;
boolean pause;

Pelota pelota;
boolean juego = false;

void setup() {
  size(1280, 720);
  
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, 1280, 720);
  video.start();
  
  // meter opacidad fondo.
  
  //trackColor = color(255, 0, 0);
  marcadorIzq = 0;
  marcadorDer = 0;
  
  pause = false;  
  pelota = new Pelota(100,100);
}

void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (key == 'a' || key == 'A') { // aumenta distancia del umbral 
    distThreshold += 5;
  } else if (key == 'z' || key == 'Z') { // disminuye distancia del umbral 
    distThreshold -= 5;  
  }

  if (key == 's' || key == 'S') { // aumenta umbral
    threshold+=5;
  } else if (key == 'x' || key == 'X') {  // disminuye umbral
    threshold-=5;
  }
  
  if ((key == 'j' || key == 'J') && (!juego)){
     juego = true;
  }
  
  println(distThreshold);
}



void draw() {
  if (!juego){
    background(255);
    String p = "PONG - INFORMÁTICA AUDIOVISUAL";
    textAlign(CENTER);
    textSize(width*0.08);
    fill(255, 0, 0);
    text(p, width*0.04, height*0.1, width*0.9, height*0.5);
    
    String j = "-Pulsa 'j' para jugar";
    textSize(width*0.06);
    textAlign(CENTER);
    fill(255, 0, 0);
    text(j, width*0.06, height*0.6, width*0.9, height*0.5);
  }
  else {
    video.loadPixels();
    image(video, 0, 0);
    
    // Begin loop to walk through every pixel
    for (int x = 0; x < video.width; x++ ) {
      for (int y = 0; y < video.height; y++ ) {
        int loc = x + y * video.width;
  
        color currentColor = video.pixels[loc];
        float r1 = red(currentColor);
        float g1 = green(currentColor);
        float b1 = blue(currentColor);
            
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
    
    if(blob1 != null){
        blob1.show();
    }
    if(blob2 != null){
       blob2.show(); 
    }
    if(blob1 != null && blob2 != null){
      pelota.pintar();
      pelota.aplicarMovimiento();
    }
    imprimeMarcadores();
    
  }
}

void imprimeMarcadores(){
  textAlign(RIGHT);
  fill(0);
  textSize(16);
  text("distance threshold: " + distThreshold, width-10, 25);
  text("color threshold: " + threshold, width-10, 50);
  
  //Linea central
  strokeWeight(5);
  line(width/2, 0, width/2, height);
  
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

void pintarPala1(float x, float y, float r1, float g1, float b1){
    float r2 = red(color1);
    float g2 = green(color1);
    float b2 = blue(color1);
        
    float d = distSq(r1, g1, b1, r2, g2, b2); 
    if (d < threshold*threshold ) {
      blob1 = color1 != 0? new Blob(x,y,lado): blob1;
    }
}

void pintarPala2(float x, float y, float r1, float g1, float b1){
    float r2 = red(color2);
    float g2 = green(color2);
    float b2 = blue(color2);
        
    float d = distSq(r1, g1, b1, r2, g2, b2); 
    if (d < threshold*threshold ) {
      blob2 = color2 != 0? new Blob(x,y,!lado): blob2;
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
  if (!paletasCreadas() && juego){
    int loc = mouseX + mouseY*video.width;
    
    lado = blob1 == null ? ((mouseX < width/2.0) ? true : false) : lado;
      
    trackColor = video.pixels[loc];
    color2 = color2 == 0 && color1 != 0? trackColor: color2;
    color1 = color1 == 0? trackColor: color1;
  }
}

boolean paletasCreadas(){
  if (blob1 != null && blob2 != null){
    return true; 
  } else {
    return false; 
  }
}