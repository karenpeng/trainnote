ArrayList notes;
Note n ;
ArrayList trains;
Train t;
int j, interval;
PVector station;
Note m;

void setup() {
  size(800, 600);
  frameRate(10);
  j=0;
  station = new PVector(width, height);
  interval=20;

  notes = new ArrayList<Note>();
  notes.add(new Note(width/2, height*3/4));
  notes.add(new Note(width/2, height/2));
  notes.add(new Note(width/2, height/4));
  //m = (Note)notes.get(0);


  trains = new ArrayList<Train>();
  for (int i=0;i<20;i++) {
    trains.add(new Train(width, height, color(255, 0, 255)));
  }
  t = (Train)trains.get(0);
}
void draw() {
  background(100);
  fill(100, 10);
  rect(0, 0, width, height);

  /*
  if (frameCount%interval==0) {
   if (j<notes.size()) {
   m = (Note)notes.get(j);
   j++;
   }
   }
   */

  //  for (int j=0; j<notes.size();j++) {
  // m = (Note)notes.get(j);
  //m = (Note)notes.get(j+1);
  if (j<notes.size()) {
    m = (Note)notes.get(j);

    if (m.trigger(t)) {
      //t.move(m.x, m.y);
      //n=m;

      j++;
    }
  }

  //trains.get(i).show();

  // }

  for (int i=0; i<trains.size()-1;i++) {

    t = (Train) trains.get(i);
    Train tAft = (Train) trains.get(i+1);
    //t.move(m.x, m.y);
    t.move(m.x, m.y);
    t.show();
    tAft.x=t.x;
    tAft.y=t.y;
  }




  for (int i=0; i<notes.size();i++) {
    n = (Note)notes.get(i);
    n.display();
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

  /*
  for(Note n: notes){
   n.turn();
   }
   */
}

