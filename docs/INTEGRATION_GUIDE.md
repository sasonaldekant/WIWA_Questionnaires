# WIWA Questionnaire - Vodič za Integraciju

> Detaljna dokumentacija za integraciju WIWA upitnika u externe aplikacije.

---

## Sadržaj

1. [Brzi Početak](#brzi-početak)
2. [Message Protokol](#message-protokol)
3. [C# MVC Integracija](#c-mvc-integracija)
4. [Prilagođavanje Stilova](#prilagođavanje-stilova)
5. [Obrada Rezultata](#obrada-rezultata)
6. [Primeri Korišćenja](#primeri-korišćenja)

---

## Brzi Početak

### 1. Ugradnja iframe-a

```html
<iframe id="wiwa-questionnaire" 
        src="https://wiwa-app-url/questionnaire"
        style="width: 100%; height: 700px; border: none;">
</iframe>
```

### 2. Inicijalizacija

```javascript
const iframe = document.getElementById('wiwa-questionnaire');

// Čekaj da se iframe učita
iframe.onload = function() {
    // Pošalji WIWA_INIT
    iframe.contentWindow.postMessage({
        type: 'WIWA_INIT',
        payload: {
            questionnaireType: 'LOCATION',
            identificatorTypeID: 1,
            identificatorValue: 'POL-2024-001'
        }
    }, '*');
};
```

### 3. Prijem Rezultata

```javascript
window.addEventListener('message', function(event) {
    if (event.data.type === 'WIWA_COMPLETE') {
        console.log('Instance ID:', event.data.payload.instanceId);
        console.log('Reference Mappings:', event.data.payload.referenceMappings);
    }
});
```

---

## Message Protokol

### Host → iframe Poruke

| Tip | Opis | Obavezno |
|-----|------|----------|
| `WIWA_INIT` | Inicijalizacija upitnika | ✅ |
| `WIWA_THEME` | Primena custom CSS stilova | ❌ |
| `WIWA_SUBMIT` | Trigger čuvanja iz host-a | ❌ |
| `WIWA_CANCEL` | Zatvaranje bez čuvanja | ❌ |

### iframe → Host Poruke

| Tip | Opis |
|-----|------|
| `WIWA_READY` | Upitnik je spreman |
| `WIWA_COMPLETE` | Uspešno čuvanje + podaci |
| `WIWA_ERROR` | Greška u upitniku |
| `WIWA_RESIZE` | Promena dimenzija |

### WIWA_INIT Payload

```typescript
{
    questionnaireType: string;       // 'LOCATION', 'SHORT_QUEST', 'GREAT_QUEST'
    identificatorTypeID: number;     // 1=Polisa, 2=JMBG, 3=Lokacija
    identificatorValue: string;      // Vrednost identifikatora
    instanceId?: number;             // Za izmenu postojeće instance
    readOnly?: boolean;              // Samo za pregled
    contextData?: object;            // Vraća se u WIWA_COMPLETE
}
```

### WIWA_COMPLETE Payload

```typescript
{
    success: boolean;
    instanceId: number;
    questionnaireType: string;
    identificatorValue: string;
    answers: Record<number, { value?: string; selectedAnswerIds?: number[] }>;
    referenceMappings: Array<{
        questionId: number;
        tableName: string;
        referenceColumnName: string;
        value: string;              // Kod za FK lookup
    }>;
    contextData?: object;
}
```

---

## C# MVC Integracija

### Model za Payload

```csharp
// Models/WiwaPayload.cs
public class WiwaCompletePayload
{
    public bool Success { get; set; }
    public int InstanceId { get; set; }
    public string QuestionnaireType { get; set; }
    public string IdentificatorValue { get; set; }
    public Dictionary<int, AnswerData> Answers { get; set; }
    public List<ReferenceMapping> ReferenceMappings { get; set; }
    public Dictionary<string, object> ContextData { get; set; }
}

public class AnswerData
{
    public string Value { get; set; }
    public List<int> SelectedAnswerIds { get; set; }
}

public class ReferenceMapping
{
    public int QuestionId { get; set; }
    public string TableName { get; set; }
    public string ReferenceColumnName { get; set; }
    public string Value { get; set; }  // Code koji mapira na FK
}
```

### View sa Ugrađenim Iframeom

```html
<!-- Views/Questionnaire/Index.cshtml -->
@model YourApp.Models.QuestionnaireViewModel

<div id="questionnaire-container">
    <iframe id="wiwa-frame" 
            src="@Model.WiwaAppUrl" 
            style="width:100%; height:700px; border:none;">
    </iframe>
</div>

<script>
    const wiwaFrame = document.getElementById('wiwa-frame');
    
    // Parametri sa servera
    const initParams = {
        questionnaireType: '@Model.QuestionnaireType',
        identificatorTypeID: @Model.IdentificatorTypeID,
        identificatorValue: '@Model.IdentificatorValue',
        instanceId: @(Model.InstanceId.HasValue ? Model.InstanceId.ToString() : "null"),
        readOnly: @Model.ReadOnly.ToString().ToLower(),
        contextData: { 
            userId: '@User.Identity.Name',
            returnUrl: '@Model.ReturnUrl'
        }
    };
    
    // Osluškuj poruke od iframea
    window.addEventListener('message', function(event) {
        const { type, payload } = event.data || {};
        
        if (type === 'WIWA_READY') {
            console.log('Upitnik spreman');
        }
        
        if (type === 'WIWA_COMPLETE') {
            // Prosledi podatke na server
            handleQuestionnaireComplete(payload);
        }
        
        if (type === 'WIWA_ERROR') {
            console.error('Greška:', payload.message);
            showError(payload.message);
        }
    });
    
    // Inicijalizuj kad se iframe učita
    wiwaFrame.onload = function() {
        wiwaFrame.contentWindow.postMessage({
            type: 'WIWA_INIT',
            payload: initParams
        }, '*');
    };
    
    // Pošalji rezultat na server
    async function handleQuestionnaireComplete(payload) {
        try {
            const response = await fetch('@Url.Action("ProcessResult", "Questionnaire")', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
            
            if (response.ok) {
                const result = await response.json();
                if (result.returnUrl) {
                    window.location.href = result.returnUrl;
                }
            }
        } catch (error) {
            console.error('Greška pri slanju:', error);
        }
    }
</script>
```

### Controller za Obradu Rezultata

```csharp
// Controllers/QuestionnaireController.cs
public class QuestionnaireController : Controller
{
    private readonly IQuestionnaireService _service;
    
    public QuestionnaireController(IQuestionnaireService service)
    {
        _service = service;
    }
    
    // GET: Prikaži stranicu sa iframeom
    public IActionResult Index(string type, int idTypeId, string idValue, int? instanceId = null)
    {
        var model = new QuestionnaireViewModel
        {
            WiwaAppUrl = Configuration["WiwaApp:Url"],
            QuestionnaireType = type,
            IdentificatorTypeID = idTypeId,
            IdentificatorValue = idValue,
            InstanceId = instanceId,
            ReadOnly = false,
            ReturnUrl = Url.Action("Dashboard", "Home")
        };
        
        return View(model);
    }
    
    // POST: Primi rezultat od iframea
    [HttpPost]
    public async Task<IActionResult> ProcessResult([FromBody] WiwaCompletePayload payload)
    {
        if (!payload.Success)
        {
            return BadRequest("Upitnik nije uspešno popunjen");
        }
        
        // Iskoristi referenceMappings za ažuriranje svojih tabela
        foreach (var mapping in payload.ReferenceMappings)
        {
            await ProcessReferenceMapping(mapping, payload.IdentificatorValue);
        }
        
        // Vrati URL za redirekciju
        var returnUrl = payload.ContextData?.GetValueOrDefault("returnUrl")?.ToString() 
                        ?? Url.Action("Dashboard", "Home");
        
        return Json(new { success = true, returnUrl });
    }
    
    private async Task ProcessReferenceMapping(ReferenceMapping mapping, string identificator)
    {
        // Primer: Ažuriraj lokaciju sa materijalom konstrukcije
        switch (mapping.TableName)
        {
            case "ConstructionMaterials":
                await _service.UpdateLocationConstructionMaterial(
                    identificator, 
                    int.Parse(mapping.Value)  // value je Code koji mapira na FK
                );
                break;
                
            case "ProtectionClasses":
                await _service.UpdateLocationProtectionClass(
                    identificator,
                    int.Parse(mapping.Value)
                );
                break;
        }
    }
}
```

---

## Prilagođavanje Stilova

### Korišćenje WIWA_THEME

```javascript
// Primeni custom temu nakon WIWA_READY
window.addEventListener('message', function(event) {
    if (event.data.type === 'WIWA_READY') {
        wiwaFrame.contentWindow.postMessage({
            type: 'WIWA_THEME',
            payload: {
                cssVariables: {
                    '--wiwa-primary-color': '#0066cc',      // Vaša brand boja
                    '--wiwa-secondary-color': '#444',
                    '--wiwa-background-color': '#f8f9fa',
                    '--wiwa-text-color': '#212529',
                    '--wiwa-border-color': '#dee2e6',
                    '--wiwa-error-color': '#dc3545',
                    '--wiwa-success-color': '#28a745',
                    '--wiwa-font-family': 'Segoe UI, sans-serif',
                    '--wiwa-border-radius': '4px'
                }
            }
        }, '*');
    }
});
```

### Dostupne CSS Varijable

| Varijabla | Opis | Default |
|-----------|------|---------|
| `--wiwa-primary-color` | Glavna brand boja | `#e30613` |
| `--wiwa-secondary-color` | Sekundarna boja | `#333` |
| `--wiwa-background-color` | Pozadina | `#fff` |
| `--wiwa-text-color` | Boja teksta | `#333` |
| `--wiwa-border-color` | Boja granica | `#ddd` |
| `--wiwa-error-color` | Boja grešaka | `#dc3545` |
| `--wiwa-success-color` | Boja uspeha | `#28a745` |
| `--wiwa-font-family` | Font | `Roboto, sans-serif` |
| `--wiwa-border-radius` | Zaobljenost | `8px` |

### C# Helper za Temu

```csharp
// Helpers/WiwaThemeHelper.cs
public static class WiwaThemeHelper
{
    public static object GetThemePayload(string brandColor, string fontFamily = null)
    {
        return new
        {
            cssVariables = new Dictionary<string, string>
            {
                ["--wiwa-primary-color"] = brandColor ?? "#e30613",
                ["--wiwa-font-family"] = fontFamily ?? "Segoe UI, sans-serif",
                ["--wiwa-border-radius"] = "4px"
            }
        };
    }
}

// U View-u
var theme = WiwaThemeHelper.GetThemePayload("#0066cc");
<script>
    const themePayload = @Html.Raw(JsonSerializer.Serialize(theme));
</script>
```

---

## Obrada Rezultata

### Struktura referenceMappings

Reference mappings sadrži mapiranja pitanja na externe tabele. Svaki zapis ima:

- `questionId` - ID pitanja u upitniku
- `tableName` - Ime tabele gde se čuva vrednost
- `referenceColumnName` - Ime kolone koja je PK/FK
- `value` - **Code** odgovora koji mapira na vrednost u tabeli

### Primer Korišćenja

Za upitnik o lokaciji, ako korisnik odabere "Armirano-betonske konstrukcije":

```json
{
    "referenceMappings": [
        {
            "questionId": 6,
            "tableName": "ConstructionMaterials",
            "referenceColumnName": "ConstructionMaterialID",
            "value": "1"
        }
    ]
}
```

U vašoj bazi možete napraviti JOIN:
```sql
SELECT * FROM ConstructionMaterials 
WHERE ConstructionMaterialID = 1  -- value iz mappinga
```

---

## Primeri Korišćenja

### Scenario 1: Nova Lokacija

```javascript
// 1. Inicijalizacija za novu lokaciju
iframe.contentWindow.postMessage({
    type: 'WIWA_INIT',
    payload: {
        questionnaireType: 'LOCATION',
        identificatorTypeID: 3,
        identificatorValue: 'LOK-NEW-001'
    }
}, '*');

// 2. Korisnik popunjava upitnik i klikne Sačuvaj

// 3. Primite WIWA_COMPLETE sa reference mappings
```

### Scenario 2: Izmena Postojeće

```javascript
iframe.contentWindow.postMessage({
    type: 'WIWA_INIT',
    payload: {
        questionnaireType: 'LOCATION',
        identificatorTypeID: 3,
        identificatorValue: 'LOK-123',
        instanceId: 42  // Postojeća instanca
    }
}, '*');
```

### Scenario 3: Samo Pregled

```javascript
iframe.contentWindow.postMessage({
    type: 'WIWA_INIT',
    payload: {
        questionnaireType: 'LOCATION',
        identificatorTypeID: 3,
        identificatorValue: 'LOK-123',
        instanceId: 42,
        readOnly: true
    }
}, '*');
```

---

## Testiranje

Za testiranje integracije koristite `docs/test-host.html`:

1. Pokrenite WIWA frontend: `cd src/Frontend/wiwa-questionnaire-fe && npm run dev`
2. Pokrenite WIWA backend: `cd src/Backend && dotnet run --project Wiwa.Questionnaire.API`
3. Otvorite `docs/test-host.html` u browseru
4. Kliknite "Send WIWA_INIT" da inicirajete upitnik
5. Popunite upitnik i pratite log poruka
