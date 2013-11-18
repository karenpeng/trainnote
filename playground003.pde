import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

ArrayList notes;
ArrayList lineOneNotes;
ArrayList lineOneTrains;
ArrayList lineTwoNotes;
ArrayList lineTwoTrains;

int maxTrainNums = 10;

int i, j, interval;
Note n, m;
Train t;
PVector station;

String [] melody= {
  "C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", 
  "A3", "A#3", "B3", "C4", "C#4", "D4", "D#4", "E4", "F4", 
  "F#4", "G4", "G#4", "A4", "A#4", "B4","C5", "C#5", "D5", 
  "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5",
};

void addTrains(ArrayList notes, ArrayList trains) {
  //limit 
  if (trains.size() >= maxTrainNums) {
    return;
  }
  Note startNote = (Note)notes.get(0);
  Train train;
  train = new Train(new PVector(startNote.x, startNote.y), color(255, random(0, 255), 255));
  train.setLine(notes);
  trains.add(train);
}

void setup() {
  size(800, 600);
  //frameRate(30);
  minim = new Minim(this);
  out = minim.getLineOut();
  background(100);
  j = 0;
  station = new PVector(width, height);
  interval = 60;

  //init all notes list
  notes = new ArrayList<Note>();
  lineOneNotes = new ArrayList<Note>();
  lineTwoNotes = new ArrayList<Note>();

  notes.add(new Note(width * 3 / 4, height * 7 / 8, "Christopher Street 0"));
  notes.add(new Note(width / 3, height * 4 / 5, "Christopher Street 1"));
  notes.add(new Note(width / 2, height * 3 / 4, "Christopher Street 2"));
  notes.add(new Note(width / 2, height / 2, "Christopher Street 3"));
  notes.add(new Note(width / 3, height / 4, "Christopher Street 4"));
  notes.add(new Note(width / 8, height / 4, "Christopher Street 5"));
  notes.add(new Note(width / 4, height / 6, "Christopher Street 6"));
  notes.add(new Note(width / 4, -height / 5, "Christopher Street 7"));
  
  //init each line's notes
  for (int i = 0; i < notes.size(); i++) {
    // all have this note
    if (i == 4) {
      lineOneNotes.add(notes.get(i));
      lineTwoNotes.add(notes.get(i));
      continue;
    }    
    if (i % 2 == 0) {
      lineOneNotes.add(notes.get(i));
    } else {
      lineTwoNotes.add(notes.get(i));
    }
  }

  //alloc and init train array list
  lineOneTrains = new ArrayList<Train>();
  lineTwoTrains = new ArrayList<Train>();

  //add trains in to train list
  addTrains(lineOneNotes, lineOneTrains);
  addTrains(lineTwoNotes, lineTwoTrains);
  
  println("init ok!");
}

void drawLines(ArrayList notes, color c) {
  Note n, m;
  for (int i = 0; i < notes.size() - 1; i++) {
    n = (Note)notes.get(i);
    m = (Note)notes.get(i+1);
    stroke(c);
    strokeWeight(18);
    line(n.x, n.y, m.x, m.y);
  }
}

void moveTheTrains(ArrayList trains) {
  Train train;
  for (int i = 0; i < trains.size(); i++) {
    train = (Train)trains.get(i);
    train.check();    
    train.seek();
    train.move();
    train.show();
    if (train.ended) {
      trains.remove(i);
    }
  }
}

void draw() {
  background(60);
  //every 480 frame add a train
  if (frameCount % 50 == 0) {
    addTrains(lineOneNotes, lineOneTrains);
    addTrains(lineTwoNotes, lineTwoTrains);
  }

  drawLines(lineOneNotes, color(255, 200, 255));
  drawLines(lineTwoNotes, color(255, 255, 200));

  //move all the trains!
  moveTheTrains(lineOneTrains);
  moveTheTrains(lineTwoTrains);

  //desplay notes
  for (int i=0; i<notes.size();i++) {
    n = (Note)notes.get(i);
    n.display();
    n.blink();
    if (n.on && n.hit) {
      out.playNote(n.s);
    }
  }
}

void mousePressed() {
  for (int i=0; i<notes.size();i++) {
    n = (Note)notes.get(i);
    n.onOff();
  }
}

void mouseDragged() {
  for (int i=0; i<notes.size();i++) {
    n = (Note)notes.get(i);
    n.turn();
  }
}

