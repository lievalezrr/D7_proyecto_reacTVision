class Llave {

  //float angulo;
  PVector pos, posDest;
  float x, y;
  //float x = width/2;
  //float y = height/2;
  //boolean atrapada;
  
  public Llave(PImage _llavePic, float _x, float _y) {
 
      pos = new PVector (_x, _y);
      x = _x;
      y = _y;
      llavePic = _llavePic;
      //llavePic.resize(width/8,width/8);
      
  }
  
  void dibujar() {
    image (llavePic, x, y);
  }
  
 void meAtraparon (PVector posDest) {
  pos = posDest;
  //x = _x;
  //y = _y;
 } 
 
   PVector getPos() {
    return pos;
  }
 
}
