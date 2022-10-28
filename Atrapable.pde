//import ddf.minim.*;

class Atrapable {

  float springLength;
  Particle particle;
  boolean meAtraparon;
  ParticleSystem mundoVirtual;
  Spring spring;
  PImage imagen;

  //Minim minim;
  //AudioSample sfxTomarLlave;

  public Atrapable(PImage _imagen, float _x, float _y, ParticleSystem _mundoVirtual) {

    mundoVirtual = _mundoVirtual;
    particle = mundoVirtual.makeParticle(1, _x, _y, 0);
    particle.makeFixed();
    meAtraparon = false;
    imagen = _imagen;
    springLength = 150;
    //minim = new Minim(this);
    //sfxTomarLlave = minim.loadSample("tomarLlave.mp3");
  }

  void dibujar() {
    imageMode(CENTER);
    image (imagen, particle.position().x(), particle.position().y());
    imageMode(CORNER);
  }

  // Crear un spring entre la particula del atrapable y otra particula
  void atrapar(Particle particleToAttach) {
    meAtraparon = true;
    particle.makeFree();
    spring = mundoVirtual.makeSpring(particleToAttach, particle, 0.2, 0.1, springLength);
  }

  // Borrar el spring que se creo para la particula del atrapable
  void soltar() {
    mundoVirtual.removeSpring(spring);
  }

  PVector getPos() {
    return new PVector (particle.position().x(), particle.position().y());
  }
}
