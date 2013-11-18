class Train {

  PVector pos, vel, acc, lastPos;  
  float maxforce;
  float maxspeed;
  float d;  
  color c;
  boolean slowdown;
  ArrayList<PVector> history = new ArrayList<PVector>();

  Train(PVector _p, color _c) {
    pos=_p;
    vel=new PVector (0.0, 0.0);
    acc=new PVector (0, 0);
    maxspeed = 4;
    maxforce = 4;
    d=20;
    c=_c;
    slowdown = false;
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

  void seek(PVector tar) {
    PVector desired = PVector.sub(tar, pos);
    float d = desired.mag();
    if (d < 40) {
      float m = map(d, 0, 40, .6, maxspeed);
      desired.setMag(m);
      slowdown = true;
    } 
    else {
      desired.setMag(maxspeed);
      slowdown = false;
    }
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce); 
    appF(steer);
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
}

