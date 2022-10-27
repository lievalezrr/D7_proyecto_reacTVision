class Fondo {

  float radius;
  float b, h;

  Fondo(float _r, float _b, float _h) {
    radius = _r;
    b = _b;
    h = _h;
  }

  void drawFondo() {
    noStroke();
    ellipseMode(RADIUS);
    // el r es lo que determina el grosor de los circulos
    for (float r = radius; r > 0; r -= 12) {
      fill(h, 40, b);
      ellipse(width/2, height/2, r, r);
      b = (b + 1);
    }
    ellipseMode(CENTER);
  }
}
