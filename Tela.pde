class Tela {

  Particle[][] arrayDeParticulas; // matriz que contiene particulas
  int cantidadDeParticulasPorLado;
  float durezaDeResortes;
  float elasticidadDeResortes;
  float clr, vol, tag, freq, esc;

  public Tela(ParticleSystem mundoVirtual, int cantidad, float _naceX, float _naceY, float _tag) {

    cantidadDeParticulasPorLado = cantidad;
    durezaDeResortes = 0.25;
    elasticidadDeResortes = 0.05;
    clr = color(#ffffff);
    tag = _tag; // identifica cuál de las cuatro telas es

    // aca se definen en el constructor donde va a nacer la matriz
    float naceX = _naceX;
    float naceY = _naceY;


    arrayDeParticulas = new Particle[cantidadDeParticulasPorLado][cantidadDeParticulasPorLado];
    float pasoEnX = (width/4) / cantidadDeParticulasPorLado;
    float pasoEnY = (width/4) / cantidadDeParticulasPorLado;

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

  // set para cambiar el color de la tela

  void setColor(float _clr) {
    clr = _clr;
  }

  void dibujar(float _size, float _clr, float _freq, float esc) {
    vol = _size;
    clr = _clr;
    freq = _freq;
    //text(vol, width/4,height/3);
    text(clr, width/4, height/4);
    noStroke();

    // se definen los colores los colores y opacidades de los segmentos de tela

    //fill(#666666, 150);
    for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
      for (int i = 0; i < cantidadDeParticulasPorLado-1; i++) {


        if (tag == 1 | tag == 2 | tag == 3 | tag == 4 ) {
          beginShape();
          vertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
          vertex(arrayDeParticulas[i+1][j].position().x(), arrayDeParticulas[i+1][j].position().y());
          vertex(arrayDeParticulas[i+1][j+1].position().x(), arrayDeParticulas[i+1][j+1].position().y());
          vertex(arrayDeParticulas[i][j+1].position().x(), arrayDeParticulas[i][j+1].position().y());
          vertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
          endShape();
          fill((j+30)/1.3, 200, i+100*1.1, 200);
        }

        if (tag == 1.2 | tag == 2.2 | tag == 3.2 | tag == 4.2 ) {
          beginShape();
          vertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
          vertex(arrayDeParticulas[i+1][j].position().x(), arrayDeParticulas[i+1][j].position().y());
          vertex(arrayDeParticulas[i+1][j+1].position().x(), arrayDeParticulas[i+1][j+1].position().y());
          vertex(arrayDeParticulas[i][j+1].position().x(), arrayDeParticulas[i][j+1].position().y());
          vertex(arrayDeParticulas[i][j].position().x(), arrayDeParticulas[i][j].position().y());
          endShape();
          fill((j+30)/1.3*clr, 50, i+170*1.1, 30);
        }
      }
    }


    //se dibujan las posiciones al centro
    if (tag == 1 | tag == 1.2 ) {
      for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
        arrayDeParticulas[j][29].position().set(width/2, height/2, 0);
        //arrayDeParticulas[j][39].makeFixed();

        arrayDeParticulas[j][0].position().set(width/16*3, height/16*3, 0);
        arrayDeParticulas[j][0].makeFixed();
      }
    }

    if (tag == 2 | tag == 2.2 ) {
      for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
        arrayDeParticulas[j][29].position().set(width/16*13, height/16*3, 0);
        arrayDeParticulas[j][29].makeFixed();

        arrayDeParticulas[j][0].position().set(width/2, height/2, 0);
        //arrayDeParticulas[j][0].makeFixed();
      }
    }

    if (tag == 3 | tag == 3.2 ) {
      for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
        arrayDeParticulas[j][29].position().set(width/2, height/2, 0);
        //arrayDeParticulas[j][39].makeFixed();

        arrayDeParticulas[j][0].position().set(width/16*3, height/16*13, 0);
        arrayDeParticulas[j][0].makeFixed();
      }
    }

    if (tag == 4 | tag == 4.2 ) {
      for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
        arrayDeParticulas[j][29].position().set(width/16*13, height/16*13, 0);
        arrayDeParticulas[j][29].makeFixed();

        arrayDeParticulas[j][0].position().set(width/2, height/2, 0);
        // arrayDeParticulas[j][0].makeFixed();
      }
    }


    //arrayDeParticulas[10][20].position().set(lerp(arrayDeParticulas[25][25].position().x(), vol, 0.01), height/13, 100);
    //arrayDeParticulas[10][10].position().set(lerp(arrayDeParticulas[25][25].position().x(), vol, 0.01), height/13, 0);
    //arrayDeParticulas[20][20].position().set(lerp(arrayDeParticulas[25][25].position().x(), vol, 0.01), height/13*8, 0);
    //arrayDeParticulas[20][10].position().set(lerp(arrayDeParticulas[25][25].position().x(), vol, 0.01), height/13*8, 0);
    //arrayDeParticulas[30][30].makeFixed();


    if (esc == 1) {
      if (vol > 25) {
        arrayDeParticulas[10][20].position().set(lerp(arrayDeParticulas[25][25].position().x(), random(0, 1920), 0.01), height/13, 100);
        arrayDeParticulas[10][10].position().set(lerp(arrayDeParticulas[25][25].position().x(), random(0, 1920), 0.01), height/13, 0);
        arrayDeParticulas[20][20].position().set(lerp(arrayDeParticulas[25][25].position().x(), random(0, 1920), 0.01), height/13*8, 0);
        arrayDeParticulas[20][10].position().set(lerp(arrayDeParticulas[25][25].position().x(), random(0, 1920), 0.01), height/13*8, 0);
        //arrayDeParticulas[30][30].makeFixed();
      }
    }

    if (esc == 2) {
      if (tag == 1 || tag == 1.2) {
        if (freq > 1) {
          arrayDeParticulas[10][20].position().set(lerp(arrayDeParticulas[25][25].position().x(), freq, 0.01), height/13, 100);
          arrayDeParticulas[10][10].position().set(lerp(arrayDeParticulas[25][25].position().x(), freq, 0.01), height/13, 0);
          arrayDeParticulas[20][20].position().set(lerp(arrayDeParticulas[25][25].position().x(), freq, 0.01), height/13*8, 0);
          arrayDeParticulas[20][10].position().set(lerp(arrayDeParticulas[25][25].position().x(), freq, 0.01), height/13*8, 0);
          //arrayDeParticulas[30][30].makeFixed();
        }
      }
    }





    //for (int j = 0; j < cantidadDeParticulasPorLado-1; j++) {
    //for (int i = 0; i < cantidadDeParticulasPorLado-1; i++) {
    //mundoVirtual.makeAttraction(salida.particle, arrayDeParticulas[i][j], random(-2000,100), 50);
    //}
    ////arrayDeParticulas[30][30].makeFixed();
    //}
  }
}
