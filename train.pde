
class Train {
  PVector pos, vel, acc;  
  float maxforce;
  float maxspeed;
  float d;  
  color c;
  ArrayList<PVector> history = new ArrayList<PVector>();
  int seekNoteIndex;
  ArrayList notes;
  boolean ended;
  
  Train(PVector _p, color _c) {
    pos=_p;
    vel=new PVector (0.0, 0.0);
    acc=new PVector (0, 0);
    maxspeed = 4;
    maxforce = 4;
    d=20;
    c=_c;
    seekNoteIndex = 0;
    ended = false;
  }

  void setLine(ArrayList _notes) {
    notes = _notes;
    if (notes.size() > 1) {
      seekNoteIndex = 1;
    }
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

  void check() {
    Note seekNote = (Note)notes.get(seekNoteIndex);
    if (seekNoteIndex == notes.size() - 1) {
      PVector lastHis = (PVector)history.get(history.size() - 1);
      float distance = dist(pos.x, pos.y, lastHis.x, lastHis.y);
      if (distance < 1) {
        ended = true;
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

