---
description: Workflow za razvoj i integraciju Questionnaire Micro-Frontend modula
---

# Razvoj Questionnaire Modula

Ovaj workflow vodi developera kroz proces podešavanja, razvoja i testiranja embeddable Questionnaire modula.

## Preduslovi
- [ ] Node.js instaliran
- [ ] Pristup repo-u `wiwa-questionnaire-fe` (ili kreirati novi)
- [ ] Backend API specifikacija dostupna

## Koraci

### 1. Inicijalizacija Projekta (Embeddable First)

Ako projekat ne postoji, kreiraj ga koristeći Vite sa React-om:

```bash
npm create vite@latest wiwa-questionnaire-fe -- --template react-ts
cd wiwa-questionnaire-fe
npm install
```

// turbo
### 2. Podesi Standalone vs Embedded Mode

Modul mora raditi u dva moda. Kreiraj `src/main.tsx` koji detektuje okruženje:

```typescript
// Pseudocode
const isEmbedded = window.parent !== window;

if (isEmbedded) {
  // Slušaj 'message' event za inicijalizaciju
  window.addEventListener('message', (event) => {
    if (event.data.type === 'WIWA_INIT') {
      renderApp(event.data.payload);
    }
  });
} else {
  // Standalone mode: Prikazi Mock Host pane
  renderApp(mockPayload);
}
```

### 3. Implementiraj "Dumb Renderer"

Razvij komponentu `<QuestionnaireRenderer />` koja:
1. Prima `schema` (JSON) kao prop.
2. Renderuje UI na osnovu `controlType` (radio, text, checkbox).
3. Čuva lokalno stanje odgovora.
4. Emituje `onChange` evente.

### 4. Implementiraj PostMessage Komunikaciju

Dodaj helper funkcije za slanje poruka hostu:

```typescript
export const sendToHost = (type: string, payload: any) => {
  if (window.parent) {
    window.parent.postMessage({ type, payload }, '*');
  }
};

// Primer upotrebe:
// sendToHost('WIWA_RESIZE', { height: document.body.scrollHeight });
// sendToHost('WIWA_COMPLETE', { answers: [...] });
```

### 5. Testiranje Integracije

1. Kreiraj `host-mock.html` u `public` folderu.
2. Ubaci `<iframe>` koji gađa `http://localhost:5173`.
3. Testiraj da li `host-mock.html` uspešno šalje INIT i prima COMPLETE poruke.

## Verification

- [ ] Modul se učitava u iframe-u.
- [ ] Resizing radi (nema scrollbar-a unutar iframe-a).
- [ ] JSON output se ispravno šalje Hostu.
