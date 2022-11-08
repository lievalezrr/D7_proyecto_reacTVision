class Control {

  float angulo, r;
  PVector pos, posDest;
  int vlr, codigoPersonaje;
  PVector posInicial;
  int vlrMin, vlrMax;
  String tag;
  boolean estaPresente, seleccionadoConMouse;
  color clrDark, clrLight;
  int hueTheme;
  Particle particle;
  PImage angulo1, angulo2, angulo3;

  public Control(float _x, float _y, int _vMin, int _vMax, color _clrDark, color _clrLight, ParticleSystem mundoVirtual,
    PImage _angulo1, PImage _angulo2, PImage _angulo3) {

    pos = new PVector (_x, _y);
    posDest = new PVector (_x, _y);
    posInicial = new PVector (_x, _y);
    angulo = 0;
    vlrMin = _vMin;
    vlrMax = _vMax;
    clrDark = _clrDark;
    clrLight = _clrLight;
    hueTheme = hueAzul;
    r = 50;
    particle = mundoVirtual.makeParticle(1, _x, _y, 0);
    seleccionadoConMouse = false;
    estaPresente = false;
    angulo1 = _angulo1;
    angulo2 = _angulo2;
    angulo3 = _angulo3;
  }

  void dibujar() {
    textAlign(CENTER);
    if (lightMode) fill(clrLight);
    else fill(clrDark);
    arc(pos.x, pos.y, r, r, 0, radians(angulo));

    imageMode(CENTER);
    
    if (angulo >= 0 && angulo <= 120) {
      image(angulo1, pos.x, pos.y);
      hueTheme = int(map(angulo, 0, 120, 176, 263));
    }
    if (angulo > 120 && angulo <= 240) {
      image(angulo2, pos.x, pos.y);
      hueTheme = int(map(angulo, 120, 240, 300, 360));
    }
    if (angulo > 240 && angulo <= 360) {
      image(angulo3, pos.x, pos.y);
      hueTheme = int(map(angulo, 240, 360, 65, 155));
    }
    imageMode(CORNER);
  }

  void actualizar(float _x, float _y, float _a) {
    if (estaPresente) {
      posDest.x = _x;
      posDest.y = _y;
      // Considerar el angulo del fiduscial
      angulo = degrees(_a);
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
