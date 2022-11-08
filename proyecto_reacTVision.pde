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
import TUIO.*;

ParticleSystem mundoVirtual;

Minim minim;
AudioPlayer cancion;

FFT fftLog;
FFT fftLin;

AudioMetaData metaDatos;
AudioSample cambioPersonaje, aliado, finalExplosion, hotSpot, llaveSonido, salidaSonido, salida1;

TuioProcessing tuioClient;
Control ctlMain;
Control ctlAlly1, ctlAlly2, ctlAlly3;
Control[] controles = new Control[4];

Hotspot hMain, hAlly1, hAlly2, hAlly3;

Atrapable ally1, ally2, ally3;

Tela tela1, tela1p2, tela2, tela3, tela4, tela2p2, tela3p2, tela4p2;
TelaAuras telaAlly1, telaAlly2, telaAlly3;
AnalizadorMusica analizaEscenario0, analizaEscenario1, analizaEscenario2, analizaEscenario3, analizaEscenario4, analizaEscenario5;

Atrapable llave;
PImage llavePic;
PImage aliadoPic1, aliadoPic2, aliadoPic3;
PImage huecoPic;
PImage mainPic1, mainPic2, mainPic3;
PImage spotPic;

PFont font;

color colorNegro = #000000;
color colorBlanco = #FFFFFF;
color colorRojo = #F56045;
color colorVerde = #CBF545;
color colorAzul = #45F5E7;

int hueVerde = 86;
int hueRojo = 0;
int hueAzul = 241;

int escenario;
boolean lightMode = false;

boolean dibujarField = false;
FlowField flowfield;
ArrayList<Vehiculo> vehicles;
int vehicleAmount = 1000;

float radius;

float sideLen;
float hFondo;

Salida salida, salidaT, bolaT;

Fondo fondo;
Texto texto;

ProgressBar progressBar;

void setup() {
  fullScreen();
  colorMode(HSB, 360, 100, 100);
  smooth();

  font = createFont("PPNeueMachina-InktrapLight.otf", width/50);
  textFont(font);

  radius = width/3;

  mundoVirtual = new ParticleSystem(0, 0.1);
  minim = new Minim(this);
  tuioClient = new TuioProcessing(this);

  mainPic1 = loadImage("MainCtlAzul.png");
  mainPic1.resize(width/16, width/16);
  mainPic2 = loadImage("MainCtlRojo.png");
  mainPic2.resize(width/16, width/16);
  mainPic3 = loadImage("mainVerde.png");

  llavePic = loadImage("llave.png");
  //llavePic.resize(width/16, width/16);

  aliadoPic1 = loadImage("here.png");

  aliadoPic2 = loadImage("here.png");

  aliadoPic3 = loadImage("here.png");
  huecoPic = loadImage("hueco.png");

  llave = new Atrapable(llavePic, width/2, height*3/4, mundoVirtual);

  salida = new Salida(mundoVirtual, width/2, height/6);

  analizaEscenario0 = new AnalizadorMusica(minim.loadFile("Esc_0_Eye.mp3", 1024));
  analizaEscenario1 = new AnalizadorMusica(minim.loadFile("Song_Esc1-Alien_1.mp3", 1024));
  analizaEscenario2 = new AnalizadorMusica(minim.loadFile("Song_Esc2-In the fire.mp3", 1024));
  analizaEscenario3 = new AnalizadorMusica(minim.loadFile("Esc_3_Eye.mp3", 1024));
  analizaEscenario4 = new AnalizadorMusica(minim.loadFile("Song_Esc4-Dark.mp3", 1024));
  analizaEscenario5 = new AnalizadorMusica(minim.loadFile("Esc_3_Eye.mp3", 1024));
  
  

  ctlMain = new Control(width/2, height/2, 0, 360, colorBlanco, colorNegro, mundoVirtual, mainPic1, mainPic2, mainPic3);

  ctlAlly1 = new Control(width-80, (height/2)+160, 0, 360, colorRojo, colorRojo, mundoVirtual, aliadoPic1, aliadoPic1, aliadoPic1);
  ctlAlly2 = new Control(width-80, (height/2)+240, 0, 360, colorVerde, colorVerde, mundoVirtual, aliadoPic2, aliadoPic2, aliadoPic2);
  ctlAlly3 = new Control(width-80, (height/2)+320, 0, 360, colorAzul, colorAzul, mundoVirtual, aliadoPic3, aliadoPic3, aliadoPic3);

  controles[0] = ctlMain;
  controles[1] = ctlAlly1;
  controles[2] = ctlAlly2;
  controles[3] = ctlAlly3;

  hMain = new Hotspot(width/18*12, height/18*12, colorBlanco, colorNegro, width/32);
  hAlly1 = new Hotspot(width/18*6, height/18*6, colorRojo, colorRojo, width/32);
  hAlly2 = new Hotspot(width/18*12, height/18*6, colorVerde, colorVerde, width/32);
  hAlly3 = new Hotspot(width/18*6, height/18*12, colorAzul, colorAzul, width/32);

  ally1 = new Atrapable(aliadoPic1, width*2/6, height/2, mundoVirtual);
  ally2 = new Atrapable(aliadoPic2, width*3/6, height/5, mundoVirtual);
  ally3 = new Atrapable(aliadoPic3, width*4/6, height/2, mundoVirtual);

  tela1 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*2, 1);
  tela1p2 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*2, 1.2);

  tela2 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*2, 2);
  tela2p2 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*2, 2.2);

  tela3 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*14, 3);
  tela3p2 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*14, 3.2);

  tela4 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*14, 4);
  tela4p2 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*14, 4.2);

  telaAlly1 = new TelaAuras(mundoVirtual, 10, ally1.getX(), ally1.getY(), 1);
  telaAlly2 = new TelaAuras(mundoVirtual, 10, ally2.getX(), ally2.getY(), 2);
  telaAlly3 = new TelaAuras(mundoVirtual, 10, ally3.getX(), ally3.getY(), 3);

  fondo = new Fondo (radius, 86, 100, 50);
  texto = new Texto();

  flowfield = new FlowField(20);
  vehicles = new ArrayList<Vehiculo>();
  
  cambioPersonaje= minim.loadSample("sfxCambioPersonaje.mp3");
  aliado= minim.loadSample("sfxAliado.mp3");
  finalExplosion= minim.loadSample("sfxFinalExplosion.mp3");
  hotSpot= minim.loadSample("sfxHotSpot.mp3");
  llaveSonido=minim.loadSample("sfxLlave.mp3");
  salidaSonido= minim.loadSample("sfxSalida.mp3");
  salida1=minim.loadSample("sfxSalida1.mp3");

  for (int i = 0; i < vehicleAmount; i++) {
    float r = radius * sqrt(random(1));
    float theta = random(1) * 2 * PI;
    float x = (width/2) + r * cos(theta);
    float y = (height/2) + r * sin(theta);
    vehicles.add(new Vehiculo(new PVector(x, y), 3.0, random(2, 5), random(0.1, 0.5), radius, 100.0, 4.0, 20));
  }

  progressBar = new ProgressBar(width/16, height*11/12, width - width*2/16, height/64);

  escenario = 0;
  analizaEscenario0.cancion.play();

  progressBar.setUp(analizaEscenario4.cancion.length());
}

void draw() {

  if (lightMode) background(colorBlanco);
  else background(colorNegro);

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

    if (lightMode) fondo.hsb(ctlMain.hueTheme, analizaEscenario0.analizeFondo(0, 100), 100);
    else fondo.hsb(ctlMain.hueTheme, 100, analizaEscenario0.analizeFondo(0, 80));
    fondo.drawFondo();
    texto.say("come, we need your help");
    progressBar.paint(color(ctlMain.hueTheme, 80, 100));

    //si se pone fiducial se activa escenario 1
    if (ctlMain.estaPresente == true) {
      escenario = 1;
      analizaEscenario0.cancion.pause();
      analizaEscenario1.cancion.play();
      progressBar.setUp(analizaEscenario1.cancion.length());
    }
  }

  if (escenario == 1) {

    if (lightMode) fondo.hsb(ctlMain.hueTheme, analizaEscenario1.analizeFondo(0, 100), 100);
    else fondo.hsb(ctlMain.hueTheme, 100, analizaEscenario1.analizeFondo(0, 80));
    fondo.drawFondo();
    progressBar.paint(color(ctlMain.hueTheme, 80, 100));

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
      texto.say("there's something wrong here");
    }

    if (analizaEscenario1.cancion.position() > 15000 && analizaEscenario1.cancion.position() < 20000) {
      texto.say("this energy, it's pulling us");
    }

    if (analizaEscenario1.cancion.position() > 25000 && llave.meAtraparon == false) {
      llave.dibujar();
      llaveSonido.trigger();
      texto.say("look, a key");

      // Atrapar la llave
      if (llave.getPos().dist(ctlMain.getPos()) < width/30) {
        llave.atrapar(ctlMain.particle);
      }
    }

    // Dibujar salida
    if (llave.meAtraparon == true) {
      llave.dibujar();
      salida.dibujar();
      salidaSonido.trigger();
      
      texto.say("let's find out what's going on");
    }

    // Llegar a la salida
    if (llave.meAtraparon == true && ctlMain.getPos().dist(salida.getPos()) < width/30) {
      escenario = 2;
      llave.soltar();
      analizaEscenario1.cancion.pause();
      analizaEscenario2.cancion.play();
      salida1.trigger();
      progressBar.setUp(analizaEscenario2.cancion.length());
      fondo.h = 0;
    }
  }

  if (escenario == 2) {

    if (lightMode) fondo.hsb(ctlMain.hueTheme, analizaEscenario2.analizeFondo(0, 100), 100);
    else fondo.hsb(ctlMain.hueTheme, 100, analizaEscenario2.analizeFondo(0, 80));
    fondo.drawFondo();
    progressBar.paint(color(ctlMain.hueTheme, 80, 100));

    flowfield.run(dibujarField);

    for (Vehiculo v : vehicles) {
      v.hue = analizaEscenario1.getColor();
      v.follow(flowfield, ctlMain.pos);
      v.run();
      v.sideLen = analizaEscenario2.analizeVehiculo();
    }

    if (analizaEscenario2.cancion.position() > 4700 && ally1.meAtraparon == false && ally2.meAtraparon == false && ally3.meAtraparon == false) {
      texto.say("find your allies \n 3 to go");
      if (ally1.getPos().dist(ctlMain.getPos()) < width/30) {
        ally1.atrapar(ctlMain.particle);
        aliado.trigger();
      }
    }

    if (analizaEscenario2.cancion.position() > 5000 && ally1.meAtraparon == true && ally2.meAtraparon == false && ally3.meAtraparon == false) {
      texto.say("find your allies \n 2 to go");
      if (ally2.getPos().dist(ctlMain.getPos()) < width/30) {
        ally2.atrapar(ally1.particle);
        aliado.trigger();
      }
    }

    if (analizaEscenario2.cancion.position() > 5000 && ally1.meAtraparon == true && ally2.meAtraparon == true && ally3.meAtraparon == false) {
      texto.say("find your allies \n 1 to go");
      if (ally3.getPos().dist(ctlMain.getPos()) < width/30) {
        ally3.atrapar(ally2.particle);
        aliado.trigger();
      }
    }

    if (analizaEscenario2.cancion.position() > 5000 && ally1.meAtraparon == true && ally2.meAtraparon == true && ally3.meAtraparon == true) {
      texto.say("we're in this together \n are you ready for what's on the other side?");
      salida.dibujar();
      salidaSonido.trigger();
    }

    // Llegar a la salida
    if (ally3.meAtraparon == true && ctlMain.getPos().dist(salida.getPos()) < width/30) {
      escenario = 3;
      llave.soltar();
      analizaEscenario2.cancion.pause();
      salida1.trigger();
      analizaEscenario3.cancion.play();
      
      progressBar.setUp(analizaEscenario3.cancion.length());
    }

    ctlMain.dibujar();
    ctlMain.mover();
    analizaEscenario2.analizeFreq();
    analizaEscenario2.analizeSize();
    telaAlly1.dibujar(1, analizaEscenario2.getFreq(), analizaEscenario2.getGolpe(), ally1.getPos(),analizaEscenario2.getSize());
    telaAlly2.dibujar(1, analizaEscenario2.getFreq(), analizaEscenario2.getGolpe(), ally2.getPos(),analizaEscenario2.getSize());
    telaAlly3.dibujar(1, analizaEscenario2.getFreq(), analizaEscenario2.getGolpe(), ally3.getPos(),analizaEscenario2.getSize());
    fill(#FFFFFF);
    text(analizaEscenario2.getFreq(),width/2, width/8*7);
    // analizaEscenario2.dibujarAuras(ally1.getPos(), ally2.getPos(), ally3.getPos());
    ally1.dibujar();
    ally2.dibujar();
    ally3.dibujar();
  }

  if (escenario == 3) {

    if (lightMode) fondo.hsb(ctlMain.hueTheme, analizaEscenario2.analizeFondo(0, 100), 100);
    else fondo.hsb(ctlMain.hueTheme, 80, analizaEscenario2.analizeFondo(0, 80));
    fondo.drawFondo();
    texto.say("place your allies");
    progressBar.paint(color(ctlMain.hueTheme, 80, 100));

    //condicion de poner fiducials
    if (ctlMain.estaPresente == true && ctlAlly1.estaPresente == true && ctlAlly2.estaPresente == true && ctlAlly3.estaPresente == true) {
      escenario = 4;
      analizaEscenario3.cancion.pause();
      analizaEscenario4.cancion.play();
      progressBar.setUp(analizaEscenario4.cancion.length());
    }
  }

  if (escenario == 4) {

    if (lightMode) fondo.hsb(ctlMain.hueTheme, analizaEscenario4.analizeFondo(0, 100), 100);
    else fondo.hsb(ctlMain.hueTheme, 100, analizaEscenario4.analizeFondo(0, 80));
    fondo.drawFondo();
    progressBar.paint(color(ctlMain.hueTheme, 80, 100));

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

    int alliesFaltantes = 4;

    if (hAlly1.meToco(ctlAlly1.pos.x, ctlAlly1.pos.y)) {
      tela1.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), ctlMain.hueTheme);
      tela1p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), 1 );
      alliesFaltantes--;
      hotSpot.trigger();
    }

    if (hAlly2.meToco(ctlAlly2.pos.x, ctlAlly2.pos.y)) {
      tela2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), ctlMain.hueTheme);
      tela2p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), 1 );
      alliesFaltantes--;
      hotSpot.trigger();
    }

    if (hAlly3.meToco(ctlAlly3.pos.x, ctlAlly3.pos.y)) {
      tela3.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), ctlMain.hueTheme);
      tela3p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), 1);
      alliesFaltantes--;
      hotSpot.trigger();
    }

    if (hMain.meToco(ctlMain.pos.x, ctlMain.pos.y)) {
      tela4.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), ctlMain.hueTheme);
      tela4p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), 1);
      alliesFaltantes--;
      hotSpot.trigger();
    }

    if (alliesFaltantes > 0) {

      //tela1.setComportamiento(1);
      // tela1p2.setComportamiento(1);
      // tela2.setComportamiento(1);
      // tela2p2.setComportamiento(1);
      // tela3.setComportamiento(1);
      // tela3p2.setComportamiento(1);
      // tela4.setComportamiento(1);
      // tela4p2.setComportamiento(1);

      //alliesFaltantes--;
      texto.say("we need to set it free, \n still missing " + alliesFaltantes);
    } else {
      if (analizaEscenario4.cancion.position() < 40000) {
        texto.say("yes, it's working!");
      }
      if (analizaEscenario4.cancion.position() > 40000 && analizaEscenario4.cancion.position() < 60000) {
        texto.say("we're halfway there!");
      }
      if (analizaEscenario4.cancion.position() > 60000) {
        texto.say("soon, very soon, \n it'll be free");
      }
    }

    ctlMain.dibujar();
    ctlMain.mover();

    ctlAlly1.dibujar();
    ctlAlly1.mover();

    ctlAlly2.dibujar();
    ctlAlly2.mover();

    ctlAlly3.dibujar();
    ctlAlly3.mover();

    if (!analizaEscenario4.cancion.isPlaying() && hAlly1.meToco(ctlAlly1.pos.x, ctlAlly1.pos.y) && hAlly2.meToco(ctlAlly2.pos.x, ctlAlly2.pos.y) &&
      hAlly3.meToco(ctlAlly3.pos.x, ctlAlly3.pos.y) && hMain.meToco(ctlMain.pos.x, ctlMain.pos.y)) {
      escenario = 5;
      analizaEscenario5.cancion.play();
      analizaEscenario5.cancion.loop();
      //progressBar.setUp(analizaEscenario5.cancion.length());
    }
  }

  if (escenario == 5) {

    if (lightMode) fondo.hsb(241, analizaEscenario5.analizeFondo(0, 100), 100);
    else fondo.hsb(0, 0, analizaEscenario5.analizeFondo(0, 80));
    fondo.drawFondo();
    texto.say("I'd forgotten how it felt to be free, \n thank you");
    //progressBar.paint(color(0, 0, 100));
  }
}

void rewind() {
  if (escenario == 0) {
    analizaEscenario0.cancion.play();
    analizaEscenario0.cancion.rewind();
    progressBar.setUp(analizaEscenario0.cancion.length());
  }
  if (escenario == 1) {
    analizaEscenario1.cancion.play();
    analizaEscenario1.cancion.rewind();
    progressBar.setUp(analizaEscenario1.cancion.length());
  }
  if (escenario == 2) {
    analizaEscenario2.cancion.play();
    analizaEscenario2.cancion.rewind();
    progressBar.setUp(analizaEscenario2.cancion.length());
  }
  if (escenario == 3) {
    analizaEscenario3.cancion.play();
    analizaEscenario3.cancion.rewind();
    progressBar.setUp(analizaEscenario3.cancion.length());
  }
  if (escenario == 4) {
    analizaEscenario4.cancion.play();
    analizaEscenario4.cancion.rewind();
    progressBar.setUp(analizaEscenario4.cancion.length());
  }
}

void keyPressed() {
  if (key == ' ') {
    dibujarField = !dibujarField;
  }

  // Activar los controladores con el teclado
  if (key == '8') {
    ctlMain.isPresent(true);
  }
  if (key == '1') {
    ctlAlly1.isPresent(true);
  }
  if (key == '2') {
    ctlAlly2.isPresent(true);
  }
  if (key == '3') {
    ctlAlly3.isPresent(true);
  }
  if (key == '5') {
    lightMode = !lightMode;
  }
  if (key == '6') {
    rewind();
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

  if (tobj.getSymbolID() == 5) {
    lightMode = !lightMode;
  }

  if (tobj.getSymbolID() == 6) {
    rewind();
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

  if (tobj.getSymbolID() == 5) {
    lightMode = !lightMode;
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
