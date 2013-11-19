import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

ArrayList nodes;
ArrayList lineOnenodes;
ArrayList lineOneTrains;
ArrayList lineTwonodes;
ArrayList lineTwoTrains;
ArrayList lineThreenodes;
ArrayList lineThreeTrains;
ArrayList lineFournodes;
ArrayList lineFourTrains;

//each line max train numbers
int maxTrainNums = 10;

int i, j, interval;
Node n, m;
Train t;
PVector station;

String [] melody= {
  "C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", 
  "A3", "A#3", "B3", "C4", "C#4", "D4", "D#4", "E4", "F4", 
  "F#4", "G4", "G#4", "A4", "A#4", "B4", "C5", "C#5", "D5", 
  "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5",
};

//add train to a line
void addTrains(ArrayList nodes, ArrayList trains, color c) {
  //limit 
  if (trains.size() >= maxTrainNums) {
    return;
  }
  Node startnode = (Node)nodes.get(0);
  Train train;
  train = new Train(new PVector(startnode.x, startnode.y), c);
  train.setLine(nodes);
  trains.add(train);
}

void setup() {
  size(800, 600);
  //frameRate(100);
  minim = new Minim(this);
  out = minim.getLineOut();
  background(100);
  j = 0;
  station = new PVector(width, height);
  interval = 60;

  //init all nodes list
  nodes = new ArrayList<Node>();
  lineOnenodes = new ArrayList<Node>();
  lineTwonodes = new ArrayList<Node>();
  lineThreenodes = new ArrayList<Node>();
  lineFournodes = new ArrayList<Node>();

  nodes.add(new Node(width /3, height, "Christopher Street 0"));
  nodes.add(new Node(width * 3 / 4, height * 7 / 8, "Christopher Street 1"));
  nodes.add(new Node(width * 2 / 3, height * 5 / 6, "Christopher Street 2"));
  nodes.add(new Node(width / 3, height * 4 / 5, "Christopher Street 3"));
  nodes.add(new Node(width / 2, height * 3 / 4, "Christopher Street 4"));
  nodes.add(new Node(width / 2, height / 2, "Christopher Street 5"));
  nodes.add(new Node(width / 2, height / 3, "Christopher Street 6"));
  nodes.add(new Node(width * 3/4, height / 3, "Christopher Street 7"));
  nodes.add(new Node(width / 6, height / 3, "Christopher Street 8"));
  nodes.add(new Node(width / 4, height / 4, "Christopher Street 9"));
  nodes.add(new Node(width / 8, height / 6, "Christopher Street 10"));
  nodes.add(new Node(width / 4, -height / 5, "Christopher Street 11"));
  nodes.add(new Node(width /2, -height / 8, "Christopher Street 12"));
  nodes.add(new Node(width *2/3, -height / 8, "Christopher Street 13"));

  nodes.add(new Node(width / 8, height, "Christopher Street 14"));
  nodes.add(new Node(width / 8, height *3/4, "Christopher Street 15"));
  nodes.add(new Node(width / 9, height / 2, "Christopher Street 16"));
  nodes.add(new Node(width /12, height /4, "Christopher Street 17"));
  nodes.add(new Node(width /8, 0, "Christopher Street 18"));

  //init each line's nodes
  //for (int i = 0; i < nodes.size(); i++) {
  // all have this node
  /*
    if (i == 4) {
   lineOnenodes.add(nodes.get(i));
   lineTwonodes.add(nodes.get(i));
   lineThreenodes.add(nodes.get(i));
   continue;
   }    
   */
  // if (i == 0 || i==3 || i==6 || i==11 || i==12) {
  lineOnenodes.add(nodes.get(0));
  lineOnenodes.add(nodes.get(1));
  lineOnenodes.add(nodes.get(4));
  lineOnenodes.add(nodes.get(5));
  lineOnenodes.add(nodes.get(6));
  lineOnenodes.add(nodes.get(9));
  lineOnenodes.add(nodes.get(12));

  //  } 
  //  if (i == 2 || i==3 || i==5 || i==8 || i==9 || i==11) {
  lineTwonodes.add(nodes.get(0));
  lineTwonodes.add(nodes.get(3));
  lineTwonodes.add(nodes.get(4));
  lineTwonodes.add(nodes.get(5));
  lineTwonodes.add(nodes.get(8));
  lineTwonodes.add(nodes.get(10));
  lineTwonodes.add(nodes.get(11));
  //lineTwonodes.add(nodes.get(4));
  //  }
  //  if (i == 0 || i==1 || i==3 || i==4 || i==6 || i==11){
  //    lineThreenodes.add(nodes.get(i));
  lineThreenodes.add(nodes.get(2));
  lineThreenodes.add(nodes.get(4));
  lineThreenodes.add(nodes.get(5));
  lineThreenodes.add(nodes.get(7));
  lineThreenodes.add(nodes.get(13));
  //lineThreenodes.add(nodes.get(11));
  //  }
  // }
  for (int i = 14; i < nodes.size(); i++) {
    lineFournodes.add(nodes.get(i));
  }

  //alloc and init train array list
  lineOneTrains = new ArrayList<Train>();
  lineTwoTrains = new ArrayList<Train>();
  lineThreeTrains = new ArrayList<Train>();
  lineFourTrains = new ArrayList<Train>();

  //add trains in to train list
  addTrains(lineOnenodes, lineOneTrains, color (255, 0, 255));
  addTrains(lineTwonodes, lineTwoTrains, color (0, 255, 255));
  addTrains(lineThreenodes, lineTwoTrains, color (10, 255, 10));
  addTrains(lineFournodes, lineTwoTrains, color (255, 10, 10));

  println("init ok!");
}

void drawLines(ArrayList nodes, color c) {
  Node n, m;
  for (int i = 0; i < nodes.size() - 1; i++) {
    n = (Node)nodes.get(i);
    m = (Node)nodes.get(i+1);
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
    if (train.arrived) {
      trains.remove(i);
    }
  }
}

void draw() {
  background(200);
  //every 480 frame add a train
  int lineOneInterval = 120;
  int lineTwoInterval = 120;
  int lineThreeInterval = 120;
  int lineFourInterval = 100;
  if (frameCount % lineOneInterval == 0) {
    addTrains(lineOnenodes, lineOneTrains, color(255, 0, 255));
  }
  if (frameCount % lineTwoInterval == 0) {
    addTrains(lineTwonodes, lineTwoTrains, color (0, 255, 255));
  }
  if (frameCount % lineThreeInterval == 0) {
    addTrains(lineThreenodes, lineThreeTrains, color (10, 255, 10));
  }
  if (frameCount % lineFourInterval == 0) {
    addTrains(lineFournodes, lineFourTrains, color (255, 10, 10));
  }
  drawLines(lineOnenodes, color(255, 100, 255, 100));
  drawLines(lineTwonodes, color(100, 255, 255, 100));
  drawLines(lineThreenodes, color(110, 255, 110, 100));
  drawLines(lineFournodes, color(255, 110, 110, 100));

  //move all the trains!
  moveTheTrains(lineOneTrains);
  moveTheTrains(lineTwoTrains);
  moveTheTrains(lineThreeTrains);
  moveTheTrains(lineFourTrains);
  //desplay nodes
  for (int i=0; i<nodes.size();i++) {
    n = (Node)nodes.get(i);
    n.display();
    n.blink();
    if (n.on && n.hit) {
      out.playNote(n.s);
    }
  }
  int frame=int(frameRate);
  text(Integer.toString(frame), 10, height-10);
}

void mousePressed() {
  for (int i=0; i<nodes.size();i++) {
    n = (Node)nodes.get(i);
    n.onOff();
  }
}

void mouseDragged() {
  for (int i=0; i<nodes.size();i++) {
    n = (Node)nodes.get(i);
    n.turn();
  }
}

