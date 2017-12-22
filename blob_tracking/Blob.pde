class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;

  ArrayList<PVector> points;

  Blob(float x, float y) {
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
    
    //Añadido
    minx = x-width*0.01;
    miny = y-height*0.12;
    maxx = x+width*0.01;
    maxy = y+height*0.12;
  }

  void show() {
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);
  }
  
  // Metodo añadido por Angela y Lucia
  void move(float x, float y){
    minx = x-width*0.01;
    miny = y-height*0.12;
    maxx = x+width*0.01;
    maxy = y+height*0.12;
  }


  float size() {
    return (maxx-minx)*(maxy-miny);
  }
}