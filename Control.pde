class Control {

  float angulo, r;
  PVector pos, posDest;
  int vlr,codigoPersonaje;
  PVector posInicial;
  int vlrMin, vlrMax;
  String tag;
  boolean estaPresente, seleccionadoConMouse;
  color clrDark, clrLight;
  Particle particle;

  public Control(float _x, float _y, int _vMin, int _vMax, color _clrDark, color _clrLight, ParticleSystem mundoVirtual) {

    pos = new PVector (_x, _y);
    posDest = new PVector (_x, _y);
    posInicial = new PVector (_x, _y);
    angulo = 360;
    vlrMin = _vMin;
    vlrMax = _vMax;
    clrDark = _clrDark;
    clrLight = _clrLight;
    r = 50;
    particle = mundoVirtual.makeParticle(1, _x, _y, 0);
    seleccionadoConMouse = false;
    estaPresente = false;
  }

  void dibujar(int _personaje) {
    codigoPersonaje = _personaje;
    textAlign(CENTER);
    if (lightMode) fill(clrLight);
    else fill(clrDark);
    arc(pos.x, pos.y, r, r, 0, radians(angulo));
    
    if (codigoPersonaje == 1) {
      image(mainPic1,pos.x, pos.y);
    
     if (codigoPersonaje == 2) {
      image(mainPic2,pos.x, pos.y);
      
       if (codigoPersonaje == 1) {
      image(mainPic3,pos.x, pos.y);
    }
    
  }

  void actualizar(float _x, float _y, float _a) {
    if (estaPresente) {
      posDest.x = _x;
      posDest.y = _y;
      // Considerar el angulo del fiduscial
      //angulo = degrees(_a);
    }
  }

  void mover() {
    if (!estaPresente) {
      posDest.x = posInicial.x;
      posDest.y = posInicial.y;
    }
    
    //Para mover con el mouse
    if (seleccionadoConMouse == true) {
      posDest.x = mouseX;
      posDest.y = mouseY;
    }

    pos.lerp(posDest, 0.1);
    particle.position().set(pos.x, pos.y, 0);
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

  boolean clickDentro() {
    return dist(pos.x, pos.y, mouseX, mouseY) < r;
  }
}
