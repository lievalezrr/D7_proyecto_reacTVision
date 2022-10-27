class Control {

  float angulo, r;
  PVector pos, posDest;
  int vlr;
  PVector posInicial;
  int vlrMin, vlrMax;
  String tag;
  boolean estaPresente, seleccionadoConMouse;
  color clr;
  Particle particle;

  public Control(float _x, float _y, int _vMin, int _vMax, color _clr, ParticleSystem mundoVirtual) {

    pos = new PVector (_x, _y);
    posDest = new PVector (_x, _y);
    posInicial = new PVector (_x, _y);
    angulo = 360;
    vlrMin = _vMin;
    vlrMax = _vMax;
    clr = _clr;
    r = 50;
    particle = mundoVirtual.makeParticle(1, _x, _y, 0);
    seleccionadoConMouse = false;
    estaPresente = false;
  }

  void dibujar() {
    textAlign(CENTER);
    strokeWeight(1);
    stroke(#FFFFFF, 95);
    //text(tag, pos.x, pos.y);
    fill(clr);
    arc(pos.x, pos.y, r, r, 0, radians(angulo));
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
      //Para mover con feid
      //posDest.x = posInicial.x;
      //posDest.y = posInicial.y;

      //Para mover con el mouse
      if (seleccionadoConMouse == true) {
        posDest.x = mouseX;
        posDest.y = mouseY;
      }
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
