/* Tecnológico de Costa Rica
 Escuela de Diseño Industrial
 D7 Visual - Tarea 3 Music Visualization
 Valeria Navarro - 2018254437
 Samantha Pan Tseng  - 2019065194
 Elke Segura Badilla - 2018086696
 Leslie Valeria Serrano - 2019159088
 */
 
import traer.physics.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import peasy.*;
import TUIO.*;

PeasyCam laCamara;

Red red;
Musica analiza;
ParticleSystem mundoVirtual;

Minim minim; 
AudioPlayer cancion; 

FFT fftLog; 
FFT fftLin; 

AudioMetaData metaDatos; 

TuioProcessing tuioClient;
Control ctlMain;

Llave llave;
PImage llavePic;

Salida salida;

void setup() {
  size(displayWidth, displayHeight);
  colorMode(HSB);
  smooth();
  
  mundoVirtual = new ParticleSystem(0, 0.1);
  //laCamara = new PeasyCam(this, 0, 0, 0, 600);
  minim = new Minim(this);
  tuioClient = new TuioProcessing(this);

  llavePic = loadImage("llave.png");
  llavePic.resize(width/8, width/8);

  llave = new Llave(llavePic, width/4, height/4);
  red = new Red(mundoVirtual);
  
  salida = new Salida(mundoVirtual, 120, 120);
  red.repulsion(mundoVirtual, salida);
  
  analiza = new Musica(minim.loadFile("escapethedead.mp3", 1024));

  ctlMain = new Control(width-80, (height/2)+80, 0, 360, "Main");
}

void draw() {
  background(#000000);
  mundoVirtual.tick(); 

  analiza.cancion.play();
  analiza.analizeColor();
  analiza.analizeSize();

  red.setSize(analiza.getSize());
  red.setColor(analiza.getColor());

  red.dibujarRed(ctlMain.posDest);
  salida.dibujar();

  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i<tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i);

    if (tobj.getSymbolID() == 8) {
      ctlMain.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }
  }
  fill(#FFFFFF);
  stroke(#FFFFFF);
  ctlMain.dibujar();
  ctlMain.mover();

  llave.dibujar();
  if (llave.getPos().dist(ctlMain.getPos()) < width/15) {
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
