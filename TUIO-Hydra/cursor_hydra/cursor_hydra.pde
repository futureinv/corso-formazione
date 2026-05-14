import TUIO.*;
import themidibus.*;

TuioProcessing tuioClient;
MidiBus myBus;

void setup() {
  size(800, 600);
  // Connessione MIDI (Trucco Object per Windows)
  myBus = new MidiBus(new java.lang.Object(), -1, "reacTIVision_Bus");
  tuioClient = new TuioProcessing(this);
}

void draw() {
  background(15);
  
  // Recupera la lista dei cursori attivi
  ArrayList<TuioCursor> cursorList = tuioClient.getTuioCursorList();
  
  for (TuioCursor tcur : cursorList) {
    int id = tcur.getCursorID(); // L'ID del cursore (0, 1, 2...)
    
    float x = tcur.getScreenX(width);
    float y = tcur.getScreenY(height);
    
    // FEEDBACK VISIVO: Disegniamo un puntatore a "mirino" per i cursori
    stroke(255, 0, 100);
    line(x - 20, y, x + 20, y);
    line(x, y - 20, x, y + 20);
    noFill();
    ellipse(x, y, 30, 30);
    
    fill(255);
    text("CURSOR ID: " + id, x + 25, y - 10);
    // Invertiamo Y (1-0) perché in grafica 0 è in alto, ma nel MIDI vogliamo 127 in alto
    int midiVal = int(map(tcur.getY(), 1, 0, 0, 127)); 
    text("CC " + id + " VAL: " + midiVal, x + 25, y + 10);
  }
}

// INVIO MIDI SULLA POSIZIONE Y DEI CURSORI
void updateTuioCursor(TuioCursor tcur) {
  if (myBus == null) return;
  
  int id = tcur.getCursorID();
  
  // Mappiamo Y (che va da 0.0 a 1.0) al valore MIDI (0-127)
  // Invertiamo la mappa: 1.0 (fondo schermo) -> 0 | 0.0 (cima schermo) -> 127
  int val = int(map(tcur.getY(), 1, 0, 0, 127));
  
  // Invia il valore al CC corrispondente all'ID del cursore
  myBus.sendControllerChange(0, id, val);
}

// CALLBACK OBBLIGATORIE PER CURSORI
void addTuioCursor(TuioCursor tcur) { println("Punto di contatto aggiunto: " + tcur.getCursorID()); }
void removeTuioCursor(TuioCursor tcur) { println("Punto di contatto rimosso: " + tcur.getCursorID()); }

// CALLBACK VUOTE PER OGGETTI E BLOB
void refresh(TuioTime bundleTime) {}
void addTuioObject(TuioObject tobj) {}
void updateTuioObject(TuioObject tobj) {}
void removeTuioObject(TuioObject tobj) {}
void addTuioBlob(TuioBlob tblb) {}
void updateTuioBlob(TuioBlob tblb) {}
void removeTuioBlob(TuioBlob tblb) {}
