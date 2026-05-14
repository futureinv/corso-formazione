# Hydra-corso-formazione
repository per materiale audio e foto
e istruzioni varie
## 🎨 Archivio Digitale - Corso Live Coding

Benvenuti nell'archivio materiali. Qui trovate le immagini da usare per le esercitazioni con Hydra e Strudel.

### 🚀 Istruzioni per Hydra
Per caricare un'immagine, copia il link "RAW" e usa questo codice:
`s0.initImage("INCOLLA_QUI_IL_LINK")`

<!--## 📂 Elenco Materiali (Link Diretti)
*   **Future1** [Link Foto 1](url_raw_qui)
*   **Future2** [Link Mappa 1](url_raw_qui)
*   **Future3** [Link Quadro 1](url_raw_qui)
*   **Future3** [Link Quadro 1](url_raw_qui)
*   **Future3** [Link Quadro 1](url_raw_qui) -->

### 💡 Suggerimento
Il link "RAW" lo trovi cliccando col destro sull'immagine e "apri immagine in un'altra scheda", assicurati che il link inizi con `https://raw.githubusercontent.com/`.
### Nell'Editor di Hydra prova a scrivere questo esempio
```javascript
s0.initImage("https://url-della-tua-immagine.jpg")

src(s0)
  .pixelate(20, 20) // Il pixelate che abbiamo visto prima!
  .modulate(noise(3))
  .out()
```

### 🖱️ Opzione: Caricamento Rapido (Drag & Drop)
Se vuoi usare un'immagine che hai sul tuo computer senza caricarla online, copia e incolla questo codice in Hydra. Una volta eseguito, trascina semplicemente il file sulla finestra del browser:

```javascript
// Attiva l'ascolto del trascinamento
document.addEventListener('drop', (event) => {
  event.preventDefault();
  const file = event.dataTransfer.files[0];
  const reader = new FileReader();
  reader.onload = (e) => {
    s0.initImage(e.target.result);
    console.log("Immagine pronta in s0!");
  };
  reader.readAsDataURL(file);
});
document.addEventListener('dragover', (e) => e.preventDefault());
```

Per visualizzare l'immagine esegui nell'editor (dopo il trascinamento)
```javascript
src(s0).out()
```

## 🛠️ Configurazione Reactivision per Hydra

Questa sezione descrive la catena software necessaria per trasformare i **Fiducial** (oggetti fisici) in segnali di controllo per Hydra.

### 🔗 La Catena di Collegamento

* **Reactivision**
    * Si occupa solo della visione (TUIO) (https://reactivision.sourceforge.net/).
* **Processing**
    * Si occupa solo della traduzione (**TUIO -> MIDI**).
    * [📂 Clicca qui per scaricare le i programmi un Processing per tradurre cursorTUIO->MIDI e markerTUIO->MIDI](./immagini-archivio/)
    * Usa le librerie **TUIO** e **MIDIbus**.
    * I fiducial dallo **0 al 10** sono mappati per funzionare come manopole.
    * Percorso locale: ``
* **loopMIDI**
    * Fa da ponte virtuale.
    * Software: [Download loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html)
    * Porta da creare: `reacTIVision_Bus`
* **Hydra**
    * Riceve e trasforma.
    * Documentazione: [Hydra MIDI Learning](https://hydra.ojack.xyz/hydra-docs-v2/docs/learning/sequencing-and-interactivity/midi/)

---

### 💻 Script di Configurazione

#### 1. Sulla Console di Hydra (F12)
Copia e incolla questo codice per attivare l'ascolto MIDI nel browser:

```javascript
// register WebMIDI
navigator.requestMIDIAccess()
    .then(onMIDISuccess, onMIDIFailure);

function onMIDISuccess(midiAccess) {
    console.log(midiAccess);
    var inputs = midiAccess.inputs;
    var outputs = midiAccess.outputs;
    for (var input of midiAccess.inputs.values()){
        input.onmidimessage = getMIDIMessage;
    }
}

function onMIDIFailure() {
    console.log('Could not access your MIDI devices.');
}

// create an array to hold our cc values and init to a normalized value
var cc = Array(128).fill(0.5)

getMIDIMessage = function(midiMessage) {
    var arr = midiMessage.data    
    var index = arr[1]
    // console.log('Midi received on cc#' + index + ' value:' + arr[2]) // monitor
    var val = (arr[2]+1)/128.0  // normalize CC values to 0.0 - 1.0
    cc[index] = val
}
```
### 2. Nell'Editor di Hydra
Esempi di mappatura per controllare i parametri con i Fiducial (o i knob del Korg NanoKontrol2):

```javascript
// Esempio 1: Controllo colore con i primi tre knob (CC 16, 17, 18)
noise(4)
  .color(() => cc[16], () => cc[17], () => cc[18])
  .out()

// Esempio 2: Rotazione e Scala con i primi due fader (CC 0, 1)
osc(10, 0.2, 0.5)
  .rotate(() => (cc[0] * 6.28) - 3.14)
  .scale(() => cc[1])
  .out()
```
