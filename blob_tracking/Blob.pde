class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;

  ArrayList<PVector> points;

  Blob(float x, float y) {
    //No haría falta
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
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


    // No haria falta
    for (PVector v : points) {
      //stroke(0, 0, 255);
      //point(v.x, v.y);
    }
  }

  // No haria falta
  void add(float x, float y) {
    points.add(new PVector(x, y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
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

  // No haria falta
  boolean isNear(float x, float y) {
    // The Rectangle "clamping" strategy
    // float cx = max(min(x, maxx), minx);
    // float cy = max(min(y, maxy), miny);
    // float d = distSq(cx, cy, x, y);
    
    // Closest point in blob strategy
    float d = 10000000;

    for (PVector v : points) {
      float tempD = distSq(x, y, v.x, v.y);
      if (tempD < d) {
        d = tempD;
      }
    }

    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}
