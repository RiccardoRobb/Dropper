import processing.sound.*;

SoundFile soundtrack;
AudioIn mic;
boolean play=false;
FFT fft;
int bands = 1024;
int ck = (int)(bands/3);
PImage[] imgs = new PImage[3];
float[] spectrum = new float[bands];
int l = 30;
color bg = color(0);

ArrayList<PVector> pos = new ArrayList<PVector>();
ArrayList<PImage> drops = new ArrayList<PImage>();

void setup(){
  size(800,800);
  soundtrack = new SoundFile(this, "drum.mp3");
  
  imgs[0] = loadImage("drop0.png");
  imgs[1] = loadImage("drop1.png");
  imgs[2] = loadImage("drop2.png");
  
  mic = new AudioIn(this, 0);
  mic.start();
  
  fft = new FFT(this, bands);
  fft.input(mic);
  
  for(int i=0; i<(int)(bands/2); i++){
    pos.add( new PVector(random(l, width-l), random(l, height-l)) );
    drops.add( imgs[(int)random(3)] );
  }
}

void draw(){
  if(keyPressed){
    if(key == ' '){
      if(!play){
        soundtrack.play();
        
        fft.input(soundtrack);
        play = true;
        bg = color(30);
      }else{
        soundtrack.pause();
        
        fft.input(mic);
        play = false;
        bg = color(0);
      }
    }
  }
  
  background(bg);
  fft.analyze(spectrum); 
  for(int i=0; i<(int)(bands/2); i++){
    if(i<width){
      
      //stroke(255);
      //line(i, height, i, abs(height-spectrum[i]*height*5));
      move(pos.get(i), drops.get(i), (int)(spectrum[i] * 100000), i);
    }

  }
  
}

int random(int min, int max){
  int i = (int)random(max);
  while(i < min) i = (int)random(max);
  
  return i;
}

void move(PVector pos, PImage img, int frq, int index){
    
    if(frq > (ck - (index%ck))){
      if(random(1) >= 0.5){
        pos.x += 1.7;
        if(random(1) >= 0.5) pos.y += 1.7;
        else pos.y -= 1.7;
      }else{
         pos.x -= 1.7;
        if(random(1) >= 0.5) pos.y += 1.7;
        else pos.y -= 1.7;
      }
    }
    
    if(pos.x < l) pos.x += 1.7;
    if(pos.x > width-l) pos.x -= 1.7;
    if(pos.y < l) pos.y += 1.7;
    if(pos.y > height-l) pos.y -= 1.7;
    
    imageMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    
    if(frq > ck){
      if(random(1) >= 0.5) rotate(radians(5));
      else rotate(radians(-5));
    }

    image(img, 0, 0, l, l);
    popMatrix();
}
