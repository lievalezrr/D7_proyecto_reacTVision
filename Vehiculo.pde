// Flow Field Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2011

class Vehiculo {

  // The usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float sideLen, maxForce, maxSpeed, maxRepel, repelRadius, borderRadius, maxSideLen, hue;

  Vehiculo(PVector l, float sl, float ms, float mf, float br, float rr, float mr, float msl) {
    location = l.get();
    sideLen = sl;
    maxSpeed = ms;
    maxForce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    borderRadius = br;
    repelRadius = rr;
    maxRepel = mr;
    maxSideLen = msl;
    hue = 230;
    colorMode(HSB);
  }

  public void run() {
    update();
    borders();
    //setHue(analizaVehiculo.getColor());
    display();
    
  }


  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  void follow(FlowField flow, PVector repelLocation) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    // Scale it up by maxspeed
    desired.mult(maxSpeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    // Limit to maximum steering force
    steer.limit(maxForce);
    // Determine if the vehicle is within range of the repel location
    float angle = atan2(location.y - repelLocation.y, location.x - repelLocation.x);
    float distance = repelLocation.dist(location);
    if (distance - sideLen < repelRadius) {
      // Apply repulsion
      float repulsion = map(distance, 0, repelRadius, maxRepel, 0);
      steer.add(new PVector(repulsion * cos(angle), repulsion * sin(angle)));
    }
    //Apply force
    acceleration.add(steer);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxSpeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    //hue = analizaEscenario1.getColor();
    // Dont draw if outside the radius
    if (dist(width/2, height/2, location.x, location.y) + sideLen >= radius) return;
    
    // Delimitar sideLen
    if (sideLen > maxSideLen) sideLen = maxSideLen;

    //Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(hue,200,100,250);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -sideLen*2);
    vertex(-sideLen, sideLen*2);
    vertex(sideLen, sideLen*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    float outerBorderX = (width/2 - radius);
    float outerBorderY = (height/2 - radius);
    if (location.x < -sideLen + outerBorderX) location.x = width+sideLen - outerBorderX;
    if (location.y < -sideLen + outerBorderY) location.y = height+sideLen - outerBorderY;
    if (location.x > width+sideLen - outerBorderX) location.x = -sideLen + outerBorderX;
    if (location.y > height+sideLen - outerBorderY) location.y = -sideLen + outerBorderY;
  }


void setHue(float _hue) {
  hue = _hue;
}
}
