---
description: Pravila o tačnosti podataka - KRITIČNA pravila za rad sa WIWA modelom
priority: critical
applies_to: all_agents
version: 1.0
---

# Pravila o Tačnosti Podataka

> [!CAUTION]
> Ova pravila su **OBAVEZNA** za sve AI agente. Kršenje ovih pravila dovodi do neispravnih sistema!

## 1. Izvori Istine

### 1.1 Dva Primarna Izvora

| Vrsta podatka | Izvor fajla | Lokacija |
|---------------|-------------|----------|
| **Struktura** (tabele, kolone, tipovi, FK, constrainti) | `WIWA_DB_NEW_MODEL_*.sql` | `docs/` |
| **Vrednosti** (lookup tabele, pitanja, odgovori, matrice) | `WIWA_DB_NEW_DATA_*.sql` | `docs/` |

### 1.2 Prioritet kada postoji neusklađenost

1. `WIWA_DB_NEW_MODEL_*.sql` - DDL model baze
2. `WIWA_DB_NEW_DATA_*.sql` - Snapshot podataka
3. `WIWA_Questionnaire_Documentation_*.md` - Funkcionalna dokumentacija i logika
4. `WIWA_Questionnaire_GUI_JSON.schema.*.json` - JSON šema (izvedena iz modela za GUI)

## 2. Obavezne Provere

### 2.1 Pre svake operacije sa bazom

```
✅ OBAVEZNO proveri:
- [ ] Ime tabele postoji u MODEL.sql
- [ ] Ime kolone postoji u MODEL.sql
- [ ] Tip kolone je tačan (int, smallint, nvarchar, bit, decimal...)
- [ ] FK relacije su ispravne
- [ ] Constraint imena su tačna
```

### 2.2 Pre svake operacije sa podacima

```
✅ OBAVEZNO proveri:
- [ ] ID vrednosti postoje u DATA.sql
- [ ] Lookup vrednosti postoje (QuestionFormatID, SpecificQuestionTypeID...)
- [ ] Kod odgovora (PredefinedAnswers.Code) je tačan
- [ ] Redosled (QuestionOrder) je konzistentan
```

## 3. Zabranjene Radnje

> [!WARNING]
> NIKADA ne radi sledeće:

- ❌ **Ne pretpostavljaj** nazive tabela/kolona - UVEK proveri u MODEL.sql
- ❌ **Ne koristi** stare/zastarele nazive kolona
- ❌ **Ne izmišljaj** ID vrednosti - UVEK proveri u DATA.sql
- ❌ **Ne menjaj** tipove podataka bez eksplicitne potvrde
- ❌ **Ne brisi** constrainte bez analize uticaja

## 4. Validacija Pre Generisanja SQL-a

Svaki SQL koji se generiše mora proći kroz ovu checklist:

```sql
-- VALIDACIONA CHECKLIST:
-- 1. [✓] Sve tabele postoje u MODEL.sql
-- 2. [✓] Sve kolone postoje sa tačnim tipovima
-- 3. [✓] Sve FK reference su validne
-- 4. [✓] Sve ID vrednosti postoje u DATA.sql (za INSERT/UPDATE)
-- 5. [✓] Naming konvencije su ispoštovane
```

## 5. Dokumentacija Izvora

Pri generisanju bilo kog outputa, navedi izvor:

```markdown
> Izvor: WIWA_DB_NEW_MODEL_18_01_2026.sql, linija 150-165
> Verifikovano: [datum]
```

## 6. Audit Trail

Sve promene moraju biti logovane:

| Polje | Opis |
|-------|------|
| `Timestamp` | Kada je promena napravljena |
| `Agent` | Koji agent (BA/DBA/FS) |
| `Action` | Šta je urađeno |
| `Source` | Iz kog fajla je podatak proveren |
| `Verification` | Da li je verifikovano |

---

*Verzija: 1.0 | Datum: 2026-01-22 | Autor: AI Agent System*
