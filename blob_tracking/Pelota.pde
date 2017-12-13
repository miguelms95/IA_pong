class Pelota{
  float x, y;
  float diametro =  40;
  
  float vx = 1;
  float vy = 1.3;
  
  public Pelota(int x, float y){
    this.x = x;
    this.y = y;
  }
  
  void pintar(){
    fill(120,220,120);
    ellipse(x,y,diametro,diametro);
  }
}