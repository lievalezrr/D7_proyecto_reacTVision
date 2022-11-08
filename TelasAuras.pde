class TelaAuras {

  Particle[][] arrayDeParticulas; // matriz que contiene particulas
  int cantidadDeParticulasPorLado;
  float durezaDeResortes;
  float elasticidadDeResortes;
  float clr, vol, tag, freq, comp, golpe, cambioColor;
  PVector posAura;

  public TelaAuras(ParticleSystem mundoVirtual, int cantidad, float _naceX, float _naceY, float _tag) {

    cantidadDeParticulasPorLado = cantidad;
    durezaDeResortes = 0.25;
    elasticidadDeResortes = 0.05;
    clr = color(#ffffff);
    tag = _tag; // identifica cuál de las cuatro telas es

    // aca se definen en el constructor donde va a nacer la matriz
    float naceX = _naceX;
    float naceY = _naceY;


    arrayDeParticulas = new Particle[cantidadDeParticulasPorLado][cantidadDeParticulasPorLado];
    float pasoEnX = (width/100) / cantidadDeParticulasPorLado;
    float pasoEnY = (width/100) / cantidadDeParticulasPorLado;

    // se define la posición de las partículas y la separación entre sus resortes horizontales
    for (int i = 0; i < cantidadDeParticulasPorLado; i++) {
      for (int j = 0; j < cantidadDeParticulasPorLado; j++) {
        arrayDeParticulas[i][j] = mundoVirtual.makeParticle(0.25, (j * pasoEnX)-((cantidadDeParticulasPorLado/2)*pasoEnX) + naceX,
          naceY + (i * pasoEnY)-((cantidadDeParticulasPorLado/2)*pasoEnY), 0); // ( float mass, float x, float y, float z )
        if (j > 0) mundoVirtual.makeSpring(arrayDeParticulas[i][j - 1], arrayDeParticulas[i][j],
          durezaDeResortes, elasticidadDeResortes, pasoEnX);
      }
    }
    // se define la separación entre los resortes verticales
    for (int j = 0; j < cantidadDeParticulasPorLado; j++) {
      for (int i = 1; i < cantidadDeParticulasPorLado; i++) {
        mundoVirtual.makeSpring(arrayDeParticulas[i - 1][j], arrayDeParticulas[i][j],
          durezaDeResortes, elasticidadDeResortes, pasoEnY);
      }
    }
  }



  void dibujar(float _clr, float _freq, float _golpe, PVector _posAura) {
    freq = _freq;
    golpe = _golpe;
    posAura = _posAura;
    //text(vol, width/4,height/3);
    //text(clr, width/4, height/4);
    noStroke();
    
    

    // se definen los colores los colores y opacidades de los segmentos de tela

    //fill(#666666, 150);
    for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
      for (int i = 0; i < cantidadDeParticulasPorLado-1; i++) {

          beginShape();
          vertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
          vertex(arrayDeParticulas[i+1][j].position().x(), arrayDeParticulas[i+1][j].position().y());
          vertex(arrayDeParticulas[i+1][j+1].position().x(), arrayDeParticulas[i+1][j+1].position().y());
          vertex(arrayDeParticulas[i][j+1].position().x(), arrayDeParticulas[i][j+1].position().y());
          vertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
          endShape();
          fill((j+105)/1.3*clr, 90, i+80*1.1, 120);
        }
    }
    //se dibujan las posiciones al centro
    
      for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
        arrayDeParticulas[j][0].position().set(posAura.x, posAura.y, 0);
        //arrayDeParticulas[j][0].makeFixed();
        
        //arrayDeParticulas[j][9].position().set(posAura.x, posAura.y, 0);
        
      }
    


    text(analizaEscenario2.getFreq(),width/2, width/8*6);
    

 
  // comportamiento de telas cuando se llega a un nivel de volumen
    
    
    
    // golpes en la tela por rango de frecuencias correspondiente a cada una
    
      if (tag == 1) {
        if (freq > 10) {
          arrayDeParticulas[0][0].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13, 0);
          arrayDeParticulas[9][0].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13, 0);
          arrayDeParticulas[0][9].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
          arrayDeParticulas[9][9].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
          //arrayDeParticulas[30][30].makeFixed();
        }
      }
      
      if (tag == 2) {
        if (freq < 100 || freq > 50) {
            arrayDeParticulas[0][0].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13, 100);
          arrayDeParticulas[9][0].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13, 0);
          arrayDeParticulas[0][9].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
          arrayDeParticulas[9][9].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
        }
      }
      
       if (tag == 3) {
      if (freq < 150 || freq > 100) {
          arrayDeParticulas[0][0].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13, 100);
          arrayDeParticulas[9][0].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13, 0);
          arrayDeParticulas[0][9].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
          arrayDeParticulas[9][9].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
    //      //arrayDeParticulas[30][30].makeFixed();
       }
      }
    }
}


  

//// set para cambiar el color de la tela
//  void setColor(float _clr) {
//    clr = _clr;
//  }
//  // set para cambiar el comprtamiento de la tela
//  void setComportamiento(float _comp) {
//    comp = _comp;
//  }
  
//}
//}


  
  
  

  
  
 
