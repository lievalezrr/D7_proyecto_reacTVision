class Hotspot {

  color clrDark, clrLight;
  PVector pos;
  float r;
  PImage img;
  boolean primerContacto;

  public Hotspot (float _x, float _y, color _clrDark, color _clrLight, float _r, PImage _h) {

    pos = new PVector (_x, _y);
    clrDark = _clrDark;
    clrLight = _clrLight;
    r = _r;
    img = _h;
    primerContacto = true;
  }

  void dibujar() {
    noStroke();
    if (lightMode) fill(clrLight);
    else fill(clrDark);
    imageMode(CENTER);
    image(img, pos.x, pos.y);
  }

  boolean meToco(float _x, float _y) {
    if (dist(_x, _y, pos.x, pos.y) < r) {
      return true;
    }
    return false;
  }
}
