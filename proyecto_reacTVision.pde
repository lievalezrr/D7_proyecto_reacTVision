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

ParticleSystem mundoVirtual;

Minim minim;
AudioPlayer cancion;

FFT fftLog;
FFT fftLin;

AudioMetaData metaDatos;

TuioProcessing tuioClient;
Control ctlMain;

Atrapable ally1, ally2, ally3;

Tela tela1, tela1p2, tela2, tela3, tela4, tela2p2, tela3p2, tela4p2;
AnalizadorMusica analizaEscenario1, analizaEscenario2, analizaEscenario3;

Atrapable llave;
PImage llavePic;

int escenario;

// Flow Field
boolean dibujarField = false;
FlowField flowfield;
ArrayList<Vehiculo> vehicles;
int vehicleAmount = 2000;
// no estoy segura por qué este radius hay que multiplicarlo por width, pero así venía
float radius = 6*width;

float sideLen;

Salida salida, salidaT, bolaT;

Fondo fondo;

void setup() {
  fullScreen();
  colorMode(HSB, 360, 100, 100);
  smooth();

  mundoVirtual = new ParticleSystem(0, 0.1);
  //laCamara = new PeasyCam(this, 0, 0, 0, 600);
  minim = new Minim(this);
  tuioClient = new TuioProcessing(this);

  llavePic = loadImage("llave.png");
  llavePic.resize(width/16, width/16);

  llave = new Atrapable(llavePic, width/2, height/4, mundoVirtual);

  salida = new Salida(mundoVirtual, width/2, 5*height/6);

  analizaEscenario1 = new AnalizadorMusica(minim.loadFile("eye.mp3", 1024));
  analizaEscenario2 = new AnalizadorMusica(minim.loadFile("Dark tecno.mp3", 1024));
  analizaEscenario3 = new AnalizadorMusica(minim.loadFile("Alien.mp3", 1024));

  ctlMain = new Control(width-80, (height/2)+80, 0, 360, #FFFFFF, mundoVirtual);

  ally1 = new Atrapable(llavePic, width*2/6, height/2, mundoVirtual);
  ally2 = new Atrapable(llavePic, width*3/6, height/5, mundoVirtual);
  ally3 = new Atrapable(llavePic, width*4/6, height/2, mundoVirtual);

  salidaT = new Salida(mundoVirtual, width/2, height/2);
  bolaT = new Salida(mundoVirtual, width/5, height/3);

  tela1 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*2, 1);
  tela1p2 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*2, 1.2);

  tela2 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*2, 2);
  tela2p2 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*2, 2.2);

  tela3 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*14, 3);
  tela3p2 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*14, 3.2);

  tela4 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*14, 4);
  tela4p2 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*14, 4.2);

  fondo = new Fondo (radius, 50);

  flowfield = new FlowField(20);
  vehicles = new ArrayList<Vehiculo>();

  // Crear los vehiculos dentro del radio del circulo
  for (int i = 0; i < vehicleAmount; i++) {
    float r = radius * sqrt(random(1));
    float theta = random(1) * 2 * PI;
    float x = (width/2) + r * cos(theta);
    float y = (height/2) + r * sin(theta);
    vehicles.add(new Vehiculo(new PVector(x, y), 3.0, random(2, 5), random(0.1, 0.5), radius, 100.0, 4.0, 20));
  }


  escenario = 1;
}

void draw() {

  background(#000000);
  mundoVirtual.tick();
  println(frameRate);



  // Mover el Feid
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i<tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i);

    if (tobj.getSymbolID() == 8) {
      ctlMain.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }
  }

  // Flow Field
  if (escenario == 1 || escenario == 2) {
    fondo.drawFondo();
    fondo.h = analizaEscenario1.analizeFondo();

    // Mover el flow field y dibujarlo si fuera el caso
    flowfield.run(dibujarField);

    // Mover a los vehiculos siguiendo el flow field
    for (Vehiculo v : vehicles) {
      v.follow(flowfield, ctlMain.pos);
      v.run();

      // volumen tamano
      v.sideLen = analizaEscenario1.analizeVehiculo();
    }
  }

  if (escenario == 1) {

    analizaEscenario1.cancion.play();

    ctlMain.dibujar();
    ctlMain.mover();

    llave.dibujar();

    // Atrapar la llave
    if (llave.meAtraparon == false && llave.getPos().dist(ctlMain.getPos()) < width/30) {
      llave.atrapar(ctlMain.particle);
    }

    // Dibujar salida
    if (llave.meAtraparon == true) {
      salida.dibujar();
    }

    // Llegar a la salida
    if (llave.meAtraparon == true && ctlMain.getPos().dist(salida.getPos()) < width/30) {
      escenario = 2;
      llave.soltar();
    }
  }

  if (escenario == 2) {

    ctlMain.dibujar();
    ctlMain.mover();

    ally1.dibujar();
    ally2.dibujar();
    ally3.dibujar();

    // Atrapar ally1
    if (ally1.meAtraparon == false && ally1.getPos().dist(ctlMain.getPos()) < width/30) {
      ally1.atrapar(ctlMain.particle);
    }
    // Atrapar ally2
    if (ally2.meAtraparon == false && ally1.meAtraparon == true && ally2.getPos().dist(ctlMain.getPos()) < width/30) {
      ally2.atrapar(ally1.particle);
    }
    // Atrapar ally3
    if (ally3.meAtraparon == false && ally1.meAtraparon == true && ally2.meAtraparon == true && ally3.getPos().dist(ctlMain.getPos()) < width/30) {
      ally3.atrapar(ally2.particle);
    }

    // Dibujar salida
    if (ally3.meAtraparon == true) {
      salida.dibujar();
    }

    // Llegar a la salida
    if (ally3.meAtraparon == true && ctlMain.getPos().dist(salida.getPos()) < width/30) {
      escenario = 3;
      llave.soltar();
    }
  }

  if (escenario ==3) {
    background(#000000);
    analizaEscenario1.cancion.pause();
    analizaEscenario3.cancion.play();
    analizaEscenario3.analizeColor();
    analizaEscenario3.analizeSize();
    analizaEscenario3.analizeFreq();
    text(analizaEscenario3.getSize(), width/3, height/3);
    fill(#FFFFFF);
    text(analizaEscenario3.getFreq(), width/2, height/7*6);
    //tela1.setColor(analiza.getSize());
    //salida.randomize();
    //salidaT.dibujar();
    //bola.dibujar();

    tela1.dibujar(analizaEscenario3.getSize(), analizaEscenario3.getColor(), analizaEscenario3.getFreq() );
    tela1p2.dibujar(analizaEscenario3.getSize(), analizaEscenario3.getColor(), analizaEscenario3.getFreq() );
    //tela1.repulsion(mundoVirtual);

    tela2.dibujar(analizaEscenario3.getSize(), analizaEscenario3.getColor(), analizaEscenario3.getFreq() );
    tela2p2.dibujar(analizaEscenario3.getSize(), analizaEscenario3.getColor(), analizaEscenario3.getFreq() );

    tela3.dibujar(analizaEscenario3.getSize(), analizaEscenario3.getColor(), analizaEscenario3.getFreq() );
    tela3p2.dibujar(analizaEscenario3.getSize(), analizaEscenario3.getColor(), analizaEscenario3.getFreq() );


    tela4.dibujar(analizaEscenario3.getSize(), analizaEscenario3.getColor(), analizaEscenario3.getFreq());
    tela4p2.dibujar(analizaEscenario3.getSize(), analizaEscenario3.getColor(), analizaEscenario3.getFreq());
  }
}

void keyPressed() {
  if (key == ' ') {
    dibujarField = !dibujarField;
  }
}

// Make a new flowfield
void mousePressed() {
  flowfield.resetNoise();
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
