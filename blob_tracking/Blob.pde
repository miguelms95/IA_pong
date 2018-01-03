class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;

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
      minx = width/2.0;
      maxx = width/2.0+width*0.02;
    } else if (lado && lr){
      maxx = width/2.0;
      minx = width/2.0-width*0.02;
    } else {
      minx = x-width*0.01; 
      maxx = x+width*0.01;
    }
    miny = y-height*0.12;
    maxy = y+height*0.12;
  }

  void show() {
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);
  }
   //<>// //<>//
  float size() {
    return (maxx-minx)*(maxy-miny);
  }
  
}
