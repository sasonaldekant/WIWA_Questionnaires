---
description: Komunikacioni protokol između BA i DBA agenata
priority: high
applies_to: [ba_agent, dba_agent]
version: 1.0
---

# Komunikacioni Protokol BA ↔ DBA

## 1. Faze Saradnje

```
FAZA 1: Analiza zahteva (BA vodi)
    ↓
FAZA 2: Validacija modela (DBA vodi)
    ↓
FAZA 3: Dizajn rešenja (zajedno)
    ↓
FAZA 4: Implementacija (DBA vodi)
    ↓
FAZA 5: Verifikacija (zajedno)
```

## 2. FAZA 1: Analiza Zahteva

### BA odgovornosti:

1. Primi zahtev klijenta
2. Razumi poslovni kontekst
3. Identifikuj:
   - Tip upitnika/procesa
   - Potrebna pitanja
   - Logiku grananja
   - Očekivane ishode

### Output za DBA:

```markdown
## Zahtev: [Naziv]

### Tip procesa
- [ ] Upitnik
- [ ] UW proces
- [ ] Workflow
- [ ] Test/Anketa

### Potrebna pitanja
1. [Pitanje 1] - format: [radio/select/input]
2. [Pitanje 2] - format: [...]

### Grananje
- Pitanje 1 → Odgovor X → otvara Pitanje 3
- ...

### Computed vrednosti
- [Koje vrednosti se računaju?]

### Očekivani ishod
- [Šta je rezultat popunjavanja?]
```

## 3. FAZA 2: Validacija Modela

### DBA Checklist

Za svaki element iz BA zahteva:

```markdown
## Validacija: [Naziv zahteva]

### Tipovi upitnika
- [ ] QuestionnaireTypes pokriva? (DA/NE)
- [ ] Potreban novi tip? (DA/NE) → DDL

### Pitanja
| Pitanje | Postoji u Questions? | QuestionFormatID | SpecificQuestionTypeID |
|---------|---------------------|------------------|------------------------|
| P1 | DA/NE | ? | ? |
| P2 | DA/NE | ? | ? |

### Odgovori
| Pitanje | PredefinedAnswers postoje? | Code vrednosti |
|---------|---------------------------|----------------|
| P1 | DA/NE | ? |

### Grananje
| Od pitanja | Do pitanja | PredefinedAnswerSubQuestions postoji? |
|------------|------------|--------------------------------------|
| P1→A1 | P3 | DA/NE |

### Reference tabele
| Tabela | Postoji? | Potrebne kolone? |
|--------|----------|------------------|
| ? | DA/NE | ? |

### Zaključak
- [ ] Model pokriva 100%
- [ ] Potrebna minimalna proširenja: [lista]
- [ ] Potrebna značajna proširenja: [lista]
```

## 4. FAZA 3: Dizajn Rešenja

### Zajednička sesija

1. **BA prezentuje** tok pitanja (skica)
2. **DBA validira** mapiranje na model
3. **Zajedno rešavaju** gaps i nejasnoće

### Artifacts

```markdown
## Dizajn: [Naziv]

### Tok pitanja
[Dijagram ili lista toka]

### Mapiranje na tabele
| Element | Tabela | Kolona | Vrednost |
|---------|--------|--------|----------|
| ... | ... | ... | ... |

### Proširenja modela
[DDL skripte ako su potrebne]

### JSON struktura
[Primer očekivanog JSON-a]
```

## 5. FAZA 4: Implementacija

### DBA generiše:

1. **DDL** (ako je potrebno proširenje modela)
2. **DML** (INSERT za nova pitanja, odgovore, mapiranja)
3. **JSON** (generisan kroz SQL generator)

### Format SQL output-a

```sql
-- ============================================
-- WIWA Questionnaire: [Naziv]
-- Verzija: [X.Y]
-- Datum: [YYYY-MM-DD]
-- Autor: DBA Agent
-- ============================================

-- 1. PROŠIRENJE MODELA (ako je potrebno)
-- ----------------------------------------
-- [DDL skripte]

-- 2. LOOKUP VREDNOSTI
-- ----------------------------------------
-- [INSERT za lookup tabele]

-- 3. PITANJA
-- ----------------------------------------
-- [INSERT za Questions]

-- 4. ODGOVORI
-- ----------------------------------------
-- [INSERT za PredefinedAnswers]

-- 5. GRANANJE
-- ----------------------------------------
-- [INSERT za PredefinedAnswerSubQuestions]

-- 6. REFERENCE MAPIRANJA
-- ----------------------------------------
-- [INSERT za QuestionnaireTypeReferenceTables]
-- [INSERT za QuestionReferenceColumns]

-- 7. VALIDACIJA
-- ----------------------------------------
-- [SELECT upiti za proveru]
```

## 6. FAZA 5: Verifikacija

### Checklist

```markdown
## Verifikacija: [Naziv]

### SQL Provere
- [ ] Svi INSERT-i uspešno izvršeni
- [ ] FK relacije ispravne
- [ ] Lookup vrednosti postoje

### JSON Generisanje
- [ ] JSON generator vraća validan JSON
- [ ] Sva pitanja prisutna
- [ ] Grananje ispravno

### Funkcionalna provera
- [ ] Root pitanja se detektuju ispravno
- [ ] Conditional branching radi
- [ ] Computed vrednosti se računaju
- [ ] Scoring formula ispravna
```

## 7. Eskalacija ka FS Agent-u

### Kada uključiti FS?

1. ❌ Nestandardna UI komponenta
2. ❌ Specijalna validacija koja nije u modelu
3. ❌ Integracija sa eksternim sistemom
4. ❌ Performance optimizacija

### Format zahteva za FS

```markdown
## FS Zahtev: [Naziv]

### Kontekst
[Šta BA i DBA nisu mogli da reše]

### Specifičan zahtev
[Detaljan opis]

### Predložena JSON struktura
[Ako je relevantno]

### Očekivani rezultat
[Šta treba da radi]
```

## 8. Baza Znanja Ažuriranje

Nakon svake uspešne implementacije:

1. **Dokumentuj pattern** ako je nov
2. **Dodaj u katalog** slučajeva
3. **Logiraj** u audit

```markdown
## Novi Pattern: [Naziv]

### Kategorija
[Tip pattern-a]

### Opis
[Kada se koristi]

### Mapiranje
[Tabele i kolone]

### Primer SQL
[Gotov INSERT template]

### Primer JSON
[Očekivani output]
```

---

*Verzija: 1.0 | Datum: 2026-01-22*
