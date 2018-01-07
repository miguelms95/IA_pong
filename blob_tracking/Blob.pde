class Blob {
  float x;
  float y;
  float ancho;
  float alto;

  // Lado de la paleta. TRUE = derecha / FALSE = izquierda.
  boolean lado;

  ArrayList<PVector> points;

  Blob(float x, float y, boolean lado) {
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
    this.lado = lado;
    
    //Esta a la izquierda y quiere pasar a la derecha
    boolean lr = (x+width*0.01) > width/2.0;
    //Esta a la derecha y quiere pasar a la izquierda
    boolean rl = (x-width*0.01) < width/2.0;
    
    // Si es de la derecha
    if (!lado && rl){
      x = width/2.0;
      ancho = width/2.0+width*0.02;
    } else if (lado && lr){
      ancho = width/2.0;
      this.x = width/2.0-width*0.02;
    } else {
      this.x = x-width*0.01; 
      ancho = x+width*0.01;
    }
    this.y = y-height*0.12;
    alto = y+height*0.12;
  }

  void show() {
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(this.x, this.y, ancho, alto,20);
  }
   //<>// //<>//
  float size() {
    return (ancho-this.x)*(alto-this.y);
  }
  
}