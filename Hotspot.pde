class Hotspot {

  color clr;
  PVector pos;
  float r;

  public Hotspot (float _x, float _y, color _clr, float _r) {

    pos = new PVector (_x, _y);
    clr = _clr;
    r = _r;
  }

  void dibujar() {
    noStroke();
    fill(clr);
    circle(pos.x, pos.y, r);
  }

  boolean meToco(float _x, float _y) {
    if (dist(_x, _y, pos.x, pos.y) < r) {
      return true;
    }
    return false;
  }
}
