class Pelota{
  float x, y;
  float diametro =  40;
  
  float vx = 2;
  float vy = 3;
  
  public Pelota(int x, float y){
    this.x = x;
    this.y = y;
  }
  
  void pintar(){
    fill(120,220,120);
    ellipse(x,y,diametro,diametro);
  }
  
  void aplicarMovimiento(){
    if(y >= height || y < 0)
      vy *= -1;
    this.x += vx;
    this.y += vy;
  }
}