# ⚠️ PITANJE ZA KORISNIKA - QuestionnaireType & IdentificatorType

## **Status implementacije:**

✅ **Reference Table/Column dropdown - IMPLEMENTIRANO:**
- Advanced tab sada ima Select dropdown sa:
  - Lista svih postojećih tabela iz baze
  - Mogućnost unosa nove tabele (mode="tags")
  - Nakon izbora tabele, automatski se učitavaju kolone te tabele
  - Kolone takođe imaju dropdown + mogućnost unosa nove
  - Column je disabled dok se ne izabere Table

---

## **❓ PITANJE: Gde da se bira QuestionnaireType i IdentificatorType?**

Trenutno se **QuestionnaireType** i **QuestionnaireIdentificatorType** biraju u **"Save Flow" modalu** pre snimanja celog flow-a.

### **Opcije:**

### **A) Ostaviti kao sada (u Save Flow modalu)**
```
1. Korisnik kreira Questions i Answers
2. Klika "Save Flow"
3. Modal se otvara sa polj ima:
   - QuestionnaireType (existing ili new)
   - IdentificatorType (existing ili new)
4. Submit → čuva sve
```
✅ **Prednost**: Type i Identificator važe za ceo questionnaire
❌ **Mana**: Ne vidi se tokom kreir anja pitanja

---

### **B) Dodati u Basic Info tab svakog Question node-a**
```
Basic Info:
- Label
- Question Text
- QuestionnaireType ← NOVO
- IdentificatorType ← NOVO
- Order
- Format
...
```
✅ **Prednost**: Vidljivo odmah, može se setovati po node-u
❌ **Mana**: Zbunjujuće jer se ponavlja za svaki node
❌ **Problem**: Može biti različit type po nodu (ne želite to)

---

### **C) Dodati kao "Global Settings" pre kreiranja flow-a**
```
Flow Builder Page Header:
┌────────────────────────────────────┐
│ QuestionnaireType: [Select ▼]      │
│ IdentificatorType: [Select ▼]      │
│ ✅ Set                               │
└────────────────────────────────────┘

Canvas za Questions/Answers...
```
✅ **Prednost**: Setuje se jednom za ceo flow, vidljivo sve vreme
✅ **Prednost**: Ne mora se ponavljati u svakom nodu
❌ **Mana**: Dodatna kompleksnost (mora se setovati pre kreiranja)

---

### **D) Dodati kao 4th tab u Question Edit Modal**
```
Tabs: Basic Info | Advanced | Computed | Metadata
                                        ↑
                                    NOVO TAB
Metadata:
- QuestionnaireType
- IdentificatorType
```
✅ **Prednost**: Organizovano u poseban tab
❌ **Mana**: I dalje se ponavlja za svaki node

---

## **💡 MOJA PREPORUKA: Opcija A (ostaviti u Save Flow modalu)**

**Razlog:**
- QuestionnaireType i IdentificatorType su **globalni metadata** za ceo flow
- Ne treba da se ponavljaju po node-u
- Trenutno rešenje je validno - bira se jednom za ceo questionnaire

**Ali možda želite** da se ovo prikaže i **na vrhu stranice kao read-only info** nakon što se setuje u Save Flow modalu?

---

## **🔍 VALIDACIJA KOMBINACIJA (QuestionnaireType + IdentificatorType)**

Pitali ste za validaciju da **postoji samo jedan par** po tipu upitnika.

### **Gde se validira?**

#### **Opcija 1: Backend validacija**
```csharp
// U FlowController.Save metodi
var existingPair = await _context.Questionnaires
    .FirstOrDefaultAsync(q => 
        q.QuestionnaireTypeID == questionnaireTypeId &&
        q.QuestionnaireIdentificatorTypeID == identificatorTypeId);

if (existingPair != null)
{
    return BadRequest("Combination of QuestionnaireType and IdentificatorType already exists");
}
```
✅ Siguran, ne zavisi od fronted a

#### **Opcija 2: Frontend validacija (pre slanja)**
```ts
// Pre submit-a, proveri da li kombinacija postoji
const existingQuestionnaires = await questionnaireService.getByTypeAndIdType(typeId, idTypeId);
if (existingQuestionnaires.length > 0) {
    message.error('This combination already exists');
    return;
}
```
✅ Brži feedback korisniku

#### **Opcija 3: Oba (preporučeno)**
- Frontend prvo proveri (brzi feedback)
- Backend takođe proveri (sigurnost)

---

## **📝 MOLIM VAS POTVRDITE:**

1. **Gdje da bude izbor QuestionnaireType & IdentificatorType?**
   - [ ] A - Ostaviti u Save Flow modalu (kao sada)
   - [ ] B - U Basic Info tab-u svakog node-a
   - [ ] C - Kao Global Settings na vrhu stranice
   - [ ] D - U posebnom Metadata tabu

2. **Validacija kombinacija:**
   - [ ] Backend only
   - [ ] Frontend only
   - [ ] Oba (preporučen o)

3. **Da li želite API endpoint za proveru postojećih kombinacija?**
   - `/api/Questionnaires/check-combination?typeId=X&idTypeId=Y`

---

✅ **ŠTO SAM VEĆ IMPLEMENTIRAO:**
- Reference Table dropdown sa existing values
- Reference Column dropdown (dinamički se puni nakon izbora table)
- Mogućnost unosa novih table/column imena (mode="tags")
- Auto-loading kolona kada se otvori node sa već setovanom tabelom

**Čekam Vaš odgovor na pitanja gore da završim implementaciju! 🚀**
