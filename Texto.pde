class Texto {

  public Texto() {
  }

  void say(String mensaje) {
    textSize(width/64);
    textAlign(CENTER);
    fill(#FFFFFF);
    text(mensaje, width/2, height/2);
  }
}
