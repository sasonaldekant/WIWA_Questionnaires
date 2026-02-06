# PRAVILA I PROVERE - KOMPLETNA SPECIFIKACIJA

## Sadržaj
1. [UW Pravila](#uw-pravila)
2. [AML Pravila](#aml-pravila)
3. [Pravila za Dopunska Pokrića](#pravila-za-dopunska-pokrica)
4. [Pravila Ugovaranja](#pravila-ugovaranja)
5. [Validacione Poruke](#validacione-poruke)
6. [Korekcije i Doplatci](#korekcije-i-doplatci)
7. [Statusi Ponude](#statusi-ponude)
8. [Dokumentacija - Zahtevi](#dokumentacija---zahtevi)

---

## UW Pravila

### 1. Segmentacija UW Pravila Prema Osiguranoj Sumi

| Proizvod | OS (EUR) | Karenca | Dopunski Rizik | Upitnik/Izjava |
|----------|----------|---------|----------------|----------------|
| Svi sem MAK/Sinergija | > 3.001 | 0 (bez izbora) | Bilo koji  | Veliki ili Skraćeni upitnik |
| Svi sem MAK/Sinergija | ≤ 3.000 | 1 godina | U0 (bez dopunskih) | **IZJAVA** |
| Svi sem MAK/Sinergija | ≤ 3.000 | 0 godina | Slobodan izbor | Veliki ili Skraćeni upitnik |
| IK (jednogodišnji) | Bilo koja | N/A* | Bilo koji | Veliki ili Skraćeni upitnik |

**Napomena**: \* Za jednogodišnje ugovore karenca nije primenljiva

### 2. Lekarski Pregledi - Pravila

#### Prema Osiguranoj Sumi i Pristupnoj Starosti

**EUR Verzija**:

| Osigurana Suma (EUR) | Pristupna Starost 14-50 | Pristupna Starost 51-75 | Poruka |
|----------------------|------------------------|------------------------|--------|
| do 20.000 | / | / | - |
| 20.001 - 40.000 | / | LP 1 | "Ponuda zahteva da osiguranik obavi Lekarski pregled broj 1" |
| 40.001 - 80.000 | LP 1 | LP 2 | "Ponuda zahteva da osiguranik obavi Lekarski pregled broj 1" ili "...broj 2" |
| 80.001 - 160.000 | LP 3 | LP 3 | "Ponuda zahteva da osiguranik obavi Lekarski pregled broj 3" |
| preko 160.001 | LP 4 | LP 4 | "Ponuda zahteva da osiguranik obavi Lekarski pregled broj 4" |

**RSD Verzija**:

| Osigurana Suma (RSD) | Pristupna Starost 14-50 | Pristupna Starost 51-75 | Poruka |
|----------------------|------------------------|------------------------|--------|
| do 2.500.000 | / | / | - |
| 2.500.001 - 5.000.000 | / | LP 1 | "Ponuda zahteva da osiguranik obavi Lekarski pregled broj 1" |
| 5.000.001 - 10.000.000 | LP 1 | LP 2 | "Ponuda zahteva da osiguranik obavi Lekarski pregled broj 1" ili "...broj 2" |
| 10.000.001 - 20.000.000 | LP 3 | LP 3 | "Ponuda zahteva da osiguranik obavi Lekarski pregled broj 3" |
| preko 20.000.001 | LP 4 | LP 4 | "Ponuda zahteva da osiguranik obavi Lekarski pregled broj 4" |

**Napomena**: LP = Lekarski Pregled

**Kalkulacija Ukupne Obaveze Osiguravača**:
```
Ukupna Obaveza 1 = SUM(Suma pod rizikom 1 polisa u KING-u) + Suma pod rizikom 1 nove ponude u WIWA-i

Suma pod rizikom 1 =
  - MAK/Sinergija: OS za smrt - ugovorena premija
  - Ostali proizvodi: OS za smrt
```

### 3. Odobrenje Reosiguravača

**Pravilo**:
```
Ukupna Obaveza 2 = SUM(Suma pod rizikom 2 polisa u KING-u) + Suma pod rizikom 2 nove ponude u WIWA-i

Suma pod rizikom 2 = OS za smrt + OS smrti usled nezgode + OS nastupanje teže bolesti

IF Ukupna Obaveza 2 > 150.000 EUR THEN
    Poruka = "Ponuda zahteva odobrenje Reosiguravača"
    Action = Šalji reosiguravaču
END IF
```

**Filtriranje Polisa u KING-u**:
- Grana osiguranja = 5 (Life, Rente, UL)
- Status polise: Z01, Z02

### 4. Provera Šteta

**Pravilo**:
```
IF EXISTS (Šteta za osiguranika IN (TBHI, Nezgoda, DZO proizvod 107, 105, 103, 101)) THEN
    Poruka = "Za navedenog osiguranika postoji šteta u sistemu"
    Action = Omogući dugme "Pregled šteta"
END IF
```

**Isključenja**: Štete po predujmu

---

##AML Pravila

### 1. Rizik Prema Visini Premije

#### A. Regularna Premija

| Godišnja Premija (EUR) | Godišnja Premija (RSD) | Nivo Rizika | Poruka | Akcija |
|------------------------|------------------------|-------------|--------|--------|
| < 2.500 | < 300.000 | Nizak | - | Nastavi |
| 2.500 - 4.999 | 300.000 - 599.999 | **Srednji** | "Po visini premije klijent spada u Srednji rizik" | Šalji AML-u |
| ≥ 5.000 | ≥ 600.000 | **Visok** | "Po visini premije klijent spada u Visok rizik" | Šalji AML-u |

**Kalkulacija**:
```
Ukupna Godišnja Premija = SUM(Godišnje premije polisa u KING-u sa statusom Z01, Z02) + Godišnja premija nove ponude u WIWA-i
```

#### B. Jednokratna Premija

| Jednokratna Premija (EUR) | Nivo Rizika | Poruka | Akcija |
|---------------------------|-------------|--------|--------|
| < 15.000 | Nizak | - | Nastavi |
| 15.000 - 99.999 | **Srednji** | "Po visini premije klijent spada u Srednji rizik" | Šalji AML-u |
| ≥ 100.000 | **Visok** | "Po visini premije klijent spada u Visok rizik" | Šalji AML-u |
| ≥ 15.000 + trajanje 1 god | **Visok** | "Po visini premije klijent spada u Visok rizik" | Šalji AML-u |

**Kalkulacija**:
```
Ukupna Jednokratna Premija = SUM(Jednokratne premije polisa u KING-u sa statusom Z01, Z02) + Jednokratna premija nove ponude u WIWA-i
```

### 2. Obrazac za Procenu Rizika

| Ukupno Bodova | Nivo Rizika | Oznaka | Poruka | Akcija |
|---------------|-------------|--------|--------|--------|
| 0 - 5 | Nizak | N | - | Nastavi |
| 6 - 9 | **Srednji** | S | "Na osnovu obrasca za procenu rizika klijent spada u Srednji rizik" | Šalji AML-u |
| ≥ 10 | **Visok** | V | "Na osnovu obrasca za procenu rizika klijent spada u Visok rizik" | Šalji AML-u |

### 3. Upitnik za Funkcionera

**Pravilo**:
```
IF (Pitanje 1 = "Da" OR Pitanje 2 = "Da" OR Pitanje 3 = "Da") THEN
    Poruka = "Postoje pozitivni odgovori na Upitniku za funkcionera"
    Action = Šalji AML-u
END IF
```

### 4. Istorija Klijenta

**Pravilo**:
```
IF EXISTS (Polisa sa Visok Rizik marker za ugovarača/osiguranika) THEN
    Poruka = "Klijent je po prethodnim ugovorima Visok rizik"
    Action = Notifikuj UW i AML
END IF
```

### 5. KOD3 - Blokiranje Provizije

**Pravilo**:
```
IF EXISTS (
    Polisa sa statusom S04, S07, S08, S11 (storno/redukcija/otkup)
    AND Datum storno/redukcije/otkupa + 365 dana > Datum početka osiguranja nove ponude
    AND Ugovarač/Osiguranik nova ponuda = Ugovarač/Osiguranik stornirana polisa
    AND Tarifa NOT IN ('IK', 'IK2', 'IK-S')
    AND NOT (Status polise = S54) -- Konverzija
) THEN
    Poruka = "Provizija će biti blokirana jer ugovarač/osiguranik ima ugovor u statusu storno/redukcija/otkup"
    Action = Postavi KOD3
END IF
```

---

## Pravila za Dopunska Pokrića

### 1. Maksimalne Osigurane Sume

| Dopunsko Pokriće | Max OS (EUR) | Max OS (RSD) | Pravilo Provere |
|------------------|--------------|--------------|-----------------|
| Lom kosti | 400 | 50.000 | Kumulativ po osiguraniku |
| Maligne bolesti | 30.000 | 3.750.000 | Kumulativ po osiguraniku |
| Hirurške intervencije | 20.000 | 2.500.000 | Kumulativ po osiguraniku |

**Kalkulacija Kumulativa**:
```
Kumulativ = SUM(OS za dopunsko pokriće na polisama u KING-u sa status Z01) + OS za dopunsko pokriće na novoj ponudi

Filtriranje polisa:
- Grana osiguranja = 5
- Status = Z01
- Osiguranik (JMBG) = Osiguranik na novoj ponudi
```

### 2. Poruke za Dopunska Pokrića

#### Lom Kosti

| Situacija | Poruka |
|-----------|--------|
| Kumulativ = 400 EUR (50.000 RSD) | "Za navedenog osiguranika rizik Lom kosti nije moguće ugovoriti zbog iscrpljenja maksimalne osigurane sume" |
| Kumulativ < 400 EUR (50.000 RSD) | "Za navedenog osiguranika rizik Lom kosti je moguće ugovoriti do iznosa [Preostali iznos] a do iscrpljenja maksimalne osigurane sume" |

**Izračun preostalog iznosa**:
```
Preostalo = Max OS - Kumulativ
```

---

## Pravila Ugovaranja

### 1. Karenca

| Proizvod | Osigurana Suma | Karenca Opcije | Default |
|----------|----------------|----------------|---------|
| Svi sem Senior i D tarife | > 3.001 | 0 (bez mogućnosti izmene) | 0 |
| Svi sem Senior, D tarife, IK | ≤ 3.000 | 0 ili 1 | 0 |
| Senior i D tarife | Bilo koja | N/A - Nema polja | N/A |
| IK (jednogodišnji) | Bilo koja | N/A* | N/A |

**Napomena**: \* Za jednogodišnje ugovore karenca nije primenljiva

**Poruka pri izboru Karenca = 1**:
> "Izborom karence od 1 godine, za slučaj smrti usled bolesti, Ugovarač nema obavezu popunjavanja Upitnika o zdravstvenom stanju/Izjave. U ovom slučaju Osiguravač nema obavezu da vrati uplaćenu premiju"

**Klauzula** (dodaje se na ponudu):
> "Za slučaj smrti usled bolesti u prvoj godini osiguranja, Osiguravač nema obavezu isplate osigurane sume niti povrata uplaćene premije."

### 2. Segmentacija Prava Štampe Ponude

#### Komercijalna Prodaja

| Nivo | Max OS za Smrt (EUR) | Max OS za Smrt (RSD) | Pravo |
|------|----------------------|----------------------|-------|
| Agent | OsSumSmrt_A_Eur | OsSumSmrt_A_RSD | Direktna štampa |
| Menadžer | OsSumSmrt_M_Eur | OsSumSmrt_M_RSD | Odobrenje štampe |

**Primer vrednosti** (potrebno definisati):
- OsSumSmrt_A_Eur = 100.000 EUR
- OsSumSmrt_M_Eur = 300.000 EUR

#### Agencije

**Pravilo**: Nema ograničenja u pravu štampe ponude

**Poruke**:
```
IF (OS za smrt > Limit Agenta AND Prodajni kanal = Komercijalna prodaja) THEN
    Poruka Agentu = "Zbog visine osigurane sume potrebno je odobrenje menadžera"
    Mail Menadžeru = "Zbog visine osigurane sume potrebno je odobrenje menadžera za ponudu broj  [BrojPonude]"
END IF
```

---

## Validacione Poruke

### 1. Tab Partneri - Unos Podataka

| Polje | Pravilo | Poruka |
|-------|---------|--------|
| Ime, Prezime, Adresa | Prvo slovo veliko, ostala mala | Automatska korekcija |
| Kratak opis zanimanja | Obavezno | Standardna validacija |
| Saglasnost za dospelost | Omogućiti više opcija (SMS, Email, Pošta) istovremeno | - |
| Vrsta ličnog dokumenta | Obavezno | Standardna validacija |
| Broj ličnog dokumenta | Obavezno | Standardna validacija |
| Naziv izdavaoca | Obavezno | Standardna validacija |
| Mesto izdavanja | Obavezno | Ne prenosi se u KING |
| Datum izdavanja | Obavezno | Standardna validacija |
| Datum isteka | Obavezno | Standardna validacija |
| Marketinška saglasnost | Boolean, default Ne | - |

#### Pravna Lica - Dodatna Polja

| Polje | Pravilo | Poruka |
|-------|---------|--------|
| Stvarni vlasnik | String, obavezno | Standardna validacija |
| Mesto rođenja stvarnog vlasnika | String, obavezno | Standardna validacija |
| Udeo u vlasništvu (%) | Decimal, obavezno | Standardna validacija |

### 2. Tab Ponuda

| Polje | Pravilo | Poruka |
|-------|---------|--------|
| Srodstvo (korisnik za doživljenje) | Obavezno (svi proizvodi) | Standardna validacija |
| Državljanstvo (korisnik za doživljenje) | Obavezno (svi proizvodi) | Standardna validacija |

### 3. Tab Upitnik

**Validacija pri preskakanju pitanja**:
> "Niste odgovorili na pitanje broj [X]"

---

## Korekcije i Doplatci

### 1. Korekcije Zbog Zanimanja

**Tabela**: Stepen uvećanog rizika zbog obavljanja određenog zanimanja

| Oblast | Zanimanje | Život (‰ OS) | MAK/Sinergija (‰ RK) | Nezgoda/Hirurške (% premije) | Akcija |
|--------|-----------|--------------|----------------------|------------------------------|--------|
| Građevinarstvo | Poslovi na građevinama, tunelima, dalekovodima... | 0.5 | 15 | - | Korekcija |
| Istraživači | U neispitana područja | 2.5 | 100 | - | Korekcija |
| Istraživači | Planine >6.000m, Arktik, tropi | 4.5 | 200 | - | Korekcija |
| Kaskaderi | - | 5.5 | 400 | - | Korekcija |
| Letačko osoblje | Lakih letelica, padobranci | Odbiti | Odbiti | Odbiti | Odbijanje |
| Lov i rad s životinjama | Čuvar divljih životinja | 2 | 50 | - | Korekcija |
| Lov i rad s životinjama | Dresiranje divljih životinja | 9 | 350 | - | Korekcija |
| Obezbeđenje | Obezbeđenje objekata | 0.7 | 20 | - | Korekcija |
| Obezbeđenje | Obezbeđenje novca i vrednosti | 2 | 75 | - | Korekcija |
| Obezbeđenje | Lična pratnja i zaštita | Odbiti | Odbiti | Odbiti | Odbijanje |
| Podmornice | Posada | 1 | 50 | - | Korekcija |
| Pomorska plovidba | Posada brodova | 0.7 | 20 | - | Korekcija |
| Rad sa gasovima/eksplozivom | Laboranti, pirotehničar | 0.7 | 20 | - | Korekcija |
| Rad sa gasovima/eksplozivom | Proizvodnja baruta, municije | 1 | 30 | - | Korekcija |
| Rad sa gasovima/eksplozivom | Rad sa zapaljivim materijama | 2 | 100 | - | Korekcija |
| Rad sa gasovima/eksplozivom | Rad sa eksplozivom, miner | 3 | 150 | - | Korekcija |
| Rad sa radioaktivnim materijama | - | Odbiti | Odbiti | Odbiti | Odbijanje |
| Ronioci | - | Odbiti | Odbiti | Odbiti | Odbijanje |
| Rudarstvo | Rudari i radnici na površinskom/jamskom kopu | 0.5 | 10 | - | Korekcija |
| Speleolozi | - | Odbiti | Odbiti | Odbiti | Odbijanje |
| Transport | Prevoz eksplozivnih materija | 2.5 | 150 | - | Korekcija |
| Transport | Prevoz gasova, zapaljivih materija | 2 | 100 | - | Korekcija |
| Vatrogasci | - | 0.7 | 20 | - | Korekcija |
| Vojska i policija | Specijalne jedinice, piloti, garde | Odbiti | Odbiti | Odbiti | Odbijanje |

**Poruke**:
- Korekcija: "Zbog rizika zanimanja moguća je korekcija premije"
- Odbijanje: "Zbog rizika zanimanja moguće je odbijanje ponude. Za eventualno razmatranje prijema u osiguranje potrebno je priložiti Saglasnost osiguranika za isključenje obaveze osiguravača ukoliko osigurani slučaj nastane za vreme obavljanja redovnog zanimanja"

### 2. Korekcije Zbog Sporta

**Tabela**: Stepen uvećanog rizika zbog bavljenja određenim sportom

| Razred Opasnosti | Život (‰ OS) | MAK/Sinergija (‰ RK) | Nezgoda/Hirurške (% premije) |
|------------------|--------------|----------------------|------------------------------|
| I | 2.4 | 80 | - |
| II | 2.9 | 120 | - |
| III | 4.6 | 240 | - |
| IV | 5 | 360 | - |
| V | 7.3 | 520 | - |
| VI | Odbiti | Odbiti | Odbiti |

**Poruke**:
- Korekcija: "Zbog bavljenja određenim sportom moguća je  korekcija premije"
- Odbijanje: "Zbog bavljenja određenim sportom moguće je odbijanje ponude. Za eventualno razmatranje prijema u osiguranje potrebno je priložiti Saglasnost osiguranika za isključenje obaveze osiguravača ukoliko osigurani slučaj nastane za vreme bavljenja određenim sportom"

### 3. Korekcije Zbog Alkohola

**Tabela**: Stepen uvećanog rizika konzumiranja alkohola

| Dnevna Količina | Povećanje Starosti (god) - Život | Hirurške Int. (% povećanje) | Teže Bolesti (god) |
|-----------------|----------------------------------|-----------------------------|--------------------|
| do 1 lit. piva ILI do 0.5 lit. vina ILI do 0.1 lit. žestokog | 0 | 0 | 0 |
| do 1.5 lit. piva ILI do 0.75 lit. vina ILI do 0.15 lit. žestokog | 5 | 50 | 5 |
| do 2 lit. piva ILI do 1 lit. vina ILI do 0.2 lit. žestokog | 10 | 100 | 10 |
| preko 2 lit. piva ILI preko 1 lit. vina ILI preko 0.2 lit. žestokog | Odbiti | Odbiti | Odbiti |

**Poruke**:
- Korekcija: "Zbog konzumiranja alkohola moguća je korekcija premije"
- Odbijanje: "Zbog konzumiranja alkohola moguće je odbijanje ponude"

### 4. Korekcije Zbog Duvana

**Tabela**: Stepen uvećanog rizika zbog konzumiranja cigareta/duvana

| Dnevna Količina | Povećanje Starosti (god) - Život | Teže Bolesti (god) |
|-----------------|----------------------------------|--------------------|
| manje od 20 cigareta ILI manje od 20 gr. duvana | 0 | 0 |
| do 30 cigareta ILI do 30 gr. duvana | 5 | 5 |
| do 40 cigareta ILI do 40 gr. duvana | 10 | 10 |
| preko 40 cigareta ILI preko 40 gr. duvana | Odbiti | Odbiti |

**Poruke**:
- Korekcija: "Zbog konzumiranja duvana moguća je korekcija premije"
- Odbijanje: "Zbog konzumiranja duvana moguće je odbijanje ponude"

### 5. Korekcije Zbog Droga

**Pravilo**:
```
IF Konzumiranje_Droga = "Da" THEN
    Action = Odbiti
    Poruka = "Zbog konzumiranja droga moguće je odbijanje iz osiguranja"
END IF
```

### 6. Korekcije Zbog BMI

**Pravilo**: UW modul vrši klasifikaciju na osnovu izračunate BMI vrednosti.
**Referenca**: Pragovi i korekcije su definisani u `veliki_upitnik_tabela.xlsx`.

**Poruke / Akcije (UW)**:
- **Korekcija**: Ako je BMI u opsegu rizika -> Primeniti korekciju premije.
- **Odbijanje**: Ako je BMI van dozvoljenog opsega -> Odbiti ponudu.

---

## Statusi Ponude

### Kompletna Lista Statusa

| Status | Opis | Prelaz Iz | Prelaz U |
|--------|------|-----------|----------|
| U izradi | Agent kreira ponudu | - | Poslato Underwriteru, Odobrena štampa ponude |
| Poslato Underwriteru | Agent poslao UW na pregled | U izradi, Vraćeno na ispravku, Dostavljena dopuna | Ponuda na odobrenju UW |
| Odobrena štampa ponude | Menadžer odobrio štampu | U izradi | Poslato Underwriteru |
| Odbijena od strane WSO | Menadžer odbio štampu | U izradi | U izradi (ostaje) |
| Odobrenje popusta | UW odobrio popust | Poslato Underwriteru | U izradi (za finalizaciju) |
| Ponuda na odobrenju UW | UW pregleda ponudu | Poslato Underwriteru | Tražena dopuna od UW, Na odobrenju kod Reosiguravača, Ponuda poslata Lekaru cenzoru, Ponuda poslata AML-u, Primljena u osiguranje, Odbijena |
| Tražena dopuna od UW | UW traži dodatnu dokumentaciju | Ponuda na odobrenju UW | Dostavljena dopuna |
| Na odobrenju kod Reosiguravača | Čeka odobrenje reosiguravača | Ponuda na odobrenju UW | Odobreno od reosiguravača, Odbijeno |
| Ponuda poslata Lekaru cenzoru | Na pregledu kod lekara cenzora | Ponuda na odobrenju UW | Tražena dopuna od Lekara cenzora, Mišljenje lekara cenzora |
| Tražena dopuna od Lekara cenzora | Lekar zahteva dopunu | Ponuda poslata Lekaru cenzoru | Dostavljena dopuna |
| Mišljenje lekara cenzora | Lekar dao mišljenje | Ponuda poslata Lekaru cenzoru, Dostavljena dopuna | Ponuda na odobrenju UW |
| Ponuda poslata AML-u | Na AML pregledu | Ponuda na odobrenju UW | Tražena dopuna od AML-a, Odobreno od AML, Odbijeno od AML-a |
| Tražena dopuna od AML-a | AML zahteva dopunu | Ponuda poslata AML-u | Dostavljena dopuna |
| Odobreno od AML | AML odobrio | Ponuda poslata AML-u, Dostavljena dopuna | Ponuda na odobrenju UW |
| Odbijeno od AML-a | AML odbio | Ponuda poslata AML-u | Odbijena (konačno) |
| Dostavljena dopuna | Agent dostavio traženu dopunu | Tražena dopuna od UW, Tražena dopuna od Lekara cenzora, Tražena dopuna od AML-a | Ponuda na odobrenju UW, Ponuda poslata Lekaru cenzoru, Ponuda poslata AML-u |
| Vraćeno na ispravku | UW vratio na ispravku | Ponuda na odobrenju UW | U izradi, Poslato Underwriteru |
| Primljena u osiguranje | Finalno odobrena | Ponuda na odobrenju UW | Izdata polisa |
| Odbijena | Konačno odbijena | Ponuda na odobrenju UW, Odbijeno od AML-a | - |
| Odustanak klijenta | Klijent odustao | Bilo koji status | - |
| Izdata polisa | Polisa kreirana u KING-u | Primljena u osiguranje | - |

### Dijagram Toka Statusa

```
U izradi → [Odobrena štampa (opciono)] → Poslato Underwriteru → Ponuda na odobrenju UW
    ↓                                                                   ↓
Odbijena od WSO (ostaje u izradi)                                      →  [Tražena dopuna od UW → Dostavljena dopuna] ↺
                                                                        →  [Na odobrenju Reosiguravača → Vraćeno]
                                                                        →  [Ponuda Lekaru cenzoru → Mišljenje] → Nazad UW
                                                                        →  [Ponuda AML-u → Odobreno/Odbijeno] → Nazad UW / Odbijena
                                                                        →  [Vraćeno na ispravku] → U izradi / Poslato UW
                                                                        →  Primljena u osiguranje → Izdata polisa
                                                                        →  Odbijena
```

---

## Dokumentacija - Zahtevi

### 1. Obavezna Dokumentacija po Proizvodu

**Napomena**: Potrebno pribaviti dokument "Spisak obaveznih dokumenata za razduženje" prema specifikaciji.

### 2. Dodatna Dokumentacija Prema Odgovorima

| Upitnik | Uslov | Dokumentacija |
|---------|-------|---------------|
| Veliki upitnik | Pozitivan odgovor na medicinska pitanja (1-3) | Kompletna medicinska dokumentacija prema bolesti |
| Veliki upitnik | BMI van opsega | Opcionalno: medicinski izveštaj |
| Veliki upitnik | Sport razreda VI | Saglasnost za isključenje obaveze osiguravača |
| Veliki upitnik | Zanimanje sa oznakom "Odbiti" | Saglasnost za isključenje obaveze osiguravača |
| Skraćeni upitnik | Pitanje 1 = "Da" | Kompletna medicinska dokumentacija |
| Skraćeni upitnik | Pitanje 2 = "Da" | Kompletna medicinska dokumentacija o ispitivanju |
| Skraćeni upitnik | Pitanje 5 = "Da" (visok rizik) | Opcionalno: Saglasnost za isključenje |
| Upitnik za funkcionera | Bilo koje pitanje 1-3 = "Da" | Original potpisan upitnik poslat poštom SPNFT |
| - | Lekarski pregled zahteva LP1, LP2, LP3, LP4 | Izveštaj lekara nakon pregleda |

### 3. Upload Dokumentacije

**Lokacije**:
- **Tab Štampa**: Upload ponude i prateće dokumentacije
- **Tab Upitnik za funkcionera**: Upload potpisanog upitnika
- **Tab AML**: AML Upload dodatne dokumentacije

**Format**: PDF, JPG, PNG

**Maksimalna veličina**: (Potrebno definisati)

### 4. Prenos u DMS

**Automatski prenos** nakon finalnog odobrenja:
- Kompletnа ponuda
- Sva uploadovana dokumentacija
- Izjave/Upitnici
- Mišljenje lekara cenzora
- AML dokumenti
- Obrazac za procenu rizika

---

## Dodatne Napomene

### Konverzija Valuta

**Pravilo**:
```
EUR_iznos = RSD_iznos / 125.00
RSD_iznos = EUR_iznos * 125.00
```

### Filtriranje Polisa u KING-u

**Standardni filteri** za sve provere:
- **Grana osiguranja**: 5 (Life, Rente, UL)
- **Statusi**:
  - Z01 - Aktivna polisa
  - Z02 - Polisa u izmeni  
  - S04 - Storno
  - S07 - Redukcija
  - S08 - Otkup
  - S11 - Ostalo

**Filtriranje po osobi**:
- **JMBG** (za fizička lica)
- **Matični broj** (za pravna lica)

### Automatske Notifikacije

**Emails** se šalju u sledećim slučajevima:
1. Agent → UW: "Pоnuda broj XXXXX poslata Underwriteru"
2. UW → Agent: "Tražena dopuna za ponudu broj XXXXX"
3. UW → Agent: "Ponuda broj XXXXX vraćena na ispravku"
4. Menadžer → Agent: "Ponuda broj XXXXX odobrena za štampu" / "...odbijena"
5. UW → Lekar Cenzor: "Ponuda broj XXXXX poslata na pregled"
6. UW → AML: "Ponuda broj XXXXX poslata na AML pregled"
7. AML → UW: "Ponuda broj XXXXX odobrena od AML" / "...odbijena" / "...traži dopunu"
8. UW → Agent: "Ponuda broj XXXXX primljena u osiguranje"
9. UW → Agent: "Ponuda broj XXXXX odbijena iz osiguranja"

**Podsećanja** - Automatska notifikacija na 2 dana:
- Agent nije dostavio traženu dopunu
- Šalje se agentu, menadžeru, i strateski@mail.co.rs (za agencije)

---

---

## Referencirana Dokumentacija

Kompletne liste i tačni tekstovi poruka se nalaze u:
1. **Validacione Poruke**: `veliki_upitnik_poruke.docx`
2. **Korekcije i Sportovi**: `Sports.xlsx`
3. **Logika Pitanja**: `veliki_upitnik_tabela.xlsx`

*Status: Finalized - Referencirana dokumentacija dostupna za implementaciju*
