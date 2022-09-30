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
import TUIO.*;

PeasyCam laCamara;

Red red;
Musica analiza;

Minim minim; // declara la instancia de la biblioteca
AudioPlayer cancion; // declara la variable que contendrá la canción

FFT fftLog; // objeto que hace el análisis de las frecuencias logarítmicas
FFT fftLin; // objeto que hace el análisis de las frecuencias lineales

AudioMetaData metaDatos; // objeto para obtener datos de la canción

TuioProcessing tuioClient;
Control ctlMain;

Llave llave;
PImage llavePic;

void setup() {
  size(1150, 650, P3D);
  colorMode(HSB);
  smooth();

  laCamara = new PeasyCam(this, 0, 0, 0, 600);
  minim = new Minim(this);
  tuioClient = new TuioProcessing(this);

  llavePic = loadImage("llave.png");
  llavePic.resize(width/8,width/8);
  
  llave = new Llave(llavePic, width/4, height/4);

  red = new Red();
  analiza = new Musica(minim.loadFile("escapethedead.mp3", 1024));

  ctlMain = new Control(width-80, (height/2)+80, 0, 360, "Main");
}

void draw() {
  background(#000000);

  analiza.cancion.play();
  analiza.analizeColor();
  analiza.analizeSize();

  red.setSize(analiza.getSize());
  red.setColor(analiza.getColor());

  red.dibujarRed(ctlMain.posDest);

  //textSize(12);
  //fill(0, 408, 612);
  //print(analiza.getColor(), width/2, height/2);

  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i<tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i);

    if (tobj.getSymbolID() == 8) {
      ctlMain.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }
  }

  ctlMain.dibujar();
  ctlMain.mover();
  
    llave.dibujar();
  if (llave.getPos().dist(ctlMain.getPos()) < width/20){
    llave.meAtraparon(ctlMain.getPos());
  }
  
}

void addTuioObject(TuioObject tobj) {
  if (tobj.getSymbolID() == 8) {
    ctlMain.isPresent(true);
  }
}

void updateTuioObject (TuioObject tobj) {
}

void removeTuioObject(TuioObject tobj) {
  if (tobj.getSymbolID() == 8) {
    ctlMain.isPresent(false);
  }
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
}

// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
}

// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
}
