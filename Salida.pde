class Salida {

  Particle particle;

  PVector pos;

  public Salida(ParticleSystem mundoVirtual, float _x, float _y) {

    pos = new PVector (_x, _y);
    particle = mundoVirtual.makeParticle(1, pos.x, pos.y, 0);

    particle.makeFixed();
  }

  void dibujar() {
    noStroke();
    fill(#000033);
    ellipse(pos.x, pos.y, width/15, width/15);
  }

  PVector getPos() {
    return pos;
  }
}
