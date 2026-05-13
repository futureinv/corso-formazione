# corso-formazione
repository per materiale audio e foto
# 🎨 Archivio Digitale - Corso Live Coding

Benvenuti nell'archivio materiali. Qui trovate le immagini da usare per le esercitazioni con Hydra e Strudel.

## 🚀 Istruzioni per Hydra
Per caricare un'immagine, copia il link "RAW" e usa questo codice:
`s0.initImage("INCOLLA_QUI_IL_LINK")`

<!--## 📂 Elenco Materiali (Link Diretti)
*   **Future1** [Link Foto 1](url_raw_qui)
*   **Future2** [Link Mappa 1](url_raw_qui)
*   **Future3** [Link Quadro 1](url_raw_qui)
*   **Future3** [Link Quadro 1](url_raw_qui)
*   **Future3** [Link Quadro 1](url_raw_qui) -->

## 💡 Suggerimento
Il link "RAW" lo trovi cliccando col destro sull'immagine e "apri immagine in un'altra scheda", assicurati che il link inizi con `https://raw.githubusercontent.com/`.


## 🖱️ Opzione: Caricamento Rapido (Drag & Drop)
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


