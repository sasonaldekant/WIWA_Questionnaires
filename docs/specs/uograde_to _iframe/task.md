# Embeddable Questionnaire Architecture

## Overview
Implement iframe + postMessage based embedding system for the questionnaire application, allowing integration into external portals/ERPs.

## Tasks

### Phase 1: Planning & Design
- [x] Review existing embedded mode implementation
- [x] Analyze `referenceMappings` structure for enriched JSON output
- [x] Review current frontend and backend API structure
- [x] Create implementation plan with detailed specifications
- [x] Get user approval on implementation plan
- [/] Create functional specification document (docs/EMBEDDED_QUESTIONNAIRE_SPEC.md)
- [ ] Create integration guide with C# MVC examples (after implementation)

### Phase 2: Backend Changes
- [ ] Add `ReferenceMappingDto` to existing DTOs
- [ ] Extend `QuestionnaireSchemaDto` to include `referenceMappings`
- [ ] Create enriched submit endpoint that returns reference values
- [ ] Add CORS configuration for cross-origin requests

### Phase 3: Frontend Changes
- [ ] Extend `WiwaInitPayload` with full initialization params
- [ ] Extend `WiwaCompletePayload` with enriched reference data
- [ ] Update `messageService.ts` with new message types
- [ ] Update `App.tsx` to handle embedded flow completely
- [ ] Add `WIWA_SUBMIT` event to trigger save from host
- [ ] Send enriched JSON on successful save
- [ ] Implement custom CSS theming via postMessage (WIWA_THEME)

### Phase 4: Integration Guide
- [ ] Create host integration documentation
- [ ] Provide example HTML page for testing
- [ ] Document all message types and payloads

### Phase 5: Verification
- [ ] Manual testing with example host page
- [ ] Test create, edit, and view flows
