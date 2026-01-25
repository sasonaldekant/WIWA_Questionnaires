# Lessons Learned: WIWA Questionnaire Implementation

> **Datum**: 2026-01-25
> **Kontekst**: Implementacija "Skraćenog upitnika" (Type 2) i razvoj Generičkog Renderera.

Ovaj dokument sumira ključna tehnička saznanja, probleme i rešenja uočena tokom razvoja, kako bi se osigurala nesmetana implementacija budućih tipova upitnika.

---

## 1. Arhitektura Podataka i JSON Generisanje

### Problem Duplog Roditeljstva (Double Parenting)
**Simptom**: Pitanja koja su kondicionalna (pojavljuju se izborom odgovora) pojavljivala su se i kao "deca" (uvek vidljiva) ili duplirana na dnu forme.
**Uzrok**: Pitanja su imala definisan `ParentQuestionID` u tabeli `Questions` I istovremeno su bila vezana kroz `PredefinedAnswerSubQuestions`. Generator je ovo tumačio kao dve instrukcije za prikaz‚1    1w  ‚q2E32.
**Pravilo**: 
> 🛑 **Kondicionalna pitanja NE SMEJU imati definisan `ParentQuestionID` u bazi.**
> `ParentQuestionID` služi isključivo za "Always Visible" grupisana pitanja (npr. unutar sekcije koja se uvek vidi).

### Rekurzivnost JSON Strukture
**Saznanje**: Generator (`JSON_File_Generator.sql`) kreira ugnježdenu strukturu. Međutim, bitno je da se `Root` pitanja (ona koja nisu deca i nisu kondicionalna) ispravno identifikuju.
**Pravilo**: `Root` query mora eksplicitno isključiti pitanja koja su deca (`ParentID IS NOT NULL`) ILI su kondicionalna (`EXISTS IN PredefinedAnswerSubQuestions`).

---

## 2. HTML Renderer Logika (Client-Side)

### Duboko Indeksiranje (Deep Indexing)
**Problem**: Renderer nije prepoznavao inpute za kalkulaciju (npr. BMI) jer su bili ugnježdeni duboko u strukturi.
**Rešenje**: Funkcije za inicijalizaciju (`normalizeQuestions`) i proveru pokrivenosti (`refresh` / `collectReferencedSubQuestionIds`) moraju rekurzivno prolaziti kroz **sve** grane:
1. `Children` (Always Visible deca)
2. `Answers` -> `SubQuestions` (Kondicionalna deca)
**Pravilo**: Nikada se ne oslanjati samo na `questions` niz na vrhu JSON-a; on sadrži samo korene.

### Input Vrednosti vs. Kodovi
**Problem**: BMI kalkulacija nije radila jer je logika tražila `.code` (što je standard za Dropdown/Radio), dok Text Input polja koriste `.value`.
**Rešenje**: Generička funkcija `getSelectedCode(qid)` mora podržati fallback:
```javascript
return STATE[qid].code ?? STATE[qid].value;
```
**Pravilo**: Prilikom implementacije novih pravila kalkulacije, uvek proveriti tip input kontrole.

### Detekcija Korena (Root Detection)
**Problem**: "Ghost" pitanja (npr. Visina/Težina) su se pojavljivala na dnu forme jer ih renderer nije prepoznao kao "zauzeta" (roditelj im je bio 102).
**Rešenje**: Funkcija koja određuje šta da se prikaže kao Root mora proveriti DA LI je pitanje referencirano bilo gde u hijerarhiji (kao Child ili SubQuestion). Ako jeste, NE SME se prikazati u Root-u.

---

## 3. Generički Dizajn Pravila (Rule Engine)

### Implementacija Computed Logike
**Koncept**: Renderer je dizajniran da bude "Engine". On ne sadrži hardkodovane ID-jeve pitanja (npr. `if (id == 100)`).
Umesto toga, on implementira **Metode** (npr. `BMI_CALC`).
- **Definicija**: JSON govori *koji* metod se koristi i *nad kojim* inputima (putem `inputQuestionIds` i `kind`).
- **Implementacija**: JS kod sadrži formulu za `BMI_CALC`.
**Benefit**: Ako se ID-jevi pitanja promene u bazi, JSON se regeneriše sa novim ID-jevima, a logika u JS-u ostaje nepromenjena jer se oslanja na *Label-e* (`BMI.H`, `BMI.W`) ili input niz injektovan iz JSON-a.

### Default Vrednosti
**Saznanje**: Ako su u bazi odgovori označeni sa `PreSelected = 1`, renderer će ih automatski selektovati.
**Pravilo**: Za čista, nova popunjavanja, osigurati da SQL skripte (DML) ne postavljaju `PreSelected` flagove, osim ako je to eksplicitni zahtev biznisa.

---

---

---

## 4. Zlatna Pravila za Micro-Modul Arhitekturu (Refined Guidelines)

Na osnovu retrospektive, definisana su ključna pravila za razvoj nezavisnog "Questionnaire Modula":

### Arhitektura (Separation of Concerns)
1.  **Dumb Renderer**: Modul zna SAMO da prikaže pitanje i sakupi odgovor. Ne zna *ništa* o tarifama, polisama ili rizicima.
2.  **Stateless Design**: Modul ne čuva stanje između sesija. Prima `InputJSON`, vraća `OutputJSON`. Stanje se čuva u Parent aplikaciji (Portal, ERP).
3.  **Strict Boundary**: Nema deljenja baza podataka sa UW modulom. Komunikacija isključivo preko definisanog API/JSON interfejsa.

### Proces Implementacije
4.  **No Partial Specs**: Zabranjeno je implementirati "samo 3 pitanja za test". Generator mora dobiti kompletnu strukturu da bi ispravno mapirao Parent/Child odnose.
5.  **Review First**: Pre kucanja koda, BA i Dev moraju potvrditi da li je pravilo "Data Collection" (Upitnik) ili "Business Decision" (UW).

### Integracija
6.  **Embeddable First**: Dizajnirati UI tako da može živeti u `<iframe>` ili kao Web Component (`<wiwa-questionnaire>`).
7.  **Message Passing**: Koristiti `window.postMessage` za komunikaciju između Parent-a i Modula (npr. "QuestionnaireCompleted").

