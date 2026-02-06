# WIWA Admin Panel - Functional Specification

**Verzija:** 1.0
**Status:** Odobreno za Implementaciju
**Zasnovano na:** [Admin_Panel_Proposal.md](file:///c:/Users/mgasic/Documents/AIProjects/Wiener/WIWA_Questionnaires/docs/Admin_Panel_Proposal.md)

---

## 1. Pregled Projekta

Cilj je razvoj **Wiwa Admin Panela**, web aplikacije za vizuelno kreiranje i konfiguraciju dinamičkih upitnika. Ključna karakteristika je **Visual Flowchart Builder** koji omogućava poslovnim korisnicima da dizajniraju logiku grananja i pravila kroz intuitivan drag-and-drop interfejs.

### 1.1 Ciljna Grupa
*   Administratori osiguranja
*   Business Analysti
*   Underwriteri (za definisanje pravila)

---

## 2. Arhitektura Sistema

Admin Panel je zasebna aplikacija koja deli bazu podataka sa glavnim Questionnaire sistemom, ali ima sopstveni Backend API i Frontend.

### 2.1 Project Structure
Projekat će biti smešten u `src/` folderu kao nova celina:

```text
src/
├── Backend/
│   ├── Wiwa.Admin.API/          (New .NET 8 Web API)
│   │   ├── Controllers/
│   │   ├── Services/
│   │   └── Models/              (Shared or specific DTOs)
│   └── Wiwa.Questionnaire.API/  (Existing)
├── Frontend/
│   ├── wiwa-admin-panel/        (New React + Vite App)
│   │   ├── src/
│   │   │   ├── components/
│   │   │   │   ├── flows/       (React Flow components)
│   │   │   │   └── forms/
│   │   │   └── services/
│   └── wiwa-questionnaire-fe/   (Existing)
└── Shared/                      (Shared Kernel/Models if extraction needed)
```

### 2.2 Tech Stack
*   **Backend**: .NET 8, Entity Framework Core 8
*   **Frontend**: React, TypeScript, Vite
*   **Visual Lib**: **React Flow** (za dijagrame)
*   **UI Lib**: Ant Design (za tabele i forme)
*   **State**: Zustand ili React Context

---

## 3. Funkcionalni Zahtevi

### 3.1 Visual Flowchart Builder (Canvas)
Centralni deo aplikacije. Korisnik ne popunjava tabele, već crta dijagram.

#### A. Elementi (Nodes)
1.  **Question Node (Pravougaonik)**
    *   **Prikaz**: Labela pitanja, kratak tekst, ikonica tipa kontrole (Radio, Input).
    *   **Akcije**: Edit (otvara modal), Delete, Clone.
    *   **Portovi**:
        *   *Input*: Ulazna grana (odakle se dolazi).
        *   *Output*: Izlaz (ka odgovorima).

2.  **Answer Node (Romb/Decision)**
    *   **Prikaz**: Tekst odgovora (npr. "DA", "NE").
    *   **Akcije**: Edit, Delete.
    *   **Portovi**:
        *   *Input*: Veza sa Parent Pitanjem.
        *   *Output*: Veza ka Child Pitanju (Grananje).

3.  **Computed Config Node (Šestougao - Opciono)**
    *   Služi za vizuelno povezivanje Matrica sa Pitanjima.
    *   Prikazuje izabranu matricu.

#### B. Veze (Edges)
1.  **Branching Edge**: Povezuje `Answer Node` -> `Question Node`.
    *   Značenje: "Ako se izabere ovaj odgovor, prikaži ovo pitanje".
    *   Mapira se na tabelu `PredefinedAnswerSubQuestions`.

2.  **Generic Edge**: Povezuje `Question Node` -> `Question Node` (za `AlwaysVisible` logiku).
    *   Značenje: "Ovo pitanje je uvek vidljivo ispod roditelja".

#### C. Canvas Operacije
*   **Drag & Drop**: Dodavanje novih pitanja iz "Toolbox-a".
*   **Auto-Layout**: Dugme za automatsko raspoređivanje čvorova (koristeći Dagre ili Elkjs algoritam).
*   **Validation**: Real-time validacija (npr. detekcija ciklusa).

### 3.2 Question Bank (Katalog)
Pre nego što se pitanje stavi na dijagram, mora se definisati.
*   Lista svih pitanja sa filtriranjem/pretragom.
*   CRUD forma za kreiranje pitanja (Tekst, Labela, Tip, Format).

### 3.3 Configuration Managers
*   **Matrices Manager**: Pregled i upload Excel fajlova za matrice.
*   **Reference Tables**: Mapiranje eksternih tabela.

---

## 4. Plan Realizacije (Roadmap)

Razvoj je podeljen u 4 faze (Sprints).

### Phase 1: Foundation & Scaffold (1 Nedelja)
*   [ ] Inicijalizacija `.NET` projekta (`Wiwa.Admin.API`).
*   [ ] Setup EF Core konteksta (povezivanje na postojeću bazu).
*   [ ] Inicijalizacija React projekta (`wiwa-admin-panel`).
*   [ ] Instalacija biblioteka (React Flow, Axios, AntD).
*   [ ] Implementacija osnovnog Layout-a (Sidebar, Header).

### Phase 2: Question Bank & Basic CRUD (1 Nedelja)
*   [ ] Backend: CRUD API za `Questions`, `QuestionFormats`.
*   [ ] Frontend: Tabela svih pitanja sa paginacijom.
*   [ ] Frontend: Modal/Forma za kreiranje/editovanje pitanja.
*   [ ] Backend: CRUD za `PredefinedAnswers`.

### Phase 3: Visual Builder Core (2-3 Nedelje)
*   [ ] **Canvas Setup**: Integracija React Flow-a.
*   [ ] **Custom Nodes**: Kreiranje UI komponenti za Question i Answer čvorove.
*   [ ] **Drag & Drop**: Logika prevlačenja pitanja na platno.
*   [ ] **Connecting Logic**: Kreiranje veza (branching) i čuvanje u bazu (`SaveGraph` endpoint).
    *   *Napomena*: Ovde je potrebna kompleksna logika transformacije Graf -> Relacione Tabele.

### Phase 4: Advanced Features & Polish (1-2 Nedelje)
*   [ ] **Computed Logic**: UI za konfiguraciju computed pitanja.
*   [ ] **Auto-Layout**: Algoritam za automatsko sređivanje grafa.
*   [ ] **Validacija**: Sprečavanje snimanja nevalidnih grafova.
*   [ ] **Export/Import**: JSON export cele konfiguracije (backup).
