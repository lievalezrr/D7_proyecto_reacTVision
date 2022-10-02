class Salida {
  
  Particle salida;

  PVector pos;
  float pX, pY;
  
  public Salida(ParticleSystem mundoVirtual,float _x, float _y) {
 
    pos = new PVector (_x, _y);
    pX = pos.x;
    pY = pos.y;
    salida = mundoVirtual.makeParticle(0.01, pX, pY, 0); 

    salida.makeFixed(); // makeFixed la libera de actuar según las fuerzas del ambiente
      
  }
  

  void dibujar() {
    noStroke();
    fill(#000033);
    ellipse(pos.x, pos.y, width/15, width/15); 
  }
  
}
