# Arhitektura: Razdvajanje Upitnika i UW Logike

## Cilj Razdvajanja

Jasna demarkacija odgovornosti između **Modula Upitnika (Questionnaire Engine)** i **Modula Preuzimanja Rizika (UW Engine)**.

*   **Upitnik**: Fokusiran na **prikupljanje podataka** i **izračunavanje rezultata** (Score, Matrix Value). Ne zna za polise, tarife niti finalne odluke (Odbijanje, Korekcija).
*   **UW Modul**: Koristi rezultate upitnika kao **ulazne parametre** za donošenje poslovnih odluka na osnovu definisanih pravila.

---

## 1. Modul Upitnika (Questionnaire Domain)

Odgovoran za interakciju sa korisnikom i prikupljanje sirovih ili obrađenih podataka.

### Odgovornosti
1.  **Rendering**: Prikaz pitanja na osnovu definicije (`Questions`, `QuestionFormats`).
2.  **Validacija Unosa**: Da li je polje popunjeno, format (email, broj), range check.
3.  **Navigacija/Grananje**: Prikazivanje/sakrivanje pitanja na osnovu odgovora (`ConditionallyVisible`, `PredefinedAnswerSubQuestions`).
4.  **Kalkulacija (Computed)**: Izračunavanje vrednosti na osnovu unosa (npr. BMI = Visina/Težina).
5.  **Matrix Lookup**: Određivanje "Kategorije" odgovora na osnovu matrice (npr. BMI vrednost -> BMI Rang, Sport -> Razred Opasnosti).
6.  **Scoring**: Sabiranje bodova (npr. AML Score).

### Izlaz (Output)
Objekat koji sadrži:
*   Parove `QuestionID: AnswerValue`
*   Izračunate vrednosti (`ComputedValue`)
*   Lookup rezultate (`ResultCode` npr. 'BMI_RANGE_3', 'SPORT_CLASS_IV')

**Upitnik NE ZNA**:
*   Kolika je korekcija premije (npr. 5‰).
*   Da li to znači odbijanje ponude.
*   Koji dokumenti su potrebni (osim ako to nije eksplicitno pitanje).

---

## 2. UW Modul (Business Logic Domain)

Odgovoran za tumačenje rezultata upitnika u kontekstu produkta i police.

### Ulaz (Input)
*   Rezultati Upitnika (Output iznad)
*   Kontekst Ponude:
    *   Proizvod / Tarifa
    *   Osigurana Suma
    *   Pristupna Starost
    *   Status Klijenta (Novo/Postojeće)

### Odgovornosti (Logika Pravila)
1.  **Mapiranje Rezultata na Akcije**:
    *   Input: `ResultCode='SPORT_CLASS_IV'` + `Tariff='ZIVOT'`
    *   Logic: Look up `AllowedCorrectionLevels` / `Corrections` / `Matrices`
    *   Action: `Correction = 5‰`
2.  **Odluke o Prihvatu**:
    *   Input: `ResultCode='BMI_RANGE_REJECT'`
    *   Action: Status Ponude = `REJECTED` ili `UW_REVIEW`
3.  **Zahtevi za Dokumentacijom**:
    *   Input: `QuestionID=110 Answer='YES'` (Bolest srca)
    *   Action: Dodaj u listu potrebnih dokumenata "Kardiološki izveštaj"
4.  **Generisanje Notifikacija**:
    *   Input: `AML_Score=HIGH`
    *   Action: Slanje emaila AML oficiru.

---

## 3. Primer Razdvajanja - BMI

### Stari Pristup (Mixed)
Upitnik izračuna BMI, vidi da je 35, zna da je to +2‰ za Život i ispiše poruku "Korekcija premije".

### Novi Pristup (Separated)

**1. Korak: Upitnik (Questionnaire Engine)**
*   Prikazuje polja Visina, Težina.
*   Računa: `BMI = 100kg / (1.80m)² = 30.86` (Čista matematika).
*   **Output Upitnika**: `{ "BMI_Value": 30.86 }`
*   *Napomena: Upitnik ne zna u koji Range ovo spada.*

**2. Korak: UW Modul (Business Logic)**
*   Prima: `BMI_Value = 30.86`
*   **Klasifikacija**: Proverava matricu pravila -> `30.86` spada u `BMI_RANGE_2`.
*   **Odluka**:
    *   Za Tarifu "Život": `BMI_RANGE_2` -> Korekcija **+0.4‰**
    *   Za Tarifu "Hirurške": `BMI_RANGE_2` -> Korekcija **+0.5%**
*   **Akcija**: Primenjuje korekcije na ponudu i dodaje sistemsku poruku UW-u.

---

## 4. Uticaj na Bazu i Skripte

### Tabele koje ostaju u Upitnik Domen (Questionnaire)
*   `QuestionnaireTypes`
*   `Questions`
*   `PredefinedAnswers` (sadrže opcije, ali NE i `StatisticalWeight` ako je to biznis pravilo korekcije. Ako je samo score za rezultat upitnika, onda ostaje).
*   `SpecificQuestionTypes`
*   `QuestionFormats`
*   `QuestionReferenceTables` (Veze ka šifarnicima opcija, npr. lista sportova)

### Tabele koje pripadaju UW Domen (Business Rules)
*   `Corrections` (Sadržaj korekcija)
*   `CorrectionLevels`
*   `AllowedCorrectionLevels` (Veza pravila i tarife)
*   `QuestionnaireDisplayRules` (Kada se koji upitnik prikazuje - ovo je UW odluka pre samog upitnika)
*   `RiskAssessmentResults` (Interpretacija skora)
*   `RiskLevelRules` (Pravila za interpretaciju)
*   `ValidationRules` (Ako su cross-field ili vezana za tarifu)

### Analiza Skripti

| Skripta | Domen | Akcija |
|---------|-------|--------|
| `01_QuestionnaireTypes` | Shared/Quest | **Keep**. Definiše tipove. |
| `02_QuestionFormats` | Quest | **Keep**. UI formati. |
| `03_Questions_...` | Quest | **Keep**. Definicija pitanja. |
| `04_PredefinedAnswers` | Quest | **Keep**. `StatisticalWeight` nosi težinu/score odgovora. Za varijabile poput "Godine starosti" koristi se Input pitanje. |
| `05_Branching` | Quest | **Keep**. UI logika. |
| `09_Sports...` | Shared | **Keep**. Šifarnik opcija. `DangerClass` je možda UW koncept, ali je vezan za sport. |
| `10_Computed...` | Quest | **Keep**. Kalkulacija BMI je matematika upitnika. |
| `12_Corrections` | **UW** | **Separate**. Ovo su podaci za UW engine, ne za sam Upitnik. |
| `13_AML...` | **Quest** | **Keep**. Upitnik računa Score (StatisticalWeight). Interpretacija (High/Low) je UW. |
| `14_Logic...` | **UW** | **Separate**. Pravila prikazivanja. |

---

## Zaključak

Nova granica je jasna: **Upitnik proizvodi Podatke/Kodove, UW procesira Odluke.**

Sledeći korak je ažuriranje dokumentacije `01` - `06` da reflektuje ovu promenu terminologije i odgovornosti.
