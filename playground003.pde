import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

ArrayList notes;
Note n ;
ArrayList trains;
Train t;
int j, interval;
PVector station;
Note m;
int i;
String [] melody= {
  "C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3", "C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4","C5", "C#5", "D5", "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5",
};

void setup() {
  size(800, 600);
  //frameRate(30);
  minim = new Minim(this);
  out = minim.getLineOut();
  background(100);
  j=0;
  station = new PVector(width, height);
  interval=60;

  notes = new ArrayList<Note>();
  /*
  for (int k=0;k<10;k++) {
   int xx = int(random(width/8, width*7/8));
   int yy = int(random(height/8, height*7/8));
   notes.add(new Note(xx, yy, "Christopher Street"));
   }*/
  notes.add(new Note(width*3/4, height*7/8, "Christopher Street"));
  notes.add(new Note(width/3, height*4/5, "Christopher Street"));
  notes.add(new Note(width/2, height*3/4, "Christopher Street"));
  notes.add(new Note(width/2, height/2, "Christopher Street"));
  notes.add(new Note(width/2, height/4, "Christopher Street"));
  notes.add(new Note(width/8, height/4, "Christopher Street"));
  notes.add(new Note(width/4, height/6, "Christopher Street"));
  notes.add(new Note(width/4, -height/5, "Christopher Street"));
  //notes.add(new Note(width/2, -100, "Christopher Street"));
  m = (Note)notes.get(0);

  trains = new ArrayList<Train>();
  trains.add(new Train(new PVector(width - 100, height - 100), color(255, i * 10, 255)));
  t= (Train) trains.get(0);
}

void draw() {
  background(60);
  if (frameCount%480==0) {
    trains.add(new Train(new PVector(width - 100, height - 100), color(255, i * 10, 255)));
  }

  for (int i=0; i<notes.size()-1;i++) {
    n = (Note)notes.get(i);
    m=(Note)notes.get(i+1);
    stroke(255, 100);
    strokeWeight(18);
    line(n.x, n.y, m.x, m.y);
  }

  if (trains.size()>0) {
    t= (Train) trains.get(0);
    if (j<notes.size()) {
      m = (Note)notes.get(j);
      if (m.trigger(t)) {
        j++;
      }
    }
    station = new PVector(m.x, m.y);
    t.seek(station);

    for (int i=0; i<trains.size();i++) {
      Train t = (Train) trains.get(i);
      t.show();
      t.move();
      //should set the -200 according to the history ArrayList, fix this later
      //if (t.history.get(history.size()-1).y<0) {
      if (t.pos.y<-100) {
        trains.remove(i);
        j=0;
      }
    }
  }

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

