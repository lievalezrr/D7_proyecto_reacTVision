// Flow Field Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2011

class Vehicle {

  // The usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float radius;

  Vehicle(PVector l, float ms, float mf, float _radius) {
    location = l.get();
    r = 3.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    radius = _radius;
  }

  public void run() {
    update();
    borders();
    display();
  }


  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void display() {
    // Dont draw if outside the radius
    if (dist(width/2, height/2, location.x, location.y) + r >= radius) return;
    
    //Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(#FAF9F7);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    float outerBorderX = (width/2 - radius);
    float outerBorderY = (height/2 - radius);
    if (location.x < -r + outerBorderX) location.x = width+r - outerBorderX;
    if (location.y < -r + outerBorderY) location.y = height+r - outerBorderY;
    if (location.x > width+r - outerBorderX) location.x = -r + outerBorderX;
    if (location.y > height+r - outerBorderY) location.y = -r + outerBorderY;
  }
}
