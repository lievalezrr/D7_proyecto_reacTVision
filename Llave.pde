//import ddf.minim.*;


class Llave {

  //float angulo;
  PVector pos, posDest;
  float x, y;
  
  //Minim minim;
  //AudioSample sfxTomarLlave;

  public Llave(PImage _llavePic, float _x, float _y) {
 
      pos = new PVector (_x, _y);

      llavePic = _llavePic;
      //minim = new Minim(this);
      //sfxTomarLlave = minim.loadSample("tomarLlave.mp3");
  
      
  }
  
  void dibujar() {
    image (llavePic,pos.x, pos.y);
  }
  
 void meAtraparon (PVector posDest) {
  pos = posDest;
  //sfxTomarLlave.trigger(); 

 } 
 
   PVector getPos() {
    return pos;
  }
 
}
