import javax.sound.midi.*;
PImage score;
int WHITE = color(255, 255, 255);
int RED = color(255, 0, 0);
int ORANGE = color(255, 165, 0);
int YELLOW = color(255, 255, 0);
int GREEN = color(0, 255, 0);
int BLUE = color(0, 0, 255);
int PURPLE = color(128, 0, 128);
int BLACK = color(0, 0, 0);
Synthesizer synthesizer;
MidiChannel[] midiChannel;
Instrument[] instruments;
ArrayList<Integer> staffLines;
int spaceBetweenStaves;
int spaceBetweenClefs;
int staffHeight;
boolean doubleClef;

void setup(){
  size(1200, 2500);
  //frameRate(1);
  score = loadImage("MarchWind.png");//////////////////////////////////////////////////////////////////////////////////////////////
  //score.resize(score.width*3/2,score.height*3/2);
  cleanse();
  highlightBetween();
  blackenStaffLines();
  bluifyNotes();
  blackenStaffLines();
 // println(""+score.width+" "+score.height);
  score.loadPixels();
  
  // Margaret's synthesizer
  try {
    synthesizer = MidiSystem.getSynthesizer();
    synthesizer.open();
    midiChannel = synthesizer.getChannels();
    instruments = synthesizer.getDefaultSoundbank().getInstruments();
    synthesizer.loadInstrument(instruments[0]);
  }
  catch (MidiUnavailableException e) {
    print(e);
  }
}
///////////////////////////////////////
void staffHeight(){
  int i=0;
  while (!approx(staffLines.get(i+1)-staffLines.get(i),spaceBetweenClefs) && !approx(staffLines.get(i+1)-staffLines.get(i),spaceBetweenStaves)){
    i++;
  }
  staffHeight=staffLines.get(i-1)-staffLines.get(0);
}

void cleanse(){/////////////////////////EXORCISE////////////////////////////////////////////
staffLines=new ArrayList<Integer>();
for (int r = 0; r < score.height; r ++) {
    int count = 0;
    for (int c = 0; c < score.width; c ++) {
      if (score.pixels[r * score.width + c] != WHITE) {
        count ++;
      }
    }
    if ((count*1.0)/score.width >= 0.55) {
      staffLines.add(r);
      for (int c = 0; c < score.width; c ++) {
        score.pixels[r * score.width + c] = BLACK;
      }
    }
  }
  for (int i=0; i<staffLines.size(); i++){
    println(staffLines.get(i));
  }
  spaceBetweenStaves=maximum(staffLines);
  secondMaximum(staffLines, spaceBetweenStaves);
  if (doubleClef){
    spaceBetweenClefs=secondMaximum(staffLines, spaceBetweenStaves);
    println("space between clefs: "+spaceBetweenClefs);
  }
  spaceBetweenClefs=secondMaximum(staffLines, spaceBetweenStaves);
  println("space between: "+spaceBetweenStaves);
  
  staffHeight();
  println("staff height: "+staffHeight);
}
//////////////////////////////////////////////////
int maximum(ArrayList<Integer> x){
  if (x.size()>1){
    int currentMax=x.get(1)-x.get(2);
    for (int i=2; i<x.size(); i++){
      if (x.get(i)-x.get(i-1)>currentMax){
        currentMax=x.get(i)-x.get(i-1);
        }
    }
     return currentMax;  
  }
  return -1;
}
////////////////////////////////////////////////////////
int secondMaximum(ArrayList<Integer> x, int y){
  if (x.size()>1){
    int currentMax=x.get(1)-x.get(2);
    for (int i=2; i<x.size(); i++){
      if (x.get(i)-x.get(i-1)>currentMax && x.get(i)-x.get(i-1)<y*0.66 && x.get(i)-x.get(i-1)>y*0.15){
        currentMax=x.get(i)-x.get(i-1);
        doubleClef=true;
      }
    }
    return currentMax;
  }
  return -1;
}
//////////////////////////////////////////////
void highlightBetween(){
  for (int i=0; i<staffLines.get(staffLines.size()-1)-staffLines.get(0); i++){
    int current=i+staffLines.get(0);
    /*if (staffLines.contains(current) && staffLines.indexOf(current)!=staffLines.size()-1){
      if (approx(staffLines.get(staffLines.indexOf(current)+1)-staffLines.get(staffLines.indexOf(current)),spaceBetweenClefs) || 
      (doubleClef && approx(staffLines.get(staffLines.indexOf(current)+1)-staffLines.get(staffLines.indexOf(current)),spaceBetweenStaves))){
        i+=staffLines.get(staffLines.indexOf(current)+1)-staffLines.get(staffLines.indexOf(current));
        println(true);
        highlightLine(current,GREEN);
        }
      }*/
     if (!staffLines.contains(i+staffLines.get(0))){
      highlightLine(current);
    }
  }
}
/////////////////////////////////////////////////
void blackenStaffLines() {
  for (int i = 0; i < score.pixels.length; i ++) {
    if (score.pixels[i] == BLUE) {
      try {
        if (score.pixels[i - score.width] != BLUE &&
            score.pixels[i + score.width] != BLUE) {
              score.pixels[i] = BLACK;
            }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  for (int i = 0; i < score.pixels.length; i ++) {
    if (score.pixels[i] == BLUE) {
      int count = 0;
      int col = i;
      while (score.pixels[col] == BLUE) {
        count ++;
        col ++;
      }
      if (count > 15) {
        for (int j = i; j <= col; j ++) {
          score.pixels[j] = BLACK;
        }
      }
    }
  }
}
/////////////////////////////////////////////////
void bluifyNotes() {
  for (int i = 0; i < score.pixels.length; i ++) {
    if (score.pixels[i] == BLACK) {
      try {
        if (score.pixels[i - score.width] == BLUE) {
              score.pixels[i] = BLUE;
        }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  for (int i = score.pixels.length - 1; i > -1; i --) {
    if (score.pixels[i] != WHITE &&
        score.pixels[i] != BLUE) {
      try {
        if (score.pixels[i + score.width] == BLUE) {
              score.pixels[i] = BLUE;
        }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  for (int i = 0; i < staffLines.get(0) * score.width; i ++) {
    if (score.pixels[i] == BLACK) {
      if (score.pixels[i + 1] == BLUE ||
          score.pixels[i - 1] == BLUE) {
            score.pixels[i] = BLUE;
          }
    }
  }
  for (int i = score.pixels.length - 1; i > -1; i --) {
    if (score.pixels[i] != WHITE &&
        score.pixels[i] != BLUE) {
      try {
        if (score.pixels[i + score.width] == BLUE) {
              score.pixels[i] = BLUE;
        }
      }
      catch (ArrayIndexOutOfBoundsException e) {
      }
    }
  }
  for (int i = 0; i < staffLines.get(0) * score.width; i ++) {
    if (score.pixels[i] == BLACK) {
      if (score.pixels[i + 1] == BLUE ||
          score.pixels[i - 1] == BLUE) {
            score.pixels[i] = BLUE;
          }
    }
  }
}
/////////////////////////////////////////////////
ArrayList<Note> readScore(){//completes the notes arraylist
  ArrayList<Note> notes = new ArrayList<Note>();
  for (int i = 0; i < score.pixels.length; i ++) {
     if (score.pixels[i] == BLUE) {
        int[] w = getWidth(i);
        int[] h = getHeight(i);
        int[] image = crop(w[0], w[1], h[0], h[1]);
        notes.add(getNote(image));
      }
  }
}

int getLeft(int loc){
  return getLeft(loc,0);  
}

int getRight(int loc){
  return getRight(loc,0);  
}

int getUp(int loc){
  return getUp(loc,0);  
}

int getDown(int loc){
  return getDown(loc,0);  
}

int getLeft(int loc, int left) {//wrapper's width is gonna be 0
  if (score.pixels[loc].color!=BLUE){
      return left;
  }
  score.pixels[loc].color=BLACK;
  int x=loc.getCol;
  int y=loc.getRow;
  int[] hor={0, 0, -1};
  int[] ver={1, -1, 0,};//horrible flashback to NQueens
  for (int i=0; i<hor.length; i++){
      int nextLoc=getAkhtual(x+hor[i], y+ver[i]);
      if (score.pixels[nextLoc].color==BLUE){
          if (i==2){
              return getLeft(nextLoc,left+1);
          }
          else{
              return getLeft(nextLoc,left);
          }
      }
  }
}

int getRight(int loc, int right) {//wrapper's width is gonna be 0
  if (score.pixels[loc].color!=BLUE){
      return right;
  }
  score.pixels[loc].color=BLACK;
  int x=loc.getCol;
  int y=loc.getRow;
  int[] hor={0, 0, 1};
  int[] ver={1, -1, 0,};//horrible flashback to NQueens
  for (int i=0; i<hor.length; i++){
      int nextLoc=getAkhtual(x+hor[i], y+ver[i]);
      if (score.pixels[nextLoc].color==BLUE){
          if (i==2){
              return getRight(nextLoc,right+1);
          }
          else{
              return getRight(nextLoc,right);
          }
      }
  }
}

int getUp(int loc, int up) {//wrapper's width is gonna be 0
  if (score.pixels[loc].color!=BLUE){
      return up;
  }
  score.pixels[loc].color=BLACK;
  int x=loc.getCol;
  int y=loc.getRow;
  int[] hor={0, -1, 1};
  int[] ver={1, 0, 0,};//horrible flashback to NQueens
  for (int i=0; i<hor.length; i++){
      int nextLoc=getAkhtual(x+hor[i], y+ver[i]);
      if (score.pixels[nextLoc].color==BLUE){
          if (i==0){
              return getUp(nextLoc,up+1);
          }
          else{
              return getUp(nextLoc,up);
          }
      }
  }
}

int getDown(int loc, int down) {//wrapper's width is gonna be 0
  if (score.pixels[loc].color!=BLUE){
      return down;
  }
  score.pixels[loc].color=BLACK;
  int x=loc.getCol;
  int y=loc.getRow;
  int[] hor={0, -1, 1};
  int[] ver={-1, 0, 0,};//horrible flashback to NQueens
  for (int i=0; i<hor.length; i++){
      int nextLoc=getAkhtual(x+hor[i], y+ver[i]);
      if (score.pixels[nextLoc].color==BLUE){
          if (i==0){
              return getDown(nextLoc,down+1);
          }
          else{
              return getDown(nextLoc,down);
          }
      }
  }
}


int getAkhtual(int x, int y){
    return y*score.width+x;
}

int[] crop(int x1, int x2, int y1, int y2) {
    int[] pixels = new int[(x2 - x1) * (y2 - y1)];
    int i = 0;
    for (int r = y1; r <= y2; r ++) {
        for (int c = x1; c <= x2; c ++) {
            pixels[i] = score.pixels[r * score.width + c];
            i ++;
        }
    }
    return pixels;
}
////////////////////////////////////
void highlightLine(int x){
  for (int i=0; i<score.width; i++){
    if (score.pixels[x*score.width+i]!=WHITE){
      score.pixels[x*score.width+i]=BLUE;
    }
  }
}

void draw() {
  background(0);
  image(score, 0, 0);
  //play();
}

void play() {
  midiChannel[0].noteOn(60, 100);
  midiChannel[0].noteOff(60, 100);
}