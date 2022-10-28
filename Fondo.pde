class Fondo {

  float radius;
  float b, h, s;

  Fondo(float _r, float _b, float _h, float _s) {
    radius = _r;
    b = _b;
    h = _h;
    s = _s;
  }

  void drawFondo() {
    noStroke();
    ellipseMode(RADIUS);
    // el r es lo que determina el grosor de los circulos
    for (float r = radius; r > 0; r -= 24) {
      fill(h, s, b);
      ellipse(width/2, height/2, r, r);
      b = (b + 1);
    }
    ellipseMode(CENTER);
  }
}
