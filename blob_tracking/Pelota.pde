class Pelota{
  float x, y;
  float diametro =  40;
  
  float vx = 2;
  float vy = 3;
  boolean estaColisionando = false;
  
  public Pelota(int x, float y){
    this.x = x;
    this.y = y;
  }
  
  void pintar(){
    fill(120,220,120);
    ellipse(x,y,diametro,diametro);
  }
  
  void aplicarMovimiento(){
    if(y+diametro/2 >= height || y-diametro/2 < 0)
      vy *= -1;
     if(x>width){
       aumentarPuntos(1);
       return;
      }
      if(x<0){
       aumentarPuntos(2);
       return;
      }
    this.x += vx;
    this.y += vy;
  }
}