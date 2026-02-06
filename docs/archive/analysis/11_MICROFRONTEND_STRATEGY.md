# Strategija: Embeddable Questionnaire Micro-Frontend

## 1. Koncept Vizija
Cilj je razviti **"Questionnaire Engine"** kao potpuno nezavisan, samostalan web modul koji se može ugraditi (embed) u bilo koju host aplikaciju (Portal za klijente, Partnerski portal, Interni ERP, Mobilna aplikacija via WebView).

Ključna karakteristika: **Loose Coupling**.
Modul ne zna ko ga hostuje. On radi svoj posao (renderuje pitanja, kupi odgovore) i vraća rezultat.

---

## 2. Arhitektura Integracije

### Opcija A: Iframe (Preporučeno za potpunu izolaciju)
Host aplikacija učitava modul u `<iframe>`. Obezbeđuje maksimalnu CSS/JS izolaciju.

**Komunikacija (postMessage Protocol):**

1.  **INIT (Host -> Module)**: Host šalje konfiguraciju.
    ```json
    {
      "type": "WIWA_INIT",
      "payload": {
        "questionnaireTypeId": 1,
        "theme": "dark",
        "prefillData": { "height": 180, "weight": 85 }
      }
    }
    ```

2.  **RESIZE (Module -> Host)**: Modul javlja svoju visinu da Host prilagodi iframe.
    ```json
    { "type": "WIWA_RESIZE", "payload": { "height": 650 } }
    ```

3.  **COMPLETE (Module -> Host)**: Korisnik je završio. Vraća odgovore.
    ```json
    {
      "type": "WIWA_COMPLETE",
      "payload": {
        "answers": [ { "qid": 101, "val": "YES" } ],
        "meta": { "duration": 120 }
      }
    }
    ```

### Opcija B: Web Component (Custom Element)
Host koristi `<wiwa-questionnaire-renderer>` tag.
*   Prednost: Lakša integracija u React/Angular hostove.
*   Mana: Rizik od CSS curenja (treba Shadow DOM).

**Odluka:** Ići prvo sa **Iframe** pristupom jer je robustniji za integraciju u legacy sisteme (ERP) i 3rd party portale.

---

## 3. Tehnički Stack Modula

### Frontend (The Embedded App)
*   **Framework**: React ili Vue (zbog virtual DOM performansi).
*   **Build**: Vite (za brzi development i optimizovan bundle).
*   **Styling**: CSS Modules ili Styled Components (da se izbegnu globalni stilovi).
*   **Router**: Nije potreban (Single View application).

### Backend (The API)
*   Modul komunicira sa svojim API-jem (`/api/questionnaire/schema/{id}`).
*   Host aplikacija NE komunicira direktno sa Questionnaire DB. Host dobija JSON rezultat od frontenda i prosleđuje ga dalje svom backendu (UW Modulu).

---

## 4. Workflow Razvoja (Dev Experience)

Za developera koji radi na ovom modulu, okruženje treba da simulira Host aplikaciju.

1.  **Dev Mode**: Pokreće se `standalone` verzija koja ima "Mock Host" wrapper.
2.  **Mock Host**: Panel sa strane koji omogućava developeru da:
    *   Izabere tip upitnika (šalje INIT).
    *   Vidi output JSON (osluškuje COMPLETE).
    *   Menja teme/parametre.

## 5. Sledeći Koraci
1.  Kreirati **Repo/Folder** strukturu za `wiwa-questionnaire-fe`.
2.  Implementirati `postMessage` listener u postojećem prototipu (`WIWA_Questionnaire_Renderer.html`) kao POC.
3.  Definisati tačan JSON Schema ugovor (Contract).
