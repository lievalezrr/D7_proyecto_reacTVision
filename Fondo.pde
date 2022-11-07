class Fondo {

  float radius;
  float b, h, s;

  Fondo(float _r, float _h, float _s, float _b) {
    radius = _r;
    b = _b;
    h = _h;
    s = _s;
  }
  
  void hsb(float _h, float _s, float _b){
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
      if (lightMode) s = (s + 3);
      else b = (b + 2);
    }
    ellipseMode(CENTER);
  }
}
