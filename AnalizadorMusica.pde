import ddf.minim.analysis.*;
import ddf.minim.*;

class AnalizadorMusica {

  int posicion=0;
  int duracion=0;

  Minim minim; // declara la instancia de la biblioteca
  AudioPlayer cancion; // declara la variable que contendrá la canción
  FFT fftLog; // objeto que hace el análisis de las frecuencias logarítmicas
  FFT fftLin; // objeto que hace el análisis de las frecuencias lineales
  AudioMetaData metaDatos; // objeto para obtener datos de la canción

  //int tamagnoDeBuffer = 1024; // se puede usar 1024 pero 512 es más fácil de analisar visualmente

  float maximo = 0;
  // color colorDeFondo = color (64);
  float actualMax = 0;
  float colorHue = 0;
  float size, freq, golpe;
  color colorDeFondo;
  PVector posAura1, posAura2, posAura3;

  public AnalizadorMusica(AudioPlayer _cancion) {

    minim = new Minim(this);

    cancion = _cancion;

    metaDatos = cancion.getMetaData(); // carga los megadatos del archivo

    // crea el objeto FFT logarítmico con el tamaño de búfer y su relación de muestras
    // ambos son 1024 en este caso
    fftLog = new FFT( cancion.bufferSize(), cancion.sampleRate() );
    // calcula los promedios basandose en octabas que comienzan en 22 Hz
    // cada octaba la parte en tres bandas resultando 30 bandas en total
    fftLog.logAverages( 100, 3 );

    // crea el objeto FFT lineal con el tamaño de búfer y su relación de muestras
    // ambos son 1024 en este caso
    fftLin = new FFT( cancion.bufferSize(), cancion.sampleRate() );
    // calcula linearmente las bandas en grupos con promedio de 30
    fftLin.linAverages( 30 );
  }

  void analizeColor() {
    fftLog.forward( cancion.mix );

    for (int i = 0; i < fftLog.specSize(); i++) {
      // define un espectro de colores
      colorHue = map (fftLog.getBand(i), 0, 1, 0, 100); //analiza las frecuencias y da un valor
      textSize(12);
      //print(colorHue, width/2, height/2);
    }
  }

  void analizeFreq() {
    fftLog.forward( cancion.mix );
    for (int i = 0; i < fftLog.specSize(); i++) {
      freq = fftLog.getBand(i) * 1000;
      golpe = fftLog.getBand(i) * 16;
    } // fin del ciclo FOR de visualización del gráfico por logaritmo
  }

  void dibujarAuras(PVector _aura1, PVector _aura2, PVector _aura3) {
    posAura1 = _aura1;
    posAura2 = _aura2;
    posAura3 = _aura3;
    fftLog.forward( cancion.mix );
    for (int i = 0; i < fftLog.specSize(); i++) {

      //textSize(24);
      //fill(#FFFFFF);
      //text(cancion.position(), width/2, height/2);
      // cancion primera parte
      if (cancion.position() <  85000) {
        //cello
        int bandaActual = 10;
        if (i>bandaActual-10 && i <bandaActual+10) {
          //if (maximo < fftLog.getBand(i)) maximo = fftLog.getBand(i);
          float radio = fftLog.getBand(i) ;
          float transparencia = map (fftLog.getBand(i), 0, 3, 1, 0.5);
          colorDeFondo = color (94, 35, 83, 50); // color base 219,42,67 o #637CAD
          fill(colorDeFondo);
          noStroke();
          circle(posAura1.x, posAura1.y, radio/2);
          //imprimaValoresMaximos (i, bandaActual);
        }
        // piano---------------------

        bandaActual = 25;

        if (i>bandaActual-10 && i <bandaActual+10) {
          //if (maximo < fftLog.getBand(i)) maximo = fftLog.getBand(i);
          float radio = fftLog.getBand(i) ;
          float transparencia = map (fftLog.getBand(i), 0, 3, 1, 0.5);
          colorDeFondo = color (94, 0, 100, 50); // color base 219,42,67 o #637CAD
          fill(colorDeFondo);
          noStroke();
          circle(posAura2.x, posAura2.y, radio);
          //imprimaValoresMaximos (i, bandaActual);
        }
        // synth---------------------

        bandaActual = 40;
        if (i>bandaActual-10 && i <bandaActual+10) {
          float radio = fftLog.getBand(i);
          float transparencia = map (fftLog.getBand(i), 0, 3, 1, 0.5);
          colorDeFondo = color (47, 73, 92, 50); // color base 219,42,67 o #637CAD
          fill(colorDeFondo);
          noStroke();
          circle(posAura3.x, posAura3.y, radio);
        } // fin del ciclo FOR de visualización del gráfico por logaritmo
      }
    }
  }

  void analizeSize() {
    size = map(cancion.mix.level(), 0, 1, 1, 100); //analiza el volumen y tira un tamaño en relación
  }

  float analizeFondo(int min, int max) {
    return map(cancion.mix.level(), 0, 1, min, max); //analiza el volumen y tira un tamaño en relación
  }

  float analizeVehiculo() {
    return map(cancion.mix.level(), 0, 1, 0.5, 10); //analiza el volumen y tira un tamaño en relación
  }

  float getColor() {
    return colorHue;
  }

  float getSize() {
    return size;
  }

  float getFreq() {
    return freq;
  }

  float getGolpe() {
    return golpe;
  }
}
