class Hotspot {

  color clrDark, clrLight;
  PVector pos;
  float r;

  public Hotspot (float _x, float _y, color _clrDark, color _clrLight, float _r) {

    pos = new PVector (_x, _y);
    clrDark = _clrDark;
    clrLight = _clrLight;
    r = _r;
  }

  void dibujar() {
    noStroke();
    if (lightMode) fill(clrLight);
    else fill(clrDark);
    circle(pos.x, pos.y, r);
  }

  boolean meToco(float _x, float _y) {
    if (dist(_x, _y, pos.x, pos.y) < r) {
      return true;
    }
    return false;
  }
}
