class Salida {

  Particle particle;

  PVector pos;
  PImage img;

  public Salida(ParticleSystem mundoVirtual, float _x, float _y, PImage _s) {

    pos = new PVector (_x, _y);
    img = _s;
    particle = mundoVirtual.makeParticle(1, pos.x, pos.y, 0);

    particle.makeFixed();
    
    
  }

  void dibujar() {
    noStroke();
    if (lightMode) fill(colorBlanco);
    else fill(colorNegro);
    imageMode(CENTER);
    image(img,pos.x, pos.y);
  }

  PVector getPos() {
    return pos;
  }
}
