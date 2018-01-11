import ddf.minim.*; //<>// //<>//
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.video.*;
import java.util.Random;

Capture video;

Minim minim;
FilePlayer filePlayer;
AudioOutput musica;
float volumen = 0;
String pathCancion = "cancion.mp3";

color trackColor; 
float threshold = 15;
float distThreshold = 10;

color color1 = 0;
Blob blob1 = null;
boolean asignada1 = false;


color color2 = 0;
Blob blob2 = null;
boolean asignada2 = false;


// Lado de cada pala. TRUE = derecha / FALSE = izquierda.
boolean lado;

int marcadorIzq;
int marcadorDer;

boolean musicaOn = false;
float volumenActual;
int tiempoReaccion = 10;

Pelota pelota;

int estado; //0 - nuevo juego     1 - pausa      2 - en partida       3 - victoria

PFont fuente;
PFont original;

int puntosFinales = 10;

void setup() {
  fuente = createFont("square.ttf",40);
  original = createFont("LSANS.TTF",12);
  String[] cameras = Capture.list();
  printArray(cameras);
  println("camara mejor" + cameras[cameras.length-1]);
  
  //size(640, 480);
  size(1920, 1080);
  
  
  video = new Capture(this, 1920,1080);
  video.start();
  
  
  // meter opacidad fondo.
  
  //trackColor = color(255, 0, 0);
  marcadorIzq = 0;
  marcadorDer = 0;
  
  estado = 0;
  iniciarPelota();
  
  minim = new Minim(this);
  filePlayer = new FilePlayer( minim.loadFileStream(pathCancion));
  musica = minim.getLineOut();
  filePlayer.patch(musica);
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
  
  if ((key == 'j' || key == 'J') && (estado == 0)){
     estado = 2;
  }
  
  if ((key == 'p' || key == 'P')){
     estado = (estado==2)?1:estado;
  }
  
  if ((key == 'r' || key == 'R') && (estado!=0)){
     reiniciarPartida();
  }
  
  if ((key == 'm' || key == 'M')){
     selectInput("Selecciona cancion","cancionSeleccionada");
  }
  
  println(distThreshold);
}

void cancionSeleccionada(File selection){
  if (selection == null) {
    println("No se ha seleccionado nada");
  } else {
    pathCancion = selection.getAbsolutePath();
    println("Canción seleccionada: " + pathCancion);
    
    filePlayer.pause();
    filePlayer = new FilePlayer( minim.loadFileStream(pathCancion));
    musica = minim.getLineOut();
    filePlayer.patch(musica);
  }
}

void reiniciarPartida(){
     estado=0;
     
     //Reiniciar marcadores
     marcadorIzq=0;
     marcadorDer=0;
     
     //Reiniciar pelota
     iniciarPelota();
     
     //Deasignar los colores seleccionados
     color1 = 0;
     blob1 = null;
     asignada1 = false;

     color2 = 0;
     blob2 = null;
     asignada2 = false;
     
     filePlayer.pause();
     filePlayer.rewind();
     musicaOn = false;
}

void iniciarPelota(){
  Random r = new Random();
  pelota=new Pelota(width/2,r.nextInt(height));
}

void draw() {
  switch(estado){
    case 0: //Nuevo juego
    background(255);
    String p = "PONG - INFORMÁTICA AUDIOVISUAL\n> Pulsa 'j' para jugar\n- Pulsa 'r' para reiniciar\n- Pulsa 'p' para pausar\n- Pulsa 'm' para seleccionar canción";
    textAlign(CENTER);
    textSize(width*0.05);
    fill(255, 0, 0);
    text(p, width*0.04, 10, width*0.9, height);
    break;
    
    case 1://Pausa
    //Cuando se esta en pausa no se hace nada hehe
    break;
    
    case 2://En medio del fulgor de una partida
    video.loadPixels();
    image(video, 0, 0);
    
    escaneaPixeles();
    pintaPalas();
    
    if(blob1 != null && blob2 != null){
      pelota.pintar();
      pelota.aplicarMovimiento();
      iniciarMusica();
    }
    imprimeMarcadores();
    break;
    
    case 3://Uno de los dos jugadores ha llevado al límite a su rival y se ha llevado la victoria
    filePlayer.pause();
    background(255);
    int ganador = (marcadorIzq==puntosFinales)?1:2;
    String victory = "¡Victoria!\nFelicidades Jugador "+ganador+"\nMarcador: "+marcadorIzq+" - "+marcadorDer+"\n-Pulsa 'r' para reiniciar la partida";
    textAlign(CENTER);
    fill(255, 0, 0);
    textSize(30);
    text(victory, width*0.06, 10, width*0.9, height*0.5);
    break;
  }
}

boolean colision(Blob pala){
  boolean rangoXi = pelota.x+pelota.diametro/2 >= pala.x && pala.x - pala.ancho - pelota.x+pelota.diametro/2-3 <= 2 && pelota.x < pala.x;
  boolean rangoXd = pelota.x-pelota.diametro/2 <= pala.x+(pala.ancho-pala.x) && (pelota.x-pelota.diametro/2+3) - (pala.x+(pala.ancho-pala.x)) <= 2 && pelota.x > pala.x;
  boolean rangoY = pelota.y+pelota.diametro/2 >= pala.y && pelota.y-pelota.diametro/2 <= pala.y+(pala.alto-pala.y);
  
  if(rangoY && (rangoXi || rangoXd)){
     
    if (!pelota.estaColisionando){
      pelota.estaColisionando = true;
      if (rangoXi) {
        pelota.x = pala.x-pelota.diametro/2;
        
      } else if (rangoXd) {
        pelota.x = pala.ancho+pelota.diametro/2;
        
      }
      pelota.vx = pelota.vx*-1;
      pelota.x = pelota.x + pelota.vx;
      return true;
    }
    
    return false;
  }else{
    pelota.estaColisionando = false;
    return false;
  }
}

/* Escanea colores de la pantalla y asigna la nueva posicion */
void escaneaPixeles(){
    // loop que escanea todos los pixeles
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
}

// pinta las palas
void pintaPalas(){
    if(blob1 != null){
        blob1.show();
        colision(blob1);
    }
    if(blob2 != null){
       blob2.show(); 
       colision(blob2);
    }
    
  }

void iniciarMusica(){
  if(!musicaOn){
    filePlayer.loop();
    musicaOn = true;
    volumenActual = musica.mix.level();
  }
  else{
    if(tiempoReaccion >= 15){
      float variacion = musica.mix.level()*random(12, 13);
      if (musica.mix.level() < volumenActual) {
        this.pelota.vy = this.pelota.vy > 0 ? this.pelota.vy - variacion : this.pelota.vy + variacion;
        this.pelota.vx = this.pelota.vx > 0 ? this.pelota.vx - variacion : this.pelota.vx + variacion;
      } else {
        this.pelota.vy = this.pelota.vy > 0 ? this.pelota.vy + variacion : this.pelota.vy - variacion;
        this.pelota.vx = this.pelota.vx > 0 ? this.pelota.vx + variacion : this.pelota.vx - variacion;
      }
      tiempoReaccion = 0;
      volumenActual = musica.mix.level();
    } else {
      tiempoReaccion ++;
    }
    println("El volumen es " + musica.mix.level());
    println("Y la velocidad actual " + this.pelota.vy);
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
  textFont(fuente);
  text(marcadorIzq,width/2-width/15, height/10);
  text(marcadorDer,width/2+width/15, height/10);
  textFont(original);
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
  if (!paletasCreadas() && estado==2){
    int loc = mouseX + mouseY*video.width;
    
    lado = blob1 == null ? ((mouseX < width/2.0) ? true : false) : lado;
      
    trackColor = video.pixels[loc];
    color2 = color2 == 0 && color1 != 0? trackColor: color2;
    color1 = color1 == 0? trackColor: color1;
  }
}

public void aumentarPuntos(int jugador){
  marcadorIzq +=(jugador==1)?1:0;
  marcadorDer +=(jugador==2)?1:0;
  if(marcadorIzq == puntosFinales || marcadorDer == puntosFinales)
    estado=3;
  else
    iniciarPelota();
}

boolean paletasCreadas(){
  if (blob1 != null && blob2 != null){
    return true; 
  } else {
    return false; 
  }
}