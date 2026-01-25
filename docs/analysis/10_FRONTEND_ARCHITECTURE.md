# Frontend Arhitektura: Metadata-Driven Renderer

## 1. Koncept
Na osnovu analize prototipa (`WIWA_Questionnaire_Renderer.html`) i backend strukture, zaključak je da gradimo **Metadata-Driven UI Engine**.
Aplikacija neće imati hardkodovane forme (npr. `GreatQuestionnaire.js`), već jednu generičku komponentu (`QuestionnaireRenderer`) koja se dinamički iscrtava na osnovu JSON definicije dobijene iz baze.

### Zašto ovaj pristup?
*   **Fleksibilnost**: Promena pitanja u bazi se automatski reflektuje na UI bez deploying-a novog koda.
*   **Konzistentnost**: Svi upitnici (Veliki, Skraćeni, Funkcioner) koriste iste UI komponente i validaciju.
*   **Separation of Concerns**: Frontend se bavi **prikupljanjem podataka**, a ne poslovnim pravilima (premije, korekcije).

---

## 2. Arhitektura Komponente

### Ulaz (Props)
Komponenta prima **Schema JSON** object koji sadrži:
1.  `questions`: Hijerarhijsko stablo pitanja (Root -> Children -> Answers -> SubQuestions).
2.  `meta`: Informacije o tipu upitnika.
3.  `references`: (Opciono) Šifarnici za lookups (npr. lista sportova) ako nisu preveliki.

### Stanje (State)
Interno stanje aplikacije je mapa sa strukturom:
```javascript
State = {
  [QuestionID]: {
    value: "unet tekst",       // Za input polja
    selectedAnswerId: 105,     // Za single-choice
    selectedAnswerIds: [1, 5], // Za multi-choice
    isVisible: true/false      // Rezultat branching logike
  }
}
```

### Izlaz (Output)
Na kraju (Submit), komponenta vraća čist **Answer JSON**:
```json
[
  { "questionId": 101, "answerId": 505 },
  { "questionId": 102, "value": "25.5" } // Computed or Text
]
```
Ovaj JSON se šalje UW Servisu na obradu.

---

## 3. Ključne Funkcionalnosti (Gap Analiza Prototipa)

Trenutni HTML prototip je dobar POC ("Proof of Concept"). Za produkciju je potrebno nadograditi sledeće:

### 3.1 Dinamička Validacija
*   **Problem**: Prototip nema proveru obaveznih polja ili formata.
*   **Rešenje**: U JSON definiciju dodati polja `validation`:
    *   `required`: true/false
    *   `pattern`: regex (za JMBG, Email)
    *   `min/max`: za numeričke vrednosti (Visina, Težina)
*   **UX**: Prikaz greške odmah ispod polja (inline validation).

### 3.2 Computed Pitanja (BMI Kalkulator)
*   **Problem**: Prototip ne izvršava kalkulacije (BMI).
*   **Rešenje**:
    *   Opcija A (Preporučena): Client-side formula u JSON-u.
        *   `formula`: `questions[101].value / (questions[100].value/100)^2`
    *   Opcija B: Backend kalkulacija (samo inputi se šalju, backend vraća BMI).
    *   *Zaključak za Frontend*: Za jednostavne stvari (BMI) raditi client-side radi brzine, ali UW modul verifikuje na backendu.

### 3.3 Async Lookups (Sportovi)
*   **Problem**: Prototip koristi običan `<select>`. Lista sportova može imati stotine stavki.
*   **Rešenje**: Implementirati **Autocomplete / Typeahead** komponentu.
    *   Ako je lista < 500 stavki: Učitati sve u JSON `references` i filtrirati lokalno.
    *   Ako je lista ogromna: Pozvati API `/api/lookups/sports?q=fudbal`.

### 3.4 Branching Animacije
*   **Zahtev**: Kada se otvori novo pitanje (npr. "Da li ste bolovali... DA"), pojava treba da bude glatka.
*   **Implementacija**: Koristiti CSS transitions/animations za `height` ili `opacity` sub-question kontejnera.

---

## 4. Tehnološki Stack (Preporuka)

Iako prototip koristi Vanilla JS, za produkciju se preporučuje moderan framework zbog upravljanja stanjem (State Management) koje postaje kompleksno kod dubokog grananja.

*   **Logic**: React, Vue ili Angular.
*   **State**: React Context ili Pinia/Redux.
*   **UI Komponente**: Koristiti gotove biblioteke (Material UI, Prime, Tailwind UI) za konzistentan izgled inputa, checkbox-ova i modala.

## Zaključak
Na dobrom smo putu. Backend model podataka u potpunosti podržava ovakav generički frontend. Potrebno je samo "oplemeniti" JSON generator da uključi validaciona pravila i formule, i implementirati robustniji renderer od onog u prototipu.
