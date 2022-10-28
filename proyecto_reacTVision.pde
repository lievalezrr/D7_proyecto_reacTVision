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
Control ctlAlly1, ctlAlly2, ctlAlly3;
Control[] controles = new Control[4];

Hotspot hMain, hAlly1, hAlly2, hAlly3;

Atrapable ally1, ally2, ally3;

Tela tela1, tela1p2, tela2, tela3, tela4, tela2p2, tela3p2, tela4p2;
AnalizadorMusica analizaEscenario0, analizaEscenario1, analizaEscenario2, analizaEscenario3, analizaEscenario4;

Atrapable llave;
PImage llavePic;

int escenario;

boolean dibujarField = false;
FlowField flowfield;
ArrayList<Vehiculo> vehicles;
int vehicleAmount = 1000;

float radius;

float sideLen;
float hFondo;

Salida salida, salidaT, bolaT;

Fondo fondo;

void setup() {
  fullScreen();
  colorMode(HSB, 360, 100, 100);
  smooth();

  radius = width/4;

  mundoVirtual = new ParticleSystem(0, 0.1);
  minim = new Minim(this);
  tuioClient = new TuioProcessing(this);

  llavePic = loadImage("llave.png");
  llavePic.resize(width/16, width/16);

  llave = new Atrapable(llavePic, width/2, height/4, mundoVirtual);

  salida = new Salida(mundoVirtual, width/2, 5*height/6);

  analizaEscenario0 = new AnalizadorMusica(minim.loadFile("Esc_0_Eye.mp3", 1024));
  analizaEscenario1 = new AnalizadorMusica(minim.loadFile("Song_Esc1-Alien_1.mp3", 1024));
  analizaEscenario2 = new AnalizadorMusica(minim.loadFile("Song_Esc2-In the fire.mp3", 1024));
  analizaEscenario3 = new AnalizadorMusica(minim.loadFile("Esc_3_Eye.mp3", 1024));
  analizaEscenario4 = new AnalizadorMusica(minim.loadFile("Song_Esc4-Dark.mp3", 1024));

  ctlMain = new Control(width-80, (height/2)+80, 0, 360, #FFFFFF, mundoVirtual);

  ctlAlly1 = new Control(width-80, (height/2)+160, 0, 360, #F56045, mundoVirtual);
  ctlAlly2 = new Control(width-80, (height/2)+240, 0, 360, #CBF545, mundoVirtual);
  ctlAlly3 = new Control(width-80, (height/2)+320, 0, 360, #45F5E7, mundoVirtual);

  controles[0] = ctlMain;
  controles[1] = ctlAlly1;
  controles[2] = ctlAlly2;
  controles[3] = ctlAlly3;

  hMain = new Hotspot(width/18*12, height/18*12, #FFFFFF, width/32);
  hAlly1 = new Hotspot(width/18*6, height/18*6, #F56045, width/32);
  hAlly2 = new Hotspot(width/18*12, height/18*6, #CBF545, width/32);
  hAlly3 = new Hotspot(width/18*6, height/18*12, #45F5E7, width/32);

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

  fondo = new Fondo (radius, 50, 86);

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

  escenario = 4;
  analizaEscenario4.cancion.play();
}

void draw() {

  background(#000000);
  mundoVirtual.tick();
  println(frameRate);

  // Mover el Fiducial
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i<tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i);

    if (tobj.getSymbolID() == 8) {
      ctlMain.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }

    if (tobj.getSymbolID() == 1) {
      ctlMain.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }

    if (tobj.getSymbolID() == 2) {
      ctlMain.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }

    if (tobj.getSymbolID() == 3) {
      ctlMain.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }
  }

  if (escenario == 0) {
    fondo.drawFondo();
    fondo.b = 0;

    textSize(width/64);
    textAlign(CENTER);
    fill(#FFFFFF, 80);
    text("come, we need your help", width/2, height/2);

    //si se pone fiducial se activa escenario 1
    if (ctlMain.estaPresente == true) {
      escenario = 1;
      analizaEscenario0.cancion.pause();
      analizaEscenario1.cancion.play();
    }
  }

  if (escenario == 1) {

    //Flowfield
    fondo.drawFondo();
    fondo.b = analizaEscenario1.analizeFondo();

    // Mover el flow field y dibujarlo si fuera el caso
    flowfield.run(dibujarField);

    // Mover a los vehiculos siguiendo el flow field
    for (Vehiculo v : vehicles) {
      v.hue = analizaEscenario1.getColor();
      v.follow(flowfield, ctlMain.pos);
      v.run();
      v.sideLen = analizaEscenario1.analizeVehiculo();
    }

    ctlMain.dibujar();
    ctlMain.mover();

    if (analizaEscenario1.cancion.position() > 4700 && analizaEscenario1.cancion.position() < 10000) {
      textSize(width/64);
      textAlign(CENTER);
      fill(#FFFFFF, 80);
      text("there's something wrong here", width/2, height/2);
    }

    if (analizaEscenario1.cancion.position() > 15000 && analizaEscenario1.cancion.position() < 20000) {
      textSize(width/64);
      textAlign(CENTER);
      fill(#FFFFFF, 80);
      text("this energy, it is pulling us", width/2, height/2);
    }

    if (analizaEscenario1.cancion.position() > 25000 && llave.meAtraparon == false) {
      llave.dibujar();
      textSize(width/64);
      textAlign(CENTER);
      fill(#FFFFFF, 80);
      text("look, a key", width/2, height/2);

      // Atrapar la llave
      if (llave.getPos().dist(ctlMain.getPos()) < width/30) {
        llave.atrapar(ctlMain.particle);
      }
    }

    // Dibujar salida
    if (llave.meAtraparon == true) {
      llave.dibujar();
      salida.dibujar();
      textSize(width/64);
      textAlign(CENTER);
      fill(#FFFFFF, 80);
      text("let's find out what's going on", width/2, height/2);
    }

    // Llegar a la salida
    if (llave.meAtraparon == true && ctlMain.getPos().dist(salida.getPos()) < width/30) {
      escenario = 2;
      llave.soltar();
      analizaEscenario1.cancion.pause();
      analizaEscenario2.cancion.play();
      fondo.h = 0;
    }
  }

  if (escenario == 2) {

    //Flowfield
    fondo.drawFondo();
    fondo.b = analizaEscenario2.analizeFondo();

    // Mover el flow field y dibujarlo si fuera el caso
    flowfield.run(dibujarField);

    // Mover a los vehiculos siguiendo el flow field
    for (Vehiculo v : vehicles) {
      v.hue = analizaEscenario1.getColor();
      v.follow(flowfield, ctlMain.pos);
      v.run();
      v.sideLen = analizaEscenario2.analizeVehiculo();
    }

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
      analizaEscenario2.cancion.pause();
      analizaEscenario3.cancion.play();
    }
  }

  if (escenario == 3) {
    fondo.h = 62;
    fondo.b = 0;
    fondo.drawFondo();

    textSize(width/64);
    textAlign(CENTER);
    fill(#FFFFFF, 80);
    text("come, we need your help", width/2, height/2);

    //condicion de poner fiducials
    if (ctlMain.estaPresente == true && ctlAlly1.estaPresente == true && ctlAlly2.estaPresente == true && ctlAlly3.estaPresente == true) {
      escenario = 4;
      analizaEscenario3.cancion.pause();
      analizaEscenario4.cancion.play();
    }
  }

  if (escenario == 4) {

    fondo.h = 62;
    fondo.b = 0;
    fondo.drawFondo();

    hMain.dibujar();
    hAlly1.dibujar();
    hAlly2.dibujar();
    hAlly3.dibujar();

    analizaEscenario4.analizeColor();
    analizaEscenario4.analizeSize();
    analizaEscenario4.analizeFreq();
    //text(analizaEscenario3.getSize(), width/3, height/3);
    //fill(#FFFFFF);
    //text(analizaEscenario3.getFreq(), width/2, height/7*6);
    //tela1.setColor(analiza.getSize());
    //salida.randomize();
    //salidaT.dibujar();
    //bola.dibujar();

    if (hAlly1.meToco(ctlAlly1.pos.x, ctlAlly1.pos.y)) {
      tela1.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 2, analizaEscenario4.getGolpe());
      tela1p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe() );
    }

    if (hAlly2.meToco(ctlAlly2.pos.x, ctlAlly2.pos.y)) {
      tela2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 2, analizaEscenario4.getGolpe() );
      tela2p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe() );
    }

    if (hAlly3.meToco(ctlAlly3.pos.x, ctlAlly3.pos.y)) {
      tela3.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe() );
      tela3p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe());
    }

    if (hMain.meToco(ctlMain.pos.x, ctlMain.pos.y)) {
      tela4.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe());
      tela4p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe());
    }

    ctlMain.dibujar();
    ctlMain.mover();

    ctlAlly1.dibujar();
    ctlAlly1.mover();

    ctlAlly2.dibujar();
    ctlAlly2.mover();

    ctlAlly3.dibujar();
    ctlAlly3.mover();
  }
}

void keyPressed() {
  if (key == ' ') {
    dibujarField = !dibujarField;
  }
}

// Make a new flowfield
void mousePressed() {
  //flowfield.resetNoise();

  for (int i=0; i<controles.length; i++) {
    if (controles[i].clickDentro()) {
      controles[i].seleccionadoConMouse = !controles[i].seleccionadoConMouse;
    } else {
      controles[i].seleccionadoConMouse = false;
    }
  }
}

void addTuioObject(TuioObject tobj) {
  if (tobj.getSymbolID() == 8) {
    ctlMain.isPresent(true);
  }

  if (tobj.getSymbolID() == 1) {
    ctlAlly1.isPresent(true);
  }

  if (tobj.getSymbolID() == 2) {
    ctlAlly2.isPresent(true);
  }

  if (tobj.getSymbolID() == 3) {
    ctlAlly3.isPresent(true);
  }
}

void updateTuioObject (TuioObject tobj) {
}

void removeTuioObject(TuioObject tobj) {
  if (tobj.getSymbolID() == 8) {
    ctlMain.isPresent(false);
  }

  if (tobj.getSymbolID() == 1) {
    ctlAlly1.isPresent(false);
  }

  if (tobj.getSymbolID() == 2) {
    ctlAlly2.isPresent(false);
  }

  if (tobj.getSymbolID() == 3) {
    ctlAlly3.isPresent(false);
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
