# Lessons Learned & Best Practices

Ovaj dokument sumira najčešće greške i naučene lekcije tokom razvoja i održavanja WIWA Questionnaire modula.

## 1. Arhitektura i Razdvajanje Odgovornosti

### Problem: Mešanje Logike (Data vs Rules)
**Greška**: Pokušaj da se sva poslovna pravila implementiraju kroz strukturu upitnika (npr. komplikovano grananje samo da bi se došlo do "tačne" premije).
**Rešenje**: 
- **Upitnik** služi samo za **prikupljanje podataka** (Facts).
- **UW Modul** (poseban sistem pravila) služi za evaluaciju rizika i određivanje premije.
- **Computed Questions** treba koristiti za *deriviranje podataka* (npr. Kategorija Objekta) koji su potrebni *odmah* korisniku, ne za finalnu kalkulaciju cene.

### Problem: Dumb Renderer
**Greška**: Oslanjanje na hard-kodovanu logiku u frontendu.
**Rešenje**: Renderer mora biti "glup" (Dumb Renderer). Sva logika mora doći kroz JSON konfiguraciju (npr. `rules`, `branching`). Ako renderer mora da zna "ako je pitanje X onda uradi Y", to je arhitektonski dug.

## 2. Baza Podataka i Modeliranje

### Reference Table Constraints
**Greška**: Kreiranje iste reference tabele više puta ili nedostatak unique constraint-a.
**Rešenje**: 
- Referentne tabele (lookups/matrices) se vezuju za `QuestionnaireType`.
- Uvek proveriti da li tabela već postoji u `QuestionnaireTypeReferenceTables` pre insertovanja n-ti put.
- Koristite `QuestionReferenceColumns` za mapiranje pitanja na kolone matrice.

### SpecificQuestionTypes
**Greška**: Nekorišćenje `SpecificQuestionTypeID` za specijalne namene.
**Rešenje**:
- `1` = AlwaysVisible (Default)
- `2` = ConditionallyVisible (Zavisi od Parent odgovora)
- `3` = Computed (Izračunava se, ReadOnly)
- `4` = Hidden (Tehnička polja)

### Code vs AnswerID
**Greška**: Oslanjanje na `PredefinedAnswerID` u logici integracije.
**Rešenje**: Uvek se oslanjati na **`Code`** kolonu u `PredefinedAnswers`.
- `Code` mora odgovarati ID-ju ili Value-u u eksternoj matrici/šifarniku.
- `PredefinedAnswerID` je interni sintetički ključ i može se menjati replikacijom/migracijom.

## 3. Computed Questions

### Definisanje
- **Parent Pitanje**: Mora biti `ReadOnly = 1`, `SpecificQuestionTypeID = 3` (Computed).
- **Child Pitanja**: Moraju imati `ParentQuestionID` setovan na ID Computed pitanja.
- **Odgovori**: Parent pitanje mora imati definisane *sve moguće* rezultate kalkulacije kao `PredefinedAnswers`.

### Matrice
- **Inputi**: Child pitanja moraju imati `Code` vrednosti koje se poklapaju sa vrednostima u kolonama matrice.
- **Output**: Rezultat lookup-a u matrici mora se poklapati sa `Code` vrednošću jednog od odgovora Parent pitanja.

## 4. Workflow i Proces

### Redosled Izmena
1. **Analiza (BA)**: Prvo definiši tabelu/matricu na papiru.
2. **Validacija (DBA)**: Proveri postojeće šifarnike. Nemoj praviti "MaterijalZida2" ako postoji "MaterijalZida".
3. **Implementacija**:
   - Prvo `Questions` i `PredefinedAnswers`.
   - Zatim `QuestionnaireTypeReferenceTables` i `QuestionReferenceColumns` za computed logiku.
   - Na kraju mapiranje u `Questionnaires`.

### JSON Generisanje
- Uvek validiraj generisani JSON *pre* puštanja u renderer.
- Proveri da li `rules` sekcija sadrži definiciju za svaki computed question.
