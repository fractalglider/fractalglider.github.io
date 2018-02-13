void setup() {
  size(300, 300);  
}

// Current coordinates of the tick
float x = 150;
float y = 150;
// Coordinates the tick had during the previous frame
float prevx = 150;
float prevy = 150;

float tickHeight = 10;

void draw() {
  // Draw a semi-transparent background so that the trace fades with time
  pushStyle();
  noStroke();
  fill(0, 5);
  rect(0, 0, width, height);
  popStyle();
  
  // Draw the tick
  strokeWeight(2);
  line(prevx, prevy, x, y);
  
  // Move the rick to the right
  prevx = x;
  x = x + 1;
  if(x > width){
    x = 0;
    prevx = x;
  }
}

void mouseWheel(MouseEvent event) {
  float notchesScrolled = event.getCount();  
  
  // Paint the tick green if the last scroll was up, red otherwise
  if(notchesScrolled < 0){
    stroke(0, 255, 0);
  } else {
    stroke(255, 0, 0);
  }
  
  // Move the tick in the direction of scroll
  prevy = y;
  y = y + (notchesScrolled * tickHeight);
  if(y > height){
    y = 0;
    prevy = y;
  } else if (y < 0){
    y = height;
    prevy = y;
  }
}