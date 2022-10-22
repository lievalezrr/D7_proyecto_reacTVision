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

Musica analiza;
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
MusicaTelas analizaM;

Atrapable llave;
PImage llavePic;

int escenario;

// Flow Field
boolean dibujarField = false;
FlowField flowfield;
ArrayList<Vehicle> vehicles;
int vehicleAmount = 1000;
float radius = width*3.5;

Salida salida, salidaT, bolaT;

void setup() {
  fullScreen();
  colorMode(HSB);
  smooth();

  mundoVirtual = new ParticleSystem(0, 0.1);
  //laCamara = new PeasyCam(this, 0, 0, 0, 600);
  minim = new Minim(this);
  tuioClient = new TuioProcessing(this);

  llavePic = loadImage("llave.png");
  llavePic.resize(width/8, width/8);

  llave = new Atrapable(llavePic, width/4, height/4, mundoVirtual);

  salida = new Salida(mundoVirtual, 120, 120);

  analiza = new Musica(minim.loadFile("escapethedead.mp3", 1024));

  ctlMain = new Control(width-80, (height/2)+80, 0, 360, #FFFFFF, mundoVirtual);

  ally1 = new Atrapable(llavePic, width*2/6, height/2, mundoVirtual);
  ally2 = new Atrapable(llavePic, width*3/6, height/2, mundoVirtual);
  ally3 = new Atrapable(llavePic, width*4/6, height/2, mundoVirtual);

  analizaM = new MusicaTelas(minim.loadFile("escapethedead.mp3", 1024));

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

  flowfield = new FlowField(20);
  vehicles = new ArrayList<Vehicle>();

  // Crear los vehiculos dentro del radio del circulo
  for (int i = 0; i < vehicleAmount; i++) {
    float r = radius * sqrt(random(1));
    float theta = random(1) * 2 * PI;
    float x = (width/2) + r * cos(theta);
    float y = (height/2) + r * sin(theta);
    vehicles.add(new Vehicle(new PVector(x, y), random(2, 5), random(0.1, 0.5), radius));
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
    // Dibujar la barrera circular
    fill(255);
    circle(width/2, height/2, radius*2);
    // Mover el flow field y dibujarlo si fuera el caso
    flowfield.run(dibujarField);
    // Mover a los vehiculos siguiendo el flow field
    for (Vehicle v : vehicles) {
      v.follow(flowfield);
      v.run();
    }
  }

  if (escenario == 1) {

    analiza.cancion.play();
    analiza.analizeColor();
    analiza.analizeSize();

    salida.dibujar();

    ctlMain.dibujar();
    ctlMain.mover();

    llave.dibujar();

    // Atrapar la llave
    if (llave.meAtraparon == false && llave.getPos().dist(ctlMain.getPos()) < width/30) {
      llave.atrapar(ctlMain.particle);
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
    //Atrapar ally2
    if (ally2.meAtraparon == false && ally1.meAtraparon == true && ally2.getPos().dist(ctlMain.getPos()) < width/30) {
      ally2.atrapar(ally1.particle);
    }
    //Atrapar ally3
    if (ally3.meAtraparon == false && ally1.meAtraparon == true && ally2.meAtraparon == true && ally3.getPos().dist(ctlMain.getPos()) < width/30) {
      ally3.atrapar(ally2.particle);
      escenario = 3;
    }
  }

  if (escenario ==3) {
    background(#000000);
    analiza.cancion.pause();
    analizaM.cancion.play();
    analizaM.analizeColor();
    analizaM.analizeSize();
    text(analizaM.getSize(), width/3, height/3);
    //tela1.setColor(analiza.getSize());
    //salida.randomize();
    //salidaT.dibujar();
    //bola.dibujar();

    tela1.dibujar(analizaM.getSize(), analizaM.getColor() );
    tela1p2.dibujar(analizaM.getSize(), analizaM.getColor() );
    //tela1.repulsion(mundoVirtual);

    tela2.dibujar(analizaM.getSize(), analizaM.getColor() );
    tela2p2.dibujar(analizaM.getSize(), analizaM.getColor() );

    tela3.dibujar(analizaM.getSize(), analizaM.getColor() );
    tela3p2.dibujar(analizaM.getSize(), analizaM.getColor() );


    tela4.dibujar(analizaM.getSize(), analizaM.getColor() );
    tela4p2.dibujar(analizaM.getSize(), analizaM.getColor() );
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
