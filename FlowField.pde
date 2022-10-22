// Flow Field Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code, Spring 2011

class FlowField {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field
  float zoff = 0;

  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows based on given width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    resetNoise();
  }

  void resetNoise() {
    // Reseed noise so we get a new flow field every time
    noiseSeed((int)random(10000));
  }

  // Draw every vector
  void run(boolean display) {    
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        float theta = map(noise(xoff,yoff,zoff),0,1,0,TWO_PI);
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        field[i][j] = new PVector(cos(theta),sin(theta));
        if (display) drawVector(field[i][j],i*resolution,j*resolution,resolution-2);
        yoff += 0.1;
      }
      xoff += 0.1;
    }
    zoff += 0.01;
  }

  // Renders a vector object 'v' as an arrow and a location 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    // Translate to location to render vector
    translate(x,y);
    stroke(0,100);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0,0,len,0);
    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution,0,cols-1));
    int row = int(constrain(lookup.y/resolution,0,rows-1));
    return field[column][row].get();
  }


}
