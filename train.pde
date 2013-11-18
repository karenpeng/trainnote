
class Train {
  PVector pos, vel, acc;  
  float maxforce;
  float maxspeed;
  float d;  
  color c;
  ArrayList<PVector> history = new ArrayList<PVector>();

  int seekNoteIndex; //seek note's index
  ArrayList notes;   //line
  boolean arrived;
  boolean headArrived;

  Train(PVector _p, color _c) {
    pos=_p;
    vel=new PVector (0.0, 0.0);
    acc=new PVector (0, 0);
    maxspeed = 4;
    maxforce = 4;
    d=20;
    c=_c;
    seekNoteIndex = 0;
    arrived = false;
    headArrived = false;
  }

  void setLine(ArrayList _notes) {
    notes = _notes;
    seekNoteIndex = 0;
  }

  void move() {
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    history.add(pos.get());
    if (history.size() > 30) {
      history.remove(0);
    }
  }

  void appF(PVector f) {
    acc.add(f);
  }

  //seek to target
  void seek() {
    if (seekNoteIndex == 0) {
      return;
    }
    Note seekNote = (Note)notes.get(seekNoteIndex);
    PVector tar = new PVector(seekNote.x, seekNote.y);
    PVector desired = PVector.sub(tar, pos);
    float d = desired.mag();
    if (d < 40) {
      float m = map(d, 0, 40, .6, maxspeed);
      desired.setMag(m);
    } 
    else {
      desired.setMag(maxspeed);
    }
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce); 
    appF(steer);
  }

  //check arrive target station, if arrived, seek the next station
  void check() {
    Note seekNote = (Note)notes.get(seekNoteIndex);
    if (seekNoteIndex == notes.size() - 1) {
      if (!headArrived && seekNote.trigger(pos)) {
        headArrived = true;
      }
      PVector lastHis = (PVector)history.get(0);
      float distance = dist(seekNote.x, seekNote.y, lastHis.x, lastHis.y);
      if (distance < 1) {
        arrived = true;
      }
    }
    if (seekNoteIndex < notes.size() - 1 && seekNote.trigger(pos)) {
      seekNoteIndex++;
    }
  }

  void show() {
    noStroke();
    fill(c);
    ellipse(pos.x, pos.y, d, d);
    //fill(c, 100);
    for (PVector v: history) {
      ellipse(v.x, v.y, d, d);
    }
  }
};

