class Fondo {

  float radius;
  float h;

  Fondo(float _r, float _h) {
    radius = _r;
    h = _h;
  }

  void drawFondo() {
    noStroke();
    ellipseMode(RADIUS);
    // el r es lo que determina el grosor de los circulos
    for (float r = radius; r > 0; r -= 12) {
      fill(86, 40, h);
      ellipse(width/2, height/2, r, r);
      h = (h + 1);
    }
    ellipseMode(CENTER);
  }
}
