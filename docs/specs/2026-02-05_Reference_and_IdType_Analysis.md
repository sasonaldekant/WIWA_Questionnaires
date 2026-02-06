# BA-DBA Analiza Sesija: Flow Builder Reference i Validacija

## 1. Analiza Zahteva
- **Cilj:** Omogućiti izbor referentnih tabela i kolona u Flow Builder-u i validaciju jedinstvenosti para (QuestionnaireType, IdentificatorType).
- **Korisnički Input:** "Referentne tabele su u QuestionnaireTypeReferenceTables a referentne kolone u QuestionReferenceColumns."
- **Nalog:** Proveriti realno stanje baze pre implementacije.

## 2. DBA Analiza Stanja Baze (Dump: 03-Feb-2026)

### A. Referentni Podaci
**Stanje:**
- Postoji tabela `QuestionnaireTypeReferenceTables` (PK: `QuestionnaireTypeReferenceTableID`, `QuestionnaireTypeID`, `TableName`).
- Postoji tabela `QuestionReferenceColumns` (PK: `QuestionReferenceColumnID`, `QuestionID`, `QuestionnaireTypeReferenceTableID`, `ReferenceColumnName`).
- Tabela `Questions` **NEMA** kolone `ReferenceTable` ni `ReferenceColumn`.

**Zaključak:**
- Podaci o referencama se ne smeju čuvati direktno u `Questions` tabeli.
- Potrebno je prvo definisati tabelu za tip upitnika, a zatim vezati pitanje za tu definiciju.

### B. Questionnaire Identificator Type
**Stanje:**
- Tabela `Questionnaires` (PK: `QuestionnaireID`, `QuestionnaireTypeID`, `QuestionID`) **NEMA** kolonu `QuestionnaireIdentificatorTypeID`.
- Tabela `QuestionnaireTypes` **NEMA** FK ka `QuestionnaireIdentificatorTypes`.
- Tabela `QuestionnaireIdentificatorTypes` postoji, ali je izolovana od definicije upitnika.

**Zaključak:**
- Trenutno nije moguće čuvati informaciju o `IdentificatorType` uz definiciju Upitnika (`Questionnaire` tabela) bez izmene šeme baze.
- Validacija jedinstvenosti para (QuestionnaireType + IdentificatorType) nije moguća na nivou baze jer taj par ne postoji u jednoj tabeli.

## 3. Plan Implementacije (Korigovan)

### Backend (`FlowController`)
1.  **Reference Tables:**
    - Nakon čuvanja pitanja, proći kroz sva pitanja koja imaju ref podatke.
    - Za svako pitanje (Opciono):
        - Korisnik može (ali ne mora) da unese "Reference Table" i "Reference Column".
        - Ako korisnik unese vrednost za "Reference Table":
            - Proveriti da li postoji u `QuestionnaireTypeReferenceTables` za dati Tip.
            - Ako ne postoji, **kreirati novi zapis** sa unetim imenom.
            - Zatim kreirati zapis u `QuestionReferenceColumns` vezujući Pitanje i tu (postojeću ili novu) Ref Tabelu.
    - **Revert:** Ukloniti pokušaje čuvanja u `Question` entity.

2.  **Identificator Type:**
    - **STOP:** Ukloniti kod koji pokušava da snimi `QuestionnaireIdentificatorTypeID` u `Questionnaires` tabelu jer kolona ne postoji.
    - Privremeno onemogućiti perzistenciju ovog podatka dok se baza ne nadogradi (ili dok DBA ne odobri izmenu). Validacija na frontendu može ostati (kao upozorenje), ali backend ne može da je sprovede nad bazom.

### Frontend
- Korisnički interfejs za izbor tabela/kolona je dobar, ali se podaci šalju kao `Node Data`.
- Backend mora te podatke izvući i snimiti u relacione tabele.

## 4. Akcija
- [x] Revert `Questionnaire` entity changes.
- [x] Ažurirati `FlowController` da ispravno rukuje referencama.
- [x] Ukloniti nepostojeći kod za Identificator Type.
