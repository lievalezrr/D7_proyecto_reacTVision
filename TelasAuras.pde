class TelaAuras {

  Particle[][] arrayDeParticulas; // matriz que contiene particulas
  int cantidadDeParticulasPorLado,mitad, fin, hue;
  float durezaDeResortes;
  float elasticidadDeResortes;
  float clr, vol, tag, freq, comp, golpe, cambioColor,volumen,pasoEnY, pasoEnX;
  PVector posAura;

  public TelaAuras(ParticleSystem mundoVirtual, int cantidad, float _naceX, float _naceY, float _tag) {

    cantidadDeParticulasPorLado = cantidad;
    durezaDeResortes = 0.25;
    elasticidadDeResortes = 0.05;
    clr = color(#ffffff);
    tag = _tag; // identifica cuál de las cuatro telas es
     //posAura = _posAura;
    // aca se definen en el constructor donde va a nacer la matriz
    mitad = cantidad/2;
    float naceX = _naceX;
    float naceY = _naceY;
    fin = cantidadDeParticulasPorLado-1;


    arrayDeParticulas = new Particle[cantidadDeParticulasPorLado][cantidadDeParticulasPorLado];
     pasoEnX = (width/20) / cantidadDeParticulasPorLado;
     pasoEnY = (width/20) / cantidadDeParticulasPorLado;

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



  void dibujar(float _clr, float _freq, float _golpe, PVector _posAura, float _vol, int _huetheme) {
    
    freq = _freq;
    golpe = _golpe;
    volumen = _vol;
    posAura = _posAura;
    hue = _huetheme;
    //clr = 100;
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
          fill(hue, 90, i+80*1.1, 120);
        }
    }
    //se dibujan las posiciones al centro
    
      for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
        arrayDeParticulas[j][0].position().set(posAura.x-width/80, posAura.y,0); //posAura.x-(posAura.x-j), posAura.y-width/80, 0
        //arrayDeParticulas[j][0].makeFixed();
        
        arrayDeParticulas[0][j].position().set(posAura.x, posAura.y-width/80, 0);
        //arrayDeParticulas[0][j].makeFixed();
        
        arrayDeParticulas[j][9].position().set(posAura.x+width/80, posAura.y, 0);
        //arrayDeParticulas[j][9].makeFixed();
        
        arrayDeParticulas[9][j].position().set(posAura.x, posAura.y+width/80, 0);
        arrayDeParticulas[9][j].makeFixed();
        
        
      //  //arrayDeParticulas[j][9].position().set(posAura.x, posAura.y, 0);
        
      }
      arrayDeParticulas[mitad][mitad].position().set(posAura.x, posAura.y, 0);
      arrayDeParticulas[mitad][mitad].makeFixed();
      
      //arrayDeParticulas[0][fin].position().set(posAura.x-width/80, posAura.y-width/80, 0);
      //arrayDeParticulas[fin][0].position().set(posAura.x+width/80, posAura.y-width/80, 0);
      //arrayDeParticulas[0][0].position().set(posAura.x-width/80, posAura.y+width/80, 0);
      //arrayDeParticulas[fin][fin].position().set(posAura.x+width/80, posAura.y+width/80, 0);
      
      
      
      

    text(analizaEscenario2.getFreq(),width/2, width/8*7);
    

 
  // comportamiento de telas cuando se llega a un nivel de volumen
    
    
    
     //golpes en la tela por rango de frecuencias correspondiente a cada una
    
      if (tag == 1) {
        if (freq > 10) {
          arrayDeParticulas[3][3].position().set(lerp(arrayDeParticulas[3][3].position().x(), golpe, 0.01), arrayDeParticulas[3][3].position().x()-height/13, 0);
          arrayDeParticulas[7][3].position().set(lerp(arrayDeParticulas[7][3].position().x(), golpe, 0.01), arrayDeParticulas[7][3].position().x()-height/13, 0);
          arrayDeParticulas[3][7].position().set(lerp(arrayDeParticulas[3][7].position().x(), golpe, 0.01), arrayDeParticulas[3][7].position().x()+height/13, 0);
          arrayDeParticulas[7][7].position().set(lerp(arrayDeParticulas[7][7].position().x(), golpe, 0.01),  arrayDeParticulas[7][7].position().x()+height/13, 0);
          //arrayDeParticulas[30][30].makeFixed();
        }
      }
      
      if (tag == 2) {
        if (freq < 100 || freq > 50) {
            arrayDeParticulas[3][3].position().set(lerp(arrayDeParticulas[3][3].position().x(), golpe, 0.01), height/13, 0);
          arrayDeParticulas[7][3].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13, 0);
          arrayDeParticulas[3][7].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
          arrayDeParticulas[7][7].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
        }
      }
      
       if (tag == 3) {
      if (freq < 150 || freq > 100) {
          arrayDeParticulas[3][3].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13, 0);
          arrayDeParticulas[7][3].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13, 0);
          arrayDeParticulas[3][7].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
          arrayDeParticulas[7][7].position().set(lerp(arrayDeParticulas[5][5].position().x(), golpe, 0.01), height/13*8, 0);
    //      //arrayDeParticulas[30][30].makeFixed();
       }
      }
      
      //if (vol > 25) {
      //  arrayDeParticulas[3][3].position().set(lerp(arrayDeParticulas[5][5].position().x(), random(0, 1920), 0.01), height/13, 100);
      //  arrayDeParticulas[7][3].position().set(lerp(arrayDeParticulas[5][5].position().x(), random(0, 1920), 0.01), height/13, 0);
      //  arrayDeParticulas[3][7].position().set(lerp(arrayDeParticulas[5][5].position().x(), random(0, 1920), 0.01), height/13*8, 0);
      //  arrayDeParticulas[7][7].position().set(lerp(arrayDeParticulas[5][5].position().x(), random(0, 1920), 0.01), height/13*8, 0);
      //  //arrayDeParticulas[30][30].makeFixed();
      //}
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


  
  
  

  
  
 
