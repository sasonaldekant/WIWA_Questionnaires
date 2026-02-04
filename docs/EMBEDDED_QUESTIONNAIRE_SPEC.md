# WIWA Embeddable Questionnaire - Funkcionalna Specifikacija

**Verzija:** 1.0  
**Datum:** 2026-02-04  
**Status:** Odobreno za implementaciju

---

## 1. Sažetak

Ovaj dokument definiše funkcionalnu specifikaciju za ugradnju WIWA upitnika u eksterne aplikacije (portale, ERP sisteme) putem iframe-a sa postMessage komunikacijom.

### 1.1 Ciljevi

1. **Ugradimost** - Upitnik može biti ugrađen u bilo koju web aplikaciju kao iframe
2. **Izolacija** - Potpuna izolacija upitnika od host aplikacije (sigurnost)
3. **Prilagodljivost** - Mogućnost prilagođavanja izgleda host aplikaciji
4. **Jednostavna integracija** - Minimalni kod potreban na strani host-a
5. **Enriched Output** - Vraćanje podataka mapiranih na referencirane tabele

---

## 2. Arhitektura

### 2.1 Dijagram Komunikacije

```
┌─────────────────────────────────────────────────────────────────┐
│                      HOST APLIKACIJA (Portal/ERP)               │
│                                                                  │
│  1. window.postMessage(WIWA_INIT, payload)                      │
│  2. Sluša WIWA_COMPLETE event                                   │
│  3. Prima enriched JSON sa referenceMappings                     │
│                                                                  │
│                            ↕ postMessage                         │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    WIWA iframe                           │    │
│  │  ┌─────────────────────────────────────────────────────┐│    │
│  │  │              WIWA Questionnaire (React)             ││    │
│  │  │  - Prima WIWA_INIT i primenjuje konfiguraciju       ││    │
│  │  │  - Poziva backend API za schema + existing data     ││    │
│  │  │  - Korisnik popunjava upitnik                       ││    │
│  │  │  - Na SUBMIT: čuva u bazu + šalje WIWA_COMPLETE     ││    │
│  │  └─────────────────────────────────────────────────────┘│    │
│  └─────────────────────────────────────────────────────────┘    │
│                            ↕ REST API (CORS enabled)            │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    WIWA Backend API                      │    │
│  │  - GET  /api/Questionnaire/schema/{typeCode}            │    │
│  │  - POST /api/QuestionnaireSubmission                    │    │
│  │  - PUT  /api/QuestionnaireSubmission                    │    │
│  │  - GET  /api/QuestionnaireSubmission/existing/...       │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Zašto iframe + postMessage?

| Aspekt | Obrazloženje |
|--------|--------------|
| **Izolacija** | Kompletna izolacija DOM-a i JavaScript-a između host-a i upitnika |
| **Sigurnost** | Host ne može direktno pristupiti podacima upitnika |
| **Jednostavnost** | Minimalne promene na host strani - samo postMessage listener |
| **Cross-origin** | Radi sa različitim domenima uz pravilnu CORS konfiguraciju |
| **Proširivost** | Lako se može dodati Web Component wrapper naknadno |

---

## 3. Message Protokol

### 3.1 Tipovi Poruka

| Tip | Smer | Opis |
|-----|------|------|
| `WIWA_INIT` | Host → iframe | Inicijalizacija upitnika sa parametrima |
| `WIWA_READY` | iframe → Host | Upitnik je spreman za prikaz |
| `WIWA_THEME` | Host → iframe | Primena custom CSS stilova |
| `WIWA_SUBMIT` | Host → iframe | Trigger čuvanja iz host aplikacije |
| `WIWA_COMPLETE` | iframe → Host | Uspešno čuvanje + enriched podaci |
| `WIWA_CANCEL` | Host → iframe | Zatvaranje bez čuvanja |
| `WIWA_ERROR` | iframe → Host | Greška u upitniku |
| `WIWA_RESIZE` | iframe → Host | Promena dimenzija sadržaja |

### 3.2 Payload Strukture

#### WIWA_INIT (Host → iframe)

```typescript
interface WiwaInitPayload {
    // OBAVEZNO
    questionnaireType: string;       // Kod tipa upitnika (npr. 'LOCATION', 'GREAT_QUEST')
    identificatorTypeID: number;     // ID tipa identifikatora iz baze
    identificatorValue: string;      // Vrednost identifikatora (npr. broj polise)
    
    // OPCIONO
    instanceId?: number;             // Za učitavanje postojeće instance (EDIT mode)
    readOnly?: boolean;              // Prikaz samo za čitanje (VIEW mode)
    contextData?: Record<string, any>; // Dodatni podaci od host-a (prosleđuju se nazad)
}
```

**Obrazloženje:**
- `questionnaireType` - Kod koji identifikuje tip upitnika u bazi
- `identificatorTypeID` - Potreban za ispravno mapiranje instance na entitet (lokacija, polisa, osiguranik)
- `instanceId` - Ako je prosleđen, učitava se postojeća popunjena instanca za izmenu

#### WIWA_THEME (Host → iframe)

```typescript
interface WiwaThemePayload {
    // CSS custom properties (CSS variables)
    cssVariables?: {
        '--wiwa-primary-color'?: string;      // Primarna boja (dugmad, linkovi)
        '--wiwa-secondary-color'?: string;    // Sekundarna boja
        '--wiwa-background-color'?: string;   // Pozadina upitnika
        '--wiwa-text-color'?: string;         // Boja teksta
        '--wiwa-border-color'?: string;       // Boja granica
        '--wiwa-error-color'?: string;        // Boja grešaka
        '--wiwa-success-color'?: string;      // Boja uspešnih poruka
        '--wiwa-font-family'?: string;        // Font familija
        '--wiwa-border-radius'?: string;      // Zaobljenost uglova
        [key: string]: string | undefined;    // Dodatne CSS varijable
    };
    
    // Alternativno: raw CSS string
    customCss?: string;
}
```

**Obrazloženje:**
- CSS varijable omogućavaju kontrolisanu tematizaciju bez rizika od XSS
- Raw CSS opcija za napredne slučajeve (sanitizuje se pre primene)

#### WIWA_COMPLETE (iframe → Host)

```typescript
interface WiwaCompletePayload {
    success: boolean;                  // Da li je čuvanje uspešno
    instanceId: number;                // ID sačuvane instance
    questionnaireType: string;         // Vraća tip upitnika
    identificatorValue: string;        // Vraća identifikator
    
    // Odgovori korisnika
    answers: Record<number, {
        value?: string;                // Za tekstualna pitanja
        selectedAnswerIds?: number[];  // Za radio/checkbox pitanja
    }>;
    
    // KLJUČNO: Mapirani podaci za host aplikaciju
    referenceMappings: Array<{
        questionId: number;            // ID pitanja
        tableName: string;             // Ime referencirane tabele
        referenceColumnName: string;   // Ime kolone u tabeli
        value: string;                 // Kod odgovora (mapira se na ID u tabeli)
    }>;
    
    // Vraća kontekst prosleđen u WIWA_INIT
    contextData?: Record<string, any>;
}
```

**Obrazloženje:**
- `referenceMappings` je ključna struktura koja host aplikaciji daje podatke potrebne za dalju obradu
- Host može direktno koristiti `value` kao foreign key u svojim tabelama
- `contextData` se vraća nepromenjen da bi host mogao korelirati upitnik sa svojim workflow-om

---

## 4. Reference Mappings

### 4.1 Šta su Reference Mappings?

Reference mappings povezuju pitanja upitnika sa kolonama u eksternim tabelama. Kada korisnik odabere odgovor na pitanje, kod tog odgovora predstavlja ID ili vrednost u referenciranoj tabeli.

### 4.2 Primer

Za pitanje "Konstrukcija objekta" (QuestionID: 6):

| Odgovor | Code | Mapira se na |
|---------|------|--------------|
| Armirano-betonske konstrukcije | 1 | ConstructionMaterials.ConstructionMaterialID = 1 |
| Čelična konstrukcija | 2 | ConstructionMaterials.ConstructionMaterialID = 2 |
| Drvena konstrukcija | 3 | ConstructionMaterials.ConstructionMaterialID = 3 |

### 4.3 Izlazni Format

```json
{
    "referenceMappings": [
        {
            "questionId": 6,
            "tableName": "ConstructionMaterials",
            "referenceColumnName": "ConstructionMaterialID",
            "value": "2"
        },
        {
            "questionId": 8,
            "tableName": "ProtectionClasses",
            "referenceColumnName": "ProtectionClassID",
            "value": "1"
        }
    ]
}
```

---

## 5. Načini Korišćenja

### 5.1 CREATE Mode (Novo popunjavanje)

Host šalje WIWA_INIT bez `instanceId`:

```javascript
iframe.contentWindow.postMessage({
    type: 'WIWA_INIT',
    payload: {
        questionnaireType: 'LOCATION',
        identificatorTypeID: 1,
        identificatorValue: 'LOK-2024-001'
    }
}, '*');
```

### 5.2 EDIT Mode (Izmena postojećeg)

Host šalje WIWA_INIT sa `instanceId`:

```javascript
iframe.contentWindow.postMessage({
    type: 'WIWA_INIT',
    payload: {
        questionnaireType: 'LOCATION',
        identificatorTypeID: 1,
        identificatorValue: 'LOK-2024-001',
        instanceId: 42  // ID postojeće instance
    }
}, '*');
```

### 5.3 VIEW Mode (Samo pregled)

Host šalje WIWA_INIT sa `readOnly: true`:

```javascript
iframe.contentWindow.postMessage({
    type: 'WIWA_INIT',
    payload: {
        questionnaireType: 'LOCATION',
        identificatorTypeID: 1,
        identificatorValue: 'LOK-2024-001',
        instanceId: 42,
        readOnly: true
    }
}, '*');
```

---

## 6. Sigurnost

### 6.1 CORS Konfiguracija

Backend je konfigurisan da dozvoli cross-origin zahteve iz bilo koje domene (`*`).

**NAPOMENA:** U produkciji treba ograničiti na specifične domene host aplikacija.

### 6.2 Autentifikacija

Trenutna implementacija ne zahteva autentifikaciju. 

**Buduće proširenje:** Dodavanje JWT token podrške kroz WIWA_INIT:
```typescript
interface WiwaInitPayload {
    // ...
    authToken?: string;  // JWT token za autentifikovane pozive
}
```

---

## 7. Custom Theming

### 7.1 Podržane CSS Varijable

| Varijabla | Default | Opis |
|-----------|---------|------|
| `--wiwa-primary-color` | `#e30613` | Primarna boja (Wiener crvena) |
| `--wiwa-secondary-color` | `#333` | Sekundarna boja |
| `--wiwa-background-color` | `#fff` | Pozadina |
| `--wiwa-text-color` | `#333` | Boja teksta |
| `--wiwa-border-color` | `#ddd` | Boja granica |
| `--wiwa-error-color` | `#dc3545` | Boja grešaka |
| `--wiwa-success-color` | `#28a745` | Boja uspešnih poruka |
| `--wiwa-font-family` | `system-ui, sans-serif` | Font |
| `--wiwa-border-radius` | `8px` | Zaobljenost uglova |

### 7.2 Primer Primene Teme

```javascript
// Nakon što upitnik pošalje WIWA_READY
iframe.contentWindow.postMessage({
    type: 'WIWA_THEME',
    payload: {
        cssVariables: {
            '--wiwa-primary-color': '#0066cc',
            '--wiwa-font-family': 'Roboto, sans-serif',
            '--wiwa-border-radius': '4px'
        }
    }
}, '*');
```

---

## 8. Verzioniranje

- **v1.0** - Inicijalna implementacija sa iframe + postMessage
- **v1.1** (planirano) - Web Component wrapper
- **v2.0** (planirano) - NPM package za direktnu React integraciju
