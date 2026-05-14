import TUIO.*;
import themidibus.*;

TuioProcessing tuioClient;
MidiBus myBus;

void setup() {
  size(800, 600);
  // Inizializzazione MIDI (Trucco Object per Processing 4)
  myBus = new MidiBus(new java.lang.Object(), -1, "reacTIVision_Bus");
  tuioClient = new TuioProcessing(this);
  textFont(createFont("Arial", 16));
}

void draw() {
  background(15);
  
  // Recupera la lista dei marker attivi
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  
  for (TuioObject tobj : tuioObjectList) {
    int id = tobj.getSymbolID();
    
    // Filtriamo solo i marker da 0 a 10
    if (id >= 0 && id <= 10) {
      pushMatrix();
      // Trasliamo l'origine alle coordinate del marker
      translate(tobj.getScreenX(width), tobj.getScreenY(height));
      // Ruotiamo in base all'angolo del fiducial
      rotate(tobj.getAngle());
      
      // DISEGNO DELLA STELLA (Feedback visivo rotazione)
      drawStar(0, 0, 15, 40, 5); 
      
      popMatrix();
      
      // Testo informativo vicino al marker
      fill(255);
      text("KNOB ID: " + id, tobj.getScreenX(width) + 45, tobj.getScreenY(height));
    }
  }
}

// Funzione per disegnare una stella
void drawStar(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  stroke(0, 255, 150);
  strokeWeight(2);
  noFill();
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

// INVIO MIDI AUTOMATICO PER I MARKER 0-10
void updateTuioObject(TuioObject tobj) {
  if (myBus == null) return;
  
  int id = tobj.getSymbolID();
  
  if (id >= 0 && id <= 10) {
    // Mappa la rotazione 0-2PI in MIDI 0-127
    int val = int(map(tobj.getAngle(), 0, TWO_PI, 0, 127));
    
    // Invia al CC corrispondente all'ID (es. ID 6 -> CC 6)
    myBus.sendControllerChange(0, id, val);
  }
}

// Callback obbligatorie vuote
void addTuioObject(TuioObject tobj) {}
void removeTuioObject(TuioObject tobj) {}
void refresh(TuioTime bundleTime) {}
void addTuioCursor(TuioCursor tcur) {}
void updateTuioCursor(TuioCursor tcur) {}
void removeTuioCursor(TuioCursor tcur) {}
void addTuioBlob(TuioBlob tblb) {}
void updateTuioBlob(TuioBlob tblb) {}
void removeTuioBlob(TuioBlob tblb) {}
