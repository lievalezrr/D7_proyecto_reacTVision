class Texto {

  public Texto() {
  }

  void say(String mensaje) {
    textSize(width/64);
    textAlign(CENTER, BOTTOM);
    if (lightMode) fill(colorNegro);
    else fill(colorBlanco);
    text("\"" + mensaje + "\"", width/2, height/5);
  }
}
