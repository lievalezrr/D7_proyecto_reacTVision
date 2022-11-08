// Class for animating a sequence of GIFs
// modifed by david segura

class SpriteSheet {
  PImage[] images;
  int imageCount;
  int frame;
  boolean play;
  boolean loop;
  boolean forward;
  boolean playing;
  boolean finished;
  
  
  SpriteSheet(String imagePrefix, int count, String imageFormat) {
    imageCount = count;
    images = new PImage[imageCount];
    play = false;
    loop = false;
    forward = true;
    playing = false;
    finished = false;
    frame = 0;

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 5) + "."+imageFormat;
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    if (play) {
      if (loop) {
        if (forward) {
          frame++;
          if (frame >= imageCount)
            frame = 0;
        }
        else {
          frame--;
          if (frame < 0)
            frame = imageCount - 1;
        }
        playing = true;
      }
      else {
        if (forward) {
          if (frame < imageCount-1) {
            frame++;
            if (frame == imageCount-1) {
              play = false;
              playing = false;
              finished = true;
            }
          }
        }
        else {
          frame--;
          if (frame < 0) {
            frame = 0;
            play = false;
            playing = false;
            finished = true;
          }
        }
      }
    }
    image(images[frame], xpos, ypos);
  }
  
  void reverse() {
    forward = false;
    if (frame == 0)
      frame = imageCount-1;
  }
  
  void forward() {
    forward = true;
  }
  
  int getWidth() {
    return images[0].width;
  }
  
  void play() {
    play = true;
    playing = true;
    finished = false;
    if (forward) {
      if (frame >= imageCount-1 && loop == false) {
        frame = 0;
      }
    }
    else {
      if (frame <= 0 && loop == false) {
        frame = imageCount-1;
      }
    }
  }
  
  void pause() {
    play = false;
  }
  
  void loop() {
    loop = true;
  }
  
  void noLoop() {
    loop = false;
  }
  
  boolean isPlaying() {
    return playing;
  }
  
  boolean isFinished() {
    return finished;
  }
  
  float getWidthImage() {
    return images[0].width;
  }
  
  float getHeightImage() {
    return images[0].height;
  }
}
