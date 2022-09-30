class Salida {

  PVector pos;
  ParticleSystem mundoVirtual; // ambiente de la simulación
  Particle salida;
  float tamagno = 10; // tamagno del círculo de salida
  


  public Salida(float _x, float _y) {
 
    pos = new PVector (_x, _y);

    // Creación del mundo
    mundoVirtual = new ParticleSystem(0, 0.1);

    // creación de la partícula que sigue al mouse
    salida = mundoVirtual.makeParticle();
    salida.makeFixed(); // makeFixed la libera de actuar según las fuerzas del ambiente
      
  }
  
  void dibujar() {
    
  }
  
 void meAtraparon (PVector posDest) {
  pos = posDest;

 } 
 
   PVector getPos() {
    return pos;
  }
 
}
