class ProgressBar {

  float posX, posY, rectWidth, rectHeight;
  float startTime;
  int counter;
  float maxTime;
  boolean done;

  public ProgressBar(float _posX, float _posY, float _width, float _height) {
    posX = _posX;
    posY = _posY;
    rectWidth = _width;
    rectHeight = _height;
  }

  void setUp(float _maxTime) {
    counter = 0;
    startTime = millis();
    maxTime = _maxTime;
    done = false;
  }

  void paint(color clr) {
    if (counter-startTime < maxTime) {
      counter = millis();
    } else {
      done = true;
    }
    fill(clr);
    noStroke();
    rect(posX, posY, map(counter-startTime, 0, maxTime, 0, rectWidth), rectHeight);
    noFill();
    //stroke(0);
    //rect(posX, posY, rectWidth, rectHeight);    
  }
}
