# WIWA Admin Panel - Proposal & Complexity Analysis

**Status:** Draft Proposal

## 1. Sažetak

Zahtev je kreiranje zasebnog projekta (Admin Panel) za upravljanje konfiguracijom upitnika. Ovo podrazumeva CRUD operacije nad svim tabelama koje definišu strukturu, logiku i pravila, **izuzimajući** tabele sa odgovorima korisnika (`QuestionnaireAnswers`, `Indicators`).

**Procena Kompleksnosti:** **Srednja ka Visokoj (Medium-High)**
Glavni izazov nije broj tabela, već **relaciona kompleksnost** (grananje pitanja) i **validacija logike** (computed pitanja).

---

## 2. Obim Podataka (Scope)

Aplikacija treba da upravlja sledećim entitetima (na osnovu `Functional_Specification.md`):

### A. Katalog i Struktura (Osnovno)
1.  `QuestionnaireTypes` (Definicija tipova)
2.  `Questions` (Katalog pitanja - Tekst, Format, Labela)
3.  `PredefinedAnswers` (Opcije odgovora)
4.  `Questionnaires` (Link Pitanje <-> Tip Upitnika)

### B. Napredna Logika (Visoka Kompleksnost)
5.  `PredefinedAnswerSubQuestions` (Grananje: Odgovor -> Nova Pitanja)
6.  `QuestionComputedConfigs` (Logika za automatsko popunjavanje)
7.  `SpecificQuestionTypes` (Markovi: AlwaysVisible, Computed...)

### C. Mapiranja i Šifarnici (Srednja Kompleksnost)
8.  `QuestionnaireTypeReferenceTables` (Veze sa ERP tabelama)
9.  `QuestionReferenceColumns` (Mapiranje kolona)
10. `QuestionFormats` (UI kontrole)
11. `ComputeMethods` (Metode izračunavanja)

### D. Scoring i Pravila
12. `QuestionnaireTypeRules` (Pravila ocenjivanja)
13. `Ranks`, `RiskLevels` (Definicije nivoa)

---

## 3. Ključni Izazovi i Rešenja

### 3.1 Vizuelizacija Grananja (The Tree Problem)
Upitnik nije linearna lista, već **graf**.
*   **Izazov**: Prikazati i editovati logiku "Ako odgovorim DA, otvori pitanja X, Y, Z".
*   **Rešenje**: Potreban je **Tree Editor** ili **Graph Editor** (poput Node-RED ili jednostavnog Tree View-a). Obične tabele ovde nisu dovoljne jer je teško pratiti dubinu grananja.

### 3.2 Computed Logic Builder
Konfigurisanje `QuestionComputedConfigs` je apstraktno.
*   **Izazov**: Korisnik mora da izabere Metodu, Matricu, i Ulazna pitanja koja se mapiraju na matricu.
*   **Rešenje**: Wizard interfejs:
    1. Izaberi Matricu (npr. `BuildingCategoryMatrix`).
    2. Sistem učita kolone matrice.
    3. Korisnik bira koja Pitanja pune te kolone.

### 3.3 Validacija "Markova"
*   **Izazov**: Pitanje označeno kao `Computed` MORA imati definisan Config. Pitanje označeno kao `AlwaysVisible` mora imati roditelja.
*   **Rešenje**: Jaka validaciona logika na Backend-u i Frontend-u pre čuvanja.

---

## 4. Predložena Arhitektura

### Tech Stack
Preporučuje se isti stack kao i glavni sistem radi lakše integracije domenskih modela.
*   **Backend**: .NET Core 8 Web API
*   **Frontend**: React (ili Next.js) + TypeScript
*   **UI Lib**: Ant Design ili Material UI (imaju dobre Tree i Form komponente)

### Moduli Aplikacije

1.  **Question Bank**: Centralni repozitorijum svih pitanja (CRUD).
2.  **Questionnaire Builder**: Drag-and-drop interfejs za sastavljanje upitnika i definisanje redosleda.
3.  **Branching Manager**: Interfejs za povezivanje Odgovora sa Pod-pitanjima.
4.  **Logic & Mapping**: Interfejs za vezivanje ERP tabela i matrica.

---

## 5. Procena Vremena (Gruba skica)

| Faza | Aktivnost | Procena (Sprintovi) |
|------|-----------|---------------------|
| **1. Setup** | Kreiranje projekta, Entity Framework modeli (dosta koda već postoji), Osnovni CRUD | 1 nedelja |
| **2. Katalog** | UI za Pitanja i Odgovore (Master-Detail view) | 1 nedelja |
| **3. Builder** | Asocijacija pitanja sa upitnikom, sortiranje | 0.5 nedelje |
| **4. Grananje** | **Najteži deo**. Tree logika, sprečavanje cirkularnih veza. | 1.5 - 2 nedelje |
| **5. Logika** | Computed Configs, Matrices UI | 1 nedelja |
| **6. Polish** | Validacije, Testiranje, UI finetuning | 1 nedelja |

**Ukupno**: cca **6 nedelja** za potpuno funkcionalan MVP.

## 
---

## 7. Nova Opcija: Visual Flowchart Builder ("Out of the Box")

Na osnovu dodatne analize, predlažemo **Vizuelni Pristup** umesto klasičnih formi. Ovo drastično menja UX i čini sistem intuitivnijim za poslovne korisnike.

### Koncept
Umesto "popunjavanja formi", korisnik **crta** upitnik kao dijagram toka (Flowchart).

**Elementi (Nodes):**
1.  **Pravougaonik (Question Node)**:
    *   Predstavlja jedan `Question` entitet.
    *   Sadrži textbox za `QuestionLabel`/`QuestionText`.
    *   Ima "Slotove" za konfiguraciju Format-a (Radio, Input...).
2.  **Romb/Grana (Answer/Decision Node)**:
    *   Predstavlja `PredefinedAnswer`.
    *   Kači se na izlaz Pitanja.
    *   **Vizuelna Veza**: Povlačenjem linije od Romba ka novom Pravougaoniku kreira se `PredefinedAnswerSubQuestion` (Grananje).

**Logika Markova i Matrica (Visual Mapping):**
*   **Computed Pitanja**:
    *   Korisnik prevuče "Computed Node".
    *   **Inputs**: Vizuelno poveže (spoji linijom) druga pitanja koja služe kao inputi za matricu.
    *   Sistem u pozadini mapira `QuestionComputedConfigs` i generiše formulu/lookup na osnovu ID-eva povezanih čvorova.
*   **Reference**:
    *   Dropdown unutar čvora za izbor ERP tabele (`QuestionnaireTypeReferenceTables`).
    *   Dropdown za izbor kolone (`QuestionReferenceColumns`).

### Prednosti
1.  **Preglednost**: Odmah se vidi struktura grananja "iz aviona". Nema skrivenih pod-formi.
2.  **Prirodno modelovanje**: Upitnici SU po prirodi grafovi. Model prati mentalni model korisnika.
3.  **Brzina**: Drag-and-drop je brži od kliktanja kroz menije "Add Subquestion".

### Tehnička Implementacija (React Flow)
Za ovo rešenje, **React Flow** (ili XYFlow) je idealna biblioteka.

*   **Canvas**: Beskonačna površina za crtanje.
*   **Nodes**: Custom React komponente za Pitanja i Odgovore.
*   **Edges**: Linije koje predstavljaju veze (Parent -> Child).
*   **Minimap**: Za laku navigaciju kroz velike upitnike.

**Promena Procene:**
*   **Kompleksnost**: Porast na Frontend strani (upravljanje stanjem grafa), ali pojednostavljenje na UX strani.
*   **Vreme**: Dodaje cca **1-2 nedelje** za inicijalni setup Canvas-a, ali štedi vreme kasnije na održavanju jer je sistem otporniji na greške korisnika (lakše se vidi greška u grafu nego u tabeli).
