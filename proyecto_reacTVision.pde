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

// Numero de los controles fiducial
int idFidMain = 6;
int idFidAlly1 = 1;
int idFidAlly2 = 2;
int idFidAlly3 = 3;
int idFidLightMode = 14;
int idFidRewind = 10;

ParticleSystem mundoVirtual;

Minim minim;
AudioPlayer cancion;

FFT fftLog;
FFT fftLin;

AudioMetaData metaDatos;
AudioSample sfxCambioPersonaje, sfxAliado, sfxFinalExplosion, sfxHotSpot, sfxLlave, sfxSalida, salida1, sfxExplode;

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
PImage mainPicVerde, mainPicAzul, mainPicRojo;
PImage spotPic;
PImage hotspotImg;
PImage salidaImg;
PImage villano;

PShape blob1, blob2;

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

float radius, radioDestello;

float sideLen;
float hFondo;

Salida salida, salidaT, bolaT;

Fondo fondo;
Texto texto;

ProgressBar progressBar;

int offset = 0;

void setup() {
  fullScreen();
  colorMode(HSB, 360, 100, 100);
  smooth();

  font = createFont("PPNeueMachina-InktrapLight.otf", width/50);
  textFont(font);

  radius = width/3;
  radioDestello = 1;

  mundoVirtual = new ParticleSystem(0, 0.1);
  minim = new Minim(this);
  tuioClient = new TuioProcessing(this);

  mainPicVerde = loadImage("aura_verde.png");
  mainPicVerde.resize(width/16, width/16);
  mainPicAzul = loadImage("aura_azul.png");
  mainPicAzul.resize(width/16, width/16);
  mainPicRojo = loadImage("aura_rojo.png");
  mainPicRojo.resize(width/16, width/16);

  llavePic = loadImage("llave.png");
  llavePic.resize(width/16, width/16);

  aliadoPic1 = loadImage("aliado dormido.png");
  aliadoPic1.resize(width/20, width/20);
  aliadoPic2 = loadImage("aliado despierto.png");
  aliadoPic2.resize(width/20, width/20);
  aliadoPic3 = loadImage("here.png");

  blob1 = loadShape("blob1.svg");
  blob2 = loadShape("blob2.svg");

  hotspotImg = loadImage("hotSpot.png");
  hotspotImg.resize(width/20, width/20);

  salidaImg = loadImage("hueco.png");
  salidaImg.resize(width/16, width/16);

  villano = loadImage("villano.png");
  villano.resize(width/16, width/16);

  llave = new Atrapable(llavePic, llavePic, width/2, height/3, mundoVirtual);

  salida = new Salida(mundoVirtual, width/2, height*2/3, salidaImg);

  analizaEscenario0 = new AnalizadorMusica(minim.loadFile("Esc_0_Eye.mp3", 1024));
  analizaEscenario1 = new AnalizadorMusica(minim.loadFile("Song_Esc1-Alien_1.mp3", 1024));
  analizaEscenario2 = new AnalizadorMusica(minim.loadFile("Song_Esc2-In the fire.mp3", 1024));
  analizaEscenario3 = new AnalizadorMusica(minim.loadFile("Esc_3_Eye.mp3", 1024));
  analizaEscenario4 = new AnalizadorMusica(minim.loadFile("Song_Esc4-Dark.mp3", 1024));
  analizaEscenario5 = new AnalizadorMusica(minim.loadFile("Esc_3_Eye.mp3", 1024));

  ctlMain = new Control(width/2, height/2, 0, 360, colorBlanco, colorNegro, mundoVirtual, mainPicVerde, mainPicAzul, mainPicRojo);

  ctlAlly1 = new Control(width-80, (height/2)+160, 0, 360, colorRojo, colorRojo, mundoVirtual, mainPicVerde, mainPicAzul, mainPicRojo);
  ctlAlly2 = new Control(width-80, (height/2)+240, 0, 360, colorVerde, colorVerde, mundoVirtual, mainPicVerde, mainPicAzul, mainPicRojo);
  ctlAlly3 = new Control(width-80, (height/2)+320, 0, 360, colorAzul, colorAzul, mundoVirtual, mainPicVerde, mainPicAzul, mainPicRojo);

  controles[0] = ctlMain;
  controles[1] = ctlAlly1;
  controles[2] = ctlAlly2;
  controles[3] = ctlAlly3;

  hMain = new Hotspot(width/18*12, height/18*12, colorBlanco, colorNegro, width/32, hotspotImg);
  hAlly1 = new Hotspot(width/18*6, height/18*6, colorRojo, colorRojo, width/32, hotspotImg);
  hAlly2 = new Hotspot(width/18*12, height/18*6, colorVerde, colorVerde, width/32, hotspotImg);
  hAlly3 = new Hotspot(width/18*6, height/18*12, colorAzul, colorAzul, width/32, hotspotImg);

  ally1 = new Atrapable(aliadoPic1, aliadoPic2, width*2/6 + width/30, height/2, mundoVirtual);
  ally2 = new Atrapable(aliadoPic1, aliadoPic2, width*3/6, height/2 + width/8, mundoVirtual);
  ally3 = new Atrapable(aliadoPic1, aliadoPic2, width*4/6 - width/30, height/2, mundoVirtual);

  tela1 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*2, 1);
  tela1p2 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*2, 1.2);

  tela2 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*2, 2);
  tela2p2 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*2, 2.2);

  tela3 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*14, 3);
  tela3p2 = new Tela (mundoVirtual, 30, width*1/6, (height/16)*14, 3.2);

  tela4 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*14, 4);
  tela4p2 = new Tela (mundoVirtual, 30, width*5/6, (height/16)*14, 4.2);

  telaAlly1 = new TelaAuras(mundoVirtual, 20, ally1.getX(), ally1.getY(), 1);
  telaAlly2 = new TelaAuras(mundoVirtual, 20, ally2.getX(), ally2.getY(), 2);
  telaAlly3 = new TelaAuras(mundoVirtual, 20, ally3.getX(), ally3.getY(), 3);

  fondo = new Fondo (radius, 86, 100, 50);

  texto = new Texto();

  flowfield = new FlowField(20);
  vehicles = new ArrayList<Vehiculo>();

  sfxCambioPersonaje= minim.loadSample("sfxCambioPersonaje.mp3");
  sfxAliado= minim.loadSample("sfxAliado.mp3");
  sfxFinalExplosion= minim.loadSample("sfxFinalExplosion.mp3");
  sfxHotSpot= minim.loadSample("sfxHotSpot.mp3");
  sfxLlave=minim.loadSample("sfxLlave.mp3");
  sfxSalida= minim.loadSample("sfxSalida.mp3");
  sfxExplode= minim.loadSample("explode4.mp3");

  for (int i = 0; i < vehicleAmount; i++) {
    float r = radius * sqrt(random(1));
    float theta = random(1) * 2 * PI;
    float x = (width/2) + r * cos(theta);
    float y = (height/2) + r * sin(theta);
    vehicles.add(new Vehiculo(new PVector(x, y), 3.0, random(2, 5), random(0.1, 0.5), radius, 100.0, 4.0, 20));
  }

  progressBar = new ProgressBar(width/16, height/12, width - width*2/16, height/64);

  escenario = 0;
  analizaEscenario0.cancion.play();

  progressBar.setUp(analizaEscenario0.cancion.length());
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

    if (tobj.getSymbolID() == idFidMain) {
      ctlMain.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }

    if (tobj.getSymbolID() == idFidAlly1) {
      ctlAlly1.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }

    if (tobj.getSymbolID() == idFidAlly2) {
      ctlAlly2.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
    }

    if (tobj.getSymbolID() == idFidAlly3) {
      ctlAlly3.actualizar(tobj.getScreenX(width), tobj.getScreenY(height), tobj.getAngle());
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

    ctlMain.dibujar(ctlMain.angulo);
    ctlMain.mover();

    if (analizaEscenario1.cancion.position() > 4700 && analizaEscenario1.cancion.position() < 10000) {
      texto.say("there's something wrong inside me");
    }

    if (analizaEscenario1.cancion.position() > 15000 && analizaEscenario1.cancion.position() < 20000) {
      texto.say("i need your help, \n this darkness is consuming me");
    }

    if (analizaEscenario1.cancion.position() > 25000 && analizaEscenario1.cancion.position() < 35000) {
      texto.say("turn around, \n you'll see my world in colors");
    }

    if (analizaEscenario1.cancion.position() > 43000 && llave.meAtraparon == false) {
      llave.dibujar();
      texto.say("if you're willing to help me, \n take my light with you");

      // Atrapar la llave
      if (llave.getPos().dist(ctlMain.getPos()) < width/30) {
        llave.atrapar(ctlMain.particle);
        sfxLlave.trigger();
      }
    }

    // Dibujar salida
    if (llave.meAtraparon == true) {
      llave.dibujar();
      salida.dibujar();

      texto.say("save me, brave soul");
    }

    // Llegar a la salida
    if (llave.meAtraparon == true && ctlMain.getPos().dist(salida.getPos()) < width/30) {
      escenario = 2;
      llave.soltar();
      analizaEscenario1.cancion.pause();
      analizaEscenario2.cancion.play();
      sfxSalida.trigger();
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

    ctlMain.dibujar(ctlMain.angulo);
    ctlMain.mover();
    analizaEscenario2.analizeFreq();
    analizaEscenario2.analizeSize();
    //text(analizaEscenario2.getFreq(), width/2, height/8*7);
    telaAlly1.dibujar(1, analizaEscenario2.getFreq(), analizaEscenario2.getGolpe(), ally1.getPos(), analizaEscenario2.getSize(), ctlMain.hueTheme);
    telaAlly2.dibujar(1, analizaEscenario2.getFreq(), analizaEscenario2.getGolpe(), ally2.getPos(), analizaEscenario2.getSize(), ctlMain.hueTheme);
    telaAlly3.dibujar(1, analizaEscenario2.getFreq(), analizaEscenario2.getGolpe(), ally3.getPos(), analizaEscenario2.getSize(), ctlMain.hueTheme);
    fill(#FFFFFF);
    // text(analizaEscenario2.getFreq(),width/2, width/8*7);
    //analizaEscenario2.dibujarAuras(ally1.getPos(), ally2.getPos(), ally3.getPos(), blob1, blob2, ctlMain.hueTheme, lightMode);
    ally1.dibujar();
    ally2.dibujar();
    ally3.dibujar();

    if (analizaEscenario2.cancion.position() > 4700 && ally1.meAtraparon == false && ally2.meAtraparon == false && ally3.meAtraparon == false) {
      texto.say("there are others who can help, find them \n 3 to go");
      analizaEscenario2.dibujarAuras(ally1.getPos(), ally2.getPos(), ally3.getPos(), blob1, blob2, ctlMain.hueTheme, lightMode, 1);
      if (ally1.getPos().dist(ctlMain.getPos()) < width/30) {
        ally1.atrapar(ctlMain.particle);
        sfxAliado.trigger();
      }
    }

    if (analizaEscenario2.cancion.position() > 5000 && ally1.meAtraparon == true && ally2.meAtraparon == false && ally3.meAtraparon == false) {
      texto.say("there are others who can help, find them \n 2 to go");
      analizaEscenario2.dibujarAuras(ally1.getPos(), ally2.getPos(), ally3.getPos(), blob1, blob2, ctlMain.hueTheme, lightMode, 2);
      if (ally2.getPos().dist(ctlMain.getPos()) < width/30) {
        ally2.atrapar(ally1.particle);
        sfxAliado.trigger();
      }
    }

    if (analizaEscenario2.cancion.position() > 5000 && ally1.meAtraparon == true && ally2.meAtraparon == true && ally3.meAtraparon == false) {
      texto.say("there are others who can help, find them \n 1 to go");
      analizaEscenario2.dibujarAuras(ally1.getPos(), ally2.getPos(), ally3.getPos(), blob1, blob2, ctlMain.hueTheme, lightMode, 3);
      if (ally3.getPos().dist(ctlMain.getPos()) < width/30) {
        ally3.atrapar(ally2.particle);
        sfxAliado.trigger();
      }
    }

    if (analizaEscenario2.cancion.position() > 5000 && ally1.meAtraparon == true && ally2.meAtraparon == true && ally3.meAtraparon == true) {
      texto.say("we're in this together \n are you ready for what's on the other side?");
      analizaEscenario2.dibujarAuras(ally1.getPos(), ally2.getPos(), ally3.getPos(), blob1, blob2, ctlMain.hueTheme, lightMode, 4);
      salida.dibujar();
    }

    // Llegar a la salida
    if (ally3.meAtraparon == true && ctlMain.getPos().dist(salida.getPos()) < width/30) {
      escenario = 3;
      llave.soltar();
      analizaEscenario2.cancion.pause();
      sfxSalida.trigger();
      analizaEscenario3.cancion.play();

      progressBar.setUp(analizaEscenario3.cancion.length());
    }
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

    //villano.hsb(0, 0, analizaEscenario4.analizeFondo(0, 100));
    //villano.drawFondo();

    hMain.dibujar();
    hAlly1.dibujar();
    hAlly2.dibujar();
    hAlly3.dibujar();

    imageMode(CENTER);
    image(villano, width/2, height/2);
    imageMode(CORNER);

    analizaEscenario4.analizeColor();
    analizaEscenario4.analizeSize();
    analizaEscenario4.analizeFreq();
    //text(analizaEscenario3.getSize(), width/3, height/3);
    //fill(#FFFFFF);
    //text(analizaEscenario3.getFreq(), width/2, height/7*6);

    int alliesFaltantes = 4;

    if (hAlly1.meToco(ctlAlly1.pos.x, ctlAlly1.pos.y) || hAlly1.meToco(ctlAlly2.pos.x, ctlAlly2.pos.y) || hAlly1.meToco(ctlAlly3.pos.x, ctlAlly3.pos.y) || hAlly1.meToco(ctlMain.pos.x, ctlMain.pos.y)) {
      //sfxHotSpot.trigger();
      tela1.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), ctlMain.hueTheme);
      tela1p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), 1 );
      alliesFaltantes--;
      if (hAlly1.primerContacto == true) {
        sfxHotSpot.trigger();
        hAlly1.primerContacto = false;
      }
    } else {
      hAlly1.primerContacto = true;
    }

    if (hAlly2.meToco(ctlAlly1.pos.x, ctlAlly1.pos.y) || hAlly2.meToco(ctlAlly2.pos.x, ctlAlly2.pos.y) || hAlly2.meToco(ctlAlly3.pos.x, ctlAlly3.pos.y) || hAlly2.meToco(ctlMain.pos.x, ctlMain.pos.y)) {
      tela2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), ctlMain.hueTheme);
      tela2p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), 1 );
      alliesFaltantes--;
      if (hAlly2.primerContacto == true) {
        sfxHotSpot.trigger();
        hAlly2.primerContacto = false;
      }
    } else {
      hAlly2.primerContacto = true;
    }

    if (hAlly3.meToco(ctlAlly1.pos.x, ctlAlly1.pos.y) || hAlly3.meToco(ctlAlly2.pos.x, ctlAlly2.pos.y) || hAlly3.meToco(ctlAlly3.pos.x, ctlAlly3.pos.y) || hAlly3.meToco(ctlMain.pos.x, ctlMain.pos.y)) {
      tela3.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), ctlMain.hueTheme);
      tela3p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), 1);
      alliesFaltantes--;
      if (hAlly3.primerContacto == true) {
        sfxHotSpot.trigger();
        hAlly3.primerContacto = false;
      }
    } else {
      hAlly3.primerContacto = true;
    }

    if (hMain.meToco(ctlAlly1.pos.x, ctlAlly1.pos.y) || hMain.meToco(ctlAlly2.pos.x, ctlAlly2.pos.y) || hMain.meToco(ctlAlly3.pos.x, ctlAlly3.pos.y) ||hMain.meToco(ctlMain.pos.x, ctlMain.pos.y)) {
      tela4.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), ctlMain.hueTheme);
      tela4p2.dibujar(analizaEscenario4.getSize(), analizaEscenario4.getColor(), analizaEscenario4.getFreq(), 1, analizaEscenario4.getGolpe(), 1);
      alliesFaltantes--;
      if (hMain.primerContacto == true) {
        sfxHotSpot.trigger();
        hMain.primerContacto = false;
      }
    } else {
      hMain.primerContacto = true;
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
      texto.say("free me from this darkness, place yourselves in position, \n still missing " + alliesFaltantes);
    } else {
      if (analizaEscenario4.cancion.position() < 30000) {
        texto.say("yes, it's working!");
      }
      if (analizaEscenario4.cancion.position() > 30000 && analizaEscenario4.cancion.position() < 45000) {
        texto.say("we're halfway there!");
      }
      if (analizaEscenario4.cancion.position() > 45000) {
        texto.say("i can almost see the light!");
      }
    }

    ctlMain.dibujar(ctlMain.angulo);
    ctlMain.mover();

    ctlAlly1.dibujar(ctlMain.angulo);
    ctlAlly1.mover();

    ctlAlly2.dibujar(ctlMain.angulo);
    ctlAlly2.mover();

    ctlAlly3.dibujar(ctlMain.angulo);
    ctlAlly3.mover();

    if (!analizaEscenario4.cancion.isPlaying() && alliesFaltantes == 0) {
      escenario = 5;
      analizaEscenario5.cancion.play();
      analizaEscenario5.cancion.loop();
      //progressBar.setUp(analizaEscenario5.cancion.length());
    }
  }

  if (escenario == 5) {
    
    if (radioDestello < width + width/4) {
       if (radioDestello == 1){
      sfxExplode.trigger();
       }
      fill(colorBlanco, 80);
      circle(width/2, height/2, radioDestello);
      radioDestello += 100;
    
     
    } else {
      if (lightMode) fondo.hsb(241, analizaEscenario5.analizeFondo(0, 100), 100);
      else fondo.hsb(0, 0, analizaEscenario5.analizeFondo(0, 80));
      fondo.drawFondo();
      texto.say("I'd forgotten how it felt to be free, \n thank you");
      //progressBar.paint(color(0, 0, 100));
    }
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
  if (tobj.getSymbolID() == idFidMain) {
    ctlMain.isPresent(true);
  }

  if (tobj.getSymbolID() == idFidAlly1) {
    ctlAlly1.isPresent(true);
  }

  if (tobj.getSymbolID() == idFidAlly2) {
    ctlAlly2.isPresent(true);
  }

  if (tobj.getSymbolID() == idFidAlly3) {
    ctlAlly3.isPresent(true);
  }

  if (tobj.getSymbolID() == idFidLightMode) {
    lightMode = !lightMode;
  }

  if (tobj.getSymbolID() == idFidRewind) {
    rewind();
  }
}

void updateTuioObject (TuioObject tobj) {
}

void removeTuioObject(TuioObject tobj) {
  if (tobj.getSymbolID() == idFidMain) {
    ctlMain.isPresent(false);
  }

  if (tobj.getSymbolID() == idFidAlly1) {
    ctlAlly1.isPresent(false);
  }

  if (tobj.getSymbolID() == idFidAlly2) {
    ctlAlly2.isPresent(false);
  }

  if (tobj.getSymbolID() == idFidAlly3) {
    ctlAlly3.isPresent(false);
  }

  //if (tobj.getSymbolID() == 5) {
  //  lightMode = !lightMode;
  //}
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
