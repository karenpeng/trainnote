
class Train {
  PVector pos, vel, acc;  
  float maxforce;
  float maxspeed;
  float d;  
  color c;
  ArrayList<PVector> history = new ArrayList<PVector>();

  int seekNodeIndex; //seek node's index
  ArrayList nodes;   //line
  boolean arrived;
  boolean headArrived;

  Train(PVector _p, color _c) {
    pos=_p;
    vel=new PVector (0.0, 0.0);
    acc=new PVector (0, 0);
    maxspeed = 6;
    maxforce = 4;
    d=20;
    c=_c;
    seekNodeIndex = 0;
    arrived = false;
    headArrived = false;
  }

  void setLine(ArrayList _nodes) {
    nodes = _nodes;
    seekNodeIndex = 0;
  }

  void move() {
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    history.add(pos.get());
    if (history.size() > 20) {
      history.remove(0);
    }
  }

  void appF(PVector f) {
    acc.add(f);
  }

  //seek to target
  void seek() {
    if (seekNodeIndex == 0) {
      return;
    }
    Node seekNode = (Node)nodes.get(seekNodeIndex);
    PVector tar = new PVector(seekNode.x, seekNode.y);
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
    Node seekNode = (Node)nodes.get(seekNodeIndex);
    if (seekNodeIndex == nodes.size() - 1) {
      if (!headArrived && seekNode.trigger(pos)) {
        headArrived = true;
      }
      PVector lastHis = (PVector)history.get(0);
      float distance = dist(seekNode.x, seekNode.y, lastHis.x, lastHis.y);
      if (distance < 1) {
        arrived = true;
      }
    }
    if (seekNodeIndex < nodes.size() - 1 && seekNode.trigger(pos)) {
      seekNodeIndex++;
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

