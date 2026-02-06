# WIWA Questionnaire - Integration Guide

**Datum:** 04.02.2026
**Status:** Aktuelno
**Verzija:** 2.0

## 1. Uvod

Ovaj vodič je namenjen programerima host aplikacija (Portali, ERP sistemi) koji žele da integrišu WIWA Upitnik ili konzumiraju njegove podatke. Pokriva tri ključne oblasti:
1.  **Iframe Integracija**: Kako ugraditi upitnik u drugu aplikaciju.
2.  **JSON Export**: Struktura podataka koju upitnik generiše.
3.  **HTML Primer**: Kod za ugradnju.

---

## 2. Iframe Integracija

Upitnik je dizajniran da radi kao potpuno izolovan modul unutar `iframe` elementa, komunicirajući sa host aplikacijom putem `window.postMessage` API-ja.

### 2.1 Arhitektura

```
[ HOST APLIKACIJA ]  <--->  [ WIWA IFRAME ]
       |                          |
   (postMessage)              (REST API)
       |                          |
       +--------------------------+
```

### 2.2 Protokol Poruka

Komunikacija je asinhrona i vođena događajima.

#### Inicijalizacija (Host -> Iframe)
Host inicijalizuje upitnik slanjem poruke `WIWA_INIT`. bez ovoga upitnik ostaje prazan.

```javascript
const payload = {
    questionnaireType: 'LOCATION',  // Kod tipa upitnika
    identificatorValue: 'LOK-001',  // ID entiteta (npr. broj polise)
    identificatorTypeID: 1,         // Tip identifikatora
    mode: 'CREATE',                 // 'CREATE', 'EDIT', 'VIEW'
    instanceId: null                // Obavezno za EDIT/VIEW
};

iframe.contentWindow.postMessage({ type: 'WIWA_INIT', payload }, '*');
```

#### Završetak (Iframe -> Host)
Kada korisnik završi unos, upitnik šalje `WIWA_COMPLETE` sa podacima.

```javascript
window.addEventListener('message', (event) => {
    if (event.data.type === 'WIWA_COMPLETE') {
        const result = event.data.payload;
        console.log('Sacuvano:', result.instanceId);
        console.log('Enriched Data:', result.referenceMappings);
    }
});
```

---

## 3. Izlazni JSON (Export Structure)

Sistem generiše bogat JSON dokument koji opisuje i strukturu i podatke. Ovo se koristi i za renderovanje i kao export format.

### Primer Strukture

```json
{
  "meta": {
    "schemaVersion": "v3",
    "generatedAt": "2026-02-04T12:00:00Z"
  },
  "questionnaire": {
    "typeId": 1,
    "typeName": "Veliki Upitnik"
  },
  "questions": [
    {
      "QuestionID": 101,
      "QuestionText": "Materijal zidova?",
      "UiControl": "select",
      "Answers": [
        { "PredefinedAnswerID": 1, "Answer": "Opeka", "Code": "BRICK" },
        { "PredefinedAnswerID": 2, "Answer": "Beton", "Code": "CONCRETE" }
      ]
    }
  ],
  "referenceMappings": [
    {
      "questionId": 101,
      "tableName": "ConstructionMaterials",
      "referenceColumnName": "MaterialCode",
      "value": "BRICK"
    }
  ]
}
```

**Ključni delovi:**
*   `questions`: Ravna ili ugnježdena lista pitanja za renderovanje.
*   `referenceMappings`: Povezuje odgovore sa ERP tabelama (ključno za integraciju).
*   `dictionaries`: Definicije formata (radio, check, etc.).

---

## 4. HTML Primer za Ugradnju

Ispod je kompletan primer HTML koda koji demonstrira kako ugraditi WIWA upitnik i rukovati komunikacijom.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>WIWA Host Integration Demo</title>
    <style>
        iframe {
            width: 100%;
            height: 600px;
            border: 1px solid #ccc;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <h1>ERP Portal - Novi Zahtev</h1>
    
    <!-- Kontejner za upitnik -->
    <div id="wiwa-container">
        <iframe 
            id="wiwa-frame" 
            src="http://localhost:3000/wiwa-renderer.html" 
            title="WIWA Questionnaire">
        </iframe>
    </div>

    <script>
        const iframe = document.getElementById('wiwa-frame');

        // 1. Čekamo da se iframe učita
        iframe.onload = () => {
            console.log("WIWA Iframe loaded. Sending INIT...");
            
            // 2. Šaljemo konfiguraciju
            const initMessage = {
                type: 'WIWA_INIT',
                payload: {
                    questionnaireType: 'LOCATION',
                    identificatorValue: 'DEMO-123',
                    identificatorTypeID: 1
                }
            };
            
            iframe.contentWindow.postMessage(initMessage, '*');
        };

        // 3. Slušamo odgovore od upitnika
        window.addEventListener('message', (event) => {
            // Bezbednosna provera porekla (u produkciji otkomentarisati)
            // if (event.origin !== "http://trusted-wiwa-domain.com") return;

            const { type, payload } = event.data;

            if (type === 'WIWA_COMPLETE') {
                alert('Upitnik uspešno popunjen! ID: ' + payload.instanceId);
                console.log("Rezultati:", payload);
                // Ovde ERP preuzima podatke i nastavlja svoj proces
            } 
            else if (type === 'WIWA_RESIZE') {
                // Opciono: Prilagođavanje visine iframe-a
                iframe.style.height = payload.height + 'px';
            }
        });
    </script>
</body>
</html>
```

### 4.1 Napomene za Implementaciju

1.  **CORS**: Uverite se da server na kome se hostuje upitnik vraća odgovarajuće CORS hedere ako su domeni različiti.
2.  **Resize**: Za najbolje korisničko iskustvo, implementirajte `WIWA_RESIZE` osluškivač kako bi se iframe automatski širio/skupljao prema sadržaju upitnika (izbegava dupli scrollbar).
3.  **Authentication**: Ako je potrebna autentifikacija, token se može proslediti kao deo `WIWA_INIT` payloada.
