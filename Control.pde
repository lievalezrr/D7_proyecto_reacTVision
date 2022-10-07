class Control {

  float angulo;
  PVector pos, posDest;
  int vlr;
  PVector posInicial;
  int vlrMin, vlrMax;
  String tag;
  boolean estaPresente;
  color clr;
  
  public Control(float _x, float _y, int _vMin, int _vMax, String _t, color _clr) {
      
      pos = new PVector (_x, _y);
      posDest = new PVector (_x, _y);
      posInicial = new PVector (_x, _y);
      angulo = 360;
      vlrMin = _vMin;
      vlrMax = _vMax;
      tag = _t;
      clr = _clr;
      
      estaPresente = false; 
  }
  
  void dibujar() {
    textAlign(CENTER);
    strokeWeight(1);
    stroke(#FFFFFF, 95);
    //text(tag, pos.x, pos.y); 
    fill(clr);
    arc(pos.x, pos.y, 50, 50, 0, radians(angulo));
  }
  
  void actualizar(float _x, float _y, float _a) {
    if (estaPresente) {
      posDest.x = _x;
      posDest.y = _y;
      angulo = degrees(_a);
    }
  }
  
  void mover() {
    if (!estaPresente) {
      posDest.x = posInicial.x;
      posDest.y = posInicial.y;
    }
    
    pos.lerp(posDest, 0.1);
  }
   
  PVector getPos() {
    return posDest;
  }
  
  void isPresent(boolean _p) {
    estaPresente = _p;
  }
  
  int getValor() {
    vlr = int(map(angulo, 0, 359, vlrMin, vlrMax));
    return vlr;
  }
}
