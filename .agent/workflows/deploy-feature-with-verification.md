---
description: Siguran proces deploymenta sa verifikacijom i rollback-om
---

# Safe Feature Deployment

## Svrha
Ovaj workflow definiše "Safe Mode" za sve izmene na bazi podataka. Cilj je osigurati da se svaka promena može bezbedno primeniti, verifikovati i, u slučaju problema, vratiti na prethodno stanje.

## 1. Definisanje Izvora Istine (Dokumentacija)

Pre bilo kakvog koda, mora postojati Specifikacija.

**Lokacija**: `docs/specs/YYYY-MM-DD_NazivZahteva.md`
**Format**:

```markdown
# Specifikacija: [Naziv]

## 1. Data Model Changes
| Tabela | Akcija | Opis |
|--------|--------|------|
| Questions | INSERT | Dodavanje pitanja za osiguranje stakla |

## 2. Očekivane Vrednosti (Verification Source)
| Upit | Očekivani Rezultat |
|------|--------------------|
| `SELECT COUNT(*) FROM Questions WHERE QuestionLabel='GlassCoverage'` | `1` |
```

## 2. Pre-Flight Check (Trenutno Stanje)

Pre pisanja INSERT/UPDATE skripti, proverite da li podaci već postoje ili su u konfliktu.

```sql
-- Check Script (Run before Deploy)
SELECT * FROM Questions WHERE QuestionLabel = 'GlassCoverage';
-- Ako vrati redove, STOP! Deploy će failovati ili duplirati podatke.
```

## 3. Rollback Strategija (The Safety Net)

**PRAVILO**: Za svaku `DEPLOY_X.sql` skriptu, mora postojati `ROLLBACK_X.sql`.

### Template: `ROLLBACK_FeatureName.sql`

```sql
BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Obriši podatke obrnutim redosledom
    
    -- Brisanje mapiranja
    DELETE FROM Questionnaires WHERE QuestionID IN (SELECT QuestionID FROM Questions WHERE QuestionLabel = 'GlassCoverage');
    
    -- Brisanje odgovora
    DELETE FROM PredefinedAnswers WHERE QuestionID IN (...);
    
    -- Brisanje pitanja
    DELETE FROM Questions WHERE QuestionLabel = 'GlassCoverage';

    COMMIT TRANSACTION;
    PRINT 'Rollback successful.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error during rollback: ' + ERROR_MESSAGE();
END CATCH;
```

## 4. Deploy & Verify (Atomic Execution)

Deploy skripta mora biti atomska i sama verifikovati svoj uspeh.

### Template: `DEPLOY_FeatureName.sql`

```sql
BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Pre-deployment check (Fail fast)
    IF EXISTS (SELECT 1 FROM Questions WHERE QuestionLabel = 'GlassCoverage')
    BEGIN
        THROW 51000, 'Podaci vec postoje!', 1;
    END

    -- 2. Execution
    INSERT INTO Questions (...) VALUES (...);
    DECLARE @NewID INT = SCOPE_IDENTITY();

    -- 3. In-Transaction Verification
    IF NOT EXISTS (SELECT 1 FROM Questions WHERE QuestionID = @NewID)
    BEGIN
        THROW 51001, 'Insert failed validation!', 1;
    END

    -- 4. Final Commit
    COMMIT TRANSACTION;
    PRINT 'Deploy successful.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Deploy FAILED. Transaction rolled back.';
    PRINT ERROR_MESSAGE();
END CATCH;
```

## Checklist za Deploy

- [ ] Specifikacija kreirana u `docs/specs/`
- [ ] Pre-flight check urađen (baza je čista)
- [ ] `ROLLBACK` skripta kreirana i testirana (u dev okruženju)
- [ ] `DEPLOY` skripta sadrži transakciju i validaciju
- [ ] Deploy izvršen
- [ ] Post-deploy verifikacija (koristeći upite iz Specifikacije)
