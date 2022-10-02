import ddf.minim.analysis.*;
import ddf.minim.*;

class Musica {

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
  float size;

  public Musica(AudioPlayer _cancion) {

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
      colorHue = map (fftLog.getBand(i), 0, 1, 0, 200); //analiza las frecuencias y da un valor
      textSize(12);
      //print(colorHue, width/2, height/2);
    }
  }

  void analizeSize() {
    size = map(cancion.mix.level(), 0, 1, 0, 50); //analiza el volumen y tira un tamaño en relación
  }

  float getColor() {
    return colorHue;
  }

  float getSize() {
    return size;
  }
}
