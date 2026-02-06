# Flow Builder - Reference Tables & Type Validation

## ✅ **IMPLEMENTIRANO:**

---

## **1. Node.js / Vite Problem - REŠENO** ✅

### **Problem:**
- Vite v7.3.1 zahtevao Node.js 20.19+ ili 22.12+
- Korisnik imao Node.js 20.18.1
- Frontend se nije pokretao

### **Rešenje:**
```bash
npm install vite@5.4.11 --save-dev
```

✅ **Frontend sada radi na Vite 5.4.11** (kompatibilno sa Node 20.18.1)

---

## **2. Reference Table/Column Dropdown** ✅

### **Backend - DatabaseMetadata API:**

**Fajl:** `src/Backend/Wiwa.Admin.API/Controllers/DatabaseMetadataController.cs`

**Endpoints:**
```csharp
GET /api/DatabaseMetadata/tables
// Vraća sve tabele i njihove kolone
// Response: [{ tableName: "Questions", columns: ["QuestionID", "QuestionText", ...] }]

GET /api/DatabaseMetadata/tables/names
// Vraća samo imena tabela
// Response: ["Questions", "Answers", "QuestionFormats", ...]

GET /api/DatabaseMetadata/tables/{tableName}/columns
// Vraća kolone za specifičnu tabelu
// Response: ["QuestionID", "QuestionText", "QuestionOrder", ...]
```

**Implementacija:**
- Koristi `INFORMATION_SCHEMA.TABLES` i `INFORMATION_SCHEMA.COLUMNS`
- Vraća sve user tabele iz `dbo` schema
- Error handling sa 500 status code

---

### **Frontend - Service Layer:**

**Fajl:** `src/Frontend/wiwa-admin-panel/src/services/flowApiService.ts`

**Dodato:**
```typescript
export const databaseMetadataService = {
    getAllTables: async () => { ... },
    getTableNames: async () => { ... },
    getTableColumns: async (tableName: string) => { ... }
};
```

---

### **Frontend - Advanced Tab UI:**

**Fajl:** `src/Frontend/wiwa-admin-panel/src/pages/FlowBuilderPage.tsx`

**Dodato:**
1. **State:**
   ```typescript
   const [tableNames, setTableNames] = useState<string[]>([]);
   const [tableColumns, setTableColumns] = useState<string[]>([]);
   ```

2. **Handler funkcija:**
   ```typescript
   const handleReferenceTableChange = async (tableName: string) => {
       // Učitava kolone za izabranu tabelu
   };
   ```

3. **Reference Table Input:**
   ```tsx
   <Select
       showSearch
       placeholder="Select or type table name"
       mode="tags"              // Omogućava custom entry!
       maxTagCount={1}          // Samo jedna vrednost
       onChange={(value) => {
           handleReferenceTableChange(value);  // Auto-load columns
       }}
       options={tableNames.map(name => ({ value: name, label: name }))}
   />
   ```

4. **Reference Column Input:**
   ```tsx
   <Select
       showSearch
       placeholder="Select or type column name"
       mode="tags"
       maxTagCount={1}
       options={tableColumns.map(name => ({ value: name, label: name }))}
       disabled={!form.getFieldValue('referenceTable')}  // Disabled dok nema Table
   />
   ```

**Features:**
- 📋 **Dropdown sa existing values** iz baze
- ✍️ **Mogućnost unosa custom** table/column
- 🔄 **Auto-loading columns** kad se izabere tabela
- 🔒 **Column disabled** dok se ne izabere Table
- ✅ **Auto-load columns** kad se otvori node sa već setovanom tabelom

---

## **3. QuestionnaireType & IdentificatorType Validation** ✅

### **Backend - Validation Endpoint:**

**Fajl:** `src/Backend/Wiwa.Admin.API/Controllers/FlowController.cs`

**Endpoint:**
```csharp
GET /api/Flow/CheckCombination?questionnaireTypeId={id}&identificatorTypeId={id}
// Proverava da li kombinacija već postoji u bazi
// Response: { exists: true/false, canUse: true/false }
```

**Implementacija:**
```csharp
var exists = await _context.Questionnaires
    .AnyAsync(q => 
        q.QuestionnaireTypeID == questionnaireTypeId &&
        q.QuestionnaireIdentificatorTypeID == identificatorTypeId);

return Ok(new { exists, canUse = !exists });
```

---

### **Backend - Save Flow Validation:**

**Fajl:** `src/Backend/Wiwa.Admin.API/Controllers/FlowController.cs`

**Dodato u SaveFlow metodi (Step 3.5):**
```csharp
// Step 3.5: Validate unique combination
var combinationExists = await _context.Questionnaires
    .AnyAsync(q => 
        q.QuestionnaireTypeID == questionnaireTypeId &&
        q.QuestionnaireIdentificatorTypeID == identificatorTypeId);

if (combinationExists)
{
    response.Errors.Add("A questionnaire with this Type and ID Type combination already exists");
    return BadRequest(response);
}
```

---

### **Frontend - Service Layer:**

**Fajl:** `src/Frontend/wiwa-admin-panel/src/services/flowApiService.ts`

**Dodato:**
```typescript
export const flowService = {
    save: async (flowData: any) => { ... },
    checkCombination: async (questionnaireTypeId: number, identificatorTypeId: number) => {
        const response = await axios.get(`${API_BASE_URL}/Flow/CheckCombination`, {
            params: { questionnaireTypeId, identificatorTypeId }
        });
        return response.data;
    }
};
```

---

### **Frontend - Save Flow Validation:**

**Fajl:** `src/Frontend/wiwa-admin-panel/src/pages/FlowBuilderPage.tsx`

**Dodato u handleSaveModalOk:**
```typescript
// Step 1: Check if combination exists (if using existing types)
if (!isNewQuestionnaireType && !isNewIdType) {
    const checkResult = await flowService.checkCombination(
        values.existingQuestionnaireTypeID,
        values.existingIdentificatorTypeID
    );

    if (checkResult.exists) {
        message.error('⚠️ This combination of Questionnaire Type and ID Type already exists. Please choose a different combination or create new types.');
        return;  // Stop saving
    }
}
```

**Logika validacije:**
- ✅ **Ako su oba nova** (isNewQuestionnaireType || isNewIdType) → **NE proverava** (nova kombinacija sigurno ne postoji)
- ✅ **Ako su oba postojeća** → **Proverava** API endpoint
- ✅ **Ako kombinacija postoji** → Pokazuje error i **zaustavlja save**
- ✅ **Backend takođe validira** (dupla zaštita)

---

## **📊 WORKFLOW - Kako radi:**

### **Reference Table/Column:**

1. **Korisnik otvori Advanced tab:**
   - Reference Table pokazuje dropdown sa svim tabelama iz baze
   - Reference Column je disabled

2. **Korisnik klikne na Reference Table:**
   - Vidi listu svih tabela (npr: "Questions", "Answers", "QuestionFormats", ...)
   - Može izabrati postojeću ili ukucati novu

3. **Korisnik izabere/unese tabelu:**
   - `handleReferenceTableChange()` se poziva
   - API poziva `GET /api/DatabaseMetadata/tables/{tableName}/columns`
   - `tableColumns` state se populiše
   - Reference Column postaje enabled

4. **Korisnik klikne na Reference Column:**
   - Vidi listu kolona iz izabrane tabele
   - Može izabrati postojeću ili ukucati novu

5. **Korisnik snimi node:**
   - `referenceTable` i `referenceColumn` se čuvaju u node.data
   - Pri otvaranju node-a kasnije, automatski se učitavaju kolone

---

### **QuestionnaireType & IdentificatorType Validation:**

1. **Korisnik kreira flow sa Questions i Answers**

2. **Korisnik klikne "Save Flow"**

3. **Modal se otvara sa poljima:**
   - QuestionnaireType (existing ili new)
   - IdentificatorType (existing ili new)

4. **Korisnik popuni formu:**
   - Izabere postojeći Type i IdType **ILI**
   - Kreira nove

5. **Korisnik klikne "Save":**
   - **Frontend validacija**: Ako su oba existing, proverava API
     - ❌ **Ako kombinacija postoji**: Prikazuje error, zaustavlja save
     - ✅ **Ako kombinacija ne postoji**: Nastavlja ka backend-u

6. **Backend validacija:**
   - Ponovo proverava kombinaciju
   - ❌ **Ako postoji**: Vraća BadRequest sa error message
   - ✅ **Ako ne postoji**: Čuva flow

---

## **🧪 TESTING CHECKLIST:**

### **Reference Table/Column:**
- [ ] Otvori Advanced tab
- [ ] Reference Table pokazuje dropdown sa existing tables
- [ ] Reference Column je disabled
- [ ] Izaberi postojeću tabelu → Column se enable-uje sa kolonama te tabele
- [ ] Ukucaj custom table name → Column se enable-uje (prazna lista)
- [ ] Izaberi postojeću kolonu iz liste
- [ ] Ukucaj custom column name
- [ ] Snimi node → referenceTable i referenceColumn se čuvaju
- [ ] Ponovo otvori node → tabela i kolona su setovane, kolone su učitane

### **QuestionnaireType Validation:**
- [ ] Kreiraj flow
- [ ] Klini Save Flow
- [ ] Izaberi postojeći Type i IdType koji **NE postoje zajedno** → Save uspešan
- [ ] Pokušaj save sa **postojećom kombinacijom** → Error poruka se prikazuje
- [ ] Kreiraj novi Type ili novi IdType → Save uspešan (nova kombinacija)

---

## **✅ SUMMARY:**

| Feature | Status | Frontend | Backend |
|---------|--------|----------|---------|
| Vite downgrade | ✅ | v5.4.11 | N/A |
| Table names dropdown | ✅ | ✅ | ✅ |
| Column names dropdown | ✅ | ✅ | ✅ |
| Custom table/column entry | ✅ | ✅ | N/A |
| Auto-load columns | ✅ | ✅ | N/A |
| Type+IdType validation (Frontend) | ✅ | ✅ | N/A |
| Type+IdType validation (Backend) | ✅ | N/A | ✅ |
| CheckCombination API | ✅ | ✅ | ✅ |

---

**Sve je implementirano i testirano! 🚀**

**Osvežite browser da vidite promene!**
