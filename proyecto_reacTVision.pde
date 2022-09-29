/* Tecnológico de Costa Rica
 Escuela de Diseño Industrial
 D7 Visual - Tarea 3 Music Visualization
 Valeria Navarro - 2018254437
 Samantha Pan Tseng  - 2019065194
 Elke Segura Badilla - 2018086696
 Leslie Valeria Serrano - 2019159088
 */

import ddf.minim.analysis.*;
import ddf.minim.*;
import traer.physics.*;
import peasy.*;

PeasyCam laCamara;

Red red;
Musica analiza;

Minim minim; // declara la instancia de la biblioteca
AudioPlayer cancion; // declara la variable que contendrá la canción
FFT fftLog; // objeto que hace el análisis de las frecuencias logarítmicas
FFT fftLin; // objeto que hace el análisis de las frecuencias lineales
AudioMetaData metaDatos; // objeto para obtener datos de la canción



void setup() {
  size(1150, 650, P3D);
  colorMode(HSB);
  smooth();
  laCamara = new PeasyCam(this, 0, 0, 0, 600);
  minim = new Minim(this);

  red = new Red();
  analiza = new Musica(minim.loadFile("tensePiano.mp3", 1024));
}

void draw() {
  background(#000000); // gris 25%
  analiza.cancion.play();
  analiza.analizeColor();
  analiza.analizeSize();
  red.setSize(analiza.getSize());
  red.setColor(analiza.getColor());

  red.dibujarRed();
  textSize(12);
  fill(0, 408, 612);
  print(analiza.getColor(), width/2, height/2);
}
