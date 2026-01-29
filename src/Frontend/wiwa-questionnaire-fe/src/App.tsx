import { useEffect, useState, useRef } from 'react';
import './App.css';
import { questionnaireApi } from './services/apiService';
import type { QuestionnaireSchemaDto, QuestionTypeDto, IdentificatorTypeDto, QuestionnaireSubmissionDto } from './types/api';
import { QuestionnaireRenderer } from './components/QuestionnaireRenderer';
import type { QuestionnaireRendererHandle } from './components/QuestionnaireRenderer';
import i18n from './assets/i18n.json';

interface AppProps {
  embedded?: boolean;
  initialType?: string;
  initialIdentificator?: string;
  initialIdentificatorTypeID?: number;
}

function App({
  embedded = false,
  initialType,
  initialIdentificator = '',
  initialIdentificatorTypeID
}: AppProps) {
  const [schema, setSchema] = useState<QuestionnaireSchemaDto | null>(null);
  const [types, setTypes] = useState<QuestionTypeDto[]>([]);
  const [idTypes, setIdTypes] = useState<IdentificatorTypeDto[]>([]);
  const [error, setError] = useState<string>('');
  const [loading, setLoading] = useState(false);

  const [selectedType, setSelectedType] = useState(initialType || '');
  const [idTypeID, setIdTypeID] = useState<number | undefined>(initialIdentificatorTypeID);
  const [identificator, setIdentificator] = useState(initialIdentificator);

  const [formConfigured, setFormConfigured] = useState(false);
  const [formState, setFormState] = useState<any>({});
  const [initialFormState, setInitialFormState] = useState<any>({});
  const [existingInstanceID, setExistingInstanceID] = useState<number | null>(null);
  const [isReadOnly, setIsReadOnly] = useState(false);
  const [showSuccessDialog, setShowSuccessDialog] = useState(false);
  const [showErrorDialog, setShowErrorDialog] = useState(false);
  const [successMessage, setSuccessMessage] = useState('');

  const [setupErrors, setSetupErrors] = useState({ type: false, idType: false, id: false });

  const rendererRef = useRef<QuestionnaireRendererHandle>(null);

  useEffect(() => {
    loadInitialData();
  }, []);

  useEffect(() => {
    // If props provide everything, auto-configure
    if (initialType && initialIdentificator && initialIdentificatorTypeID) {
      handleConfigure();
    }
  }, [initialType, initialIdentificator, initialIdentificatorTypeID]);

  const loadInitialData = async () => {
    try {
      setLoading(true);
      const [typesData, idTypesData] = await Promise.all([
        questionnaireApi.getTypes(),
        questionnaireApi.getIdentificatorTypes()
      ]);
      setTypes(typesData);
      setIdTypes(idTypesData);
      // Auto-selection removed to force user choice
    } catch (err) {
      setError('Failed to load metadata. Is Backend running?');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const loadQuestionnaire = async (type: string, existingData?: QuestionnaireSubmissionDto | null) => {
    try {
      setSchema(null);
      setError('');

      const data = await questionnaireApi.getSchema(type);
      setSchema(data);

      if (existingData) {
        setInitialFormState(existingData.answers);
        setFormState(existingData.answers);
        setExistingInstanceID(existingData.instanceID ?? null);
        setIsReadOnly(true); // Default to Read Only for existing
      } else {
        setInitialFormState({});
        setFormState({});
        setExistingInstanceID(null);
        setIsReadOnly(false);
      }
    } catch (err) {
      setError(i18n.form.error_load);
      console.error(err);
    }
  };

  const handleConfigure = async () => {
    const newSetupErrors = {
      type: !selectedType,
      idType: !idTypeID,
      id: !identificator
    };

    if (newSetupErrors.type || newSetupErrors.idType || newSetupErrors.id) {
      setSetupErrors(newSetupErrors);
      return;
    }

    setSetupErrors({ type: false, idType: false, id: false });

    try {
      setLoading(true);
      const typeObj = types.find(t => t.code === selectedType);
      if (!typeObj) throw new Error("Type not found");

      const existing = await questionnaireApi.getExistingSubmission(
        typeObj.questionnaireTypeID,
        idTypeID,
        identificator
      );

      setFormConfigured(true);
      await loadQuestionnaire(selectedType, existing);

    } catch (err) {
      console.error(err);
      setError("Error during initialization");
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async () => {
    if (!schema) return;

    if (rendererRef.current) {
      const isValid = rendererRef.current.validate();
      if (!isValid) {
        setShowErrorDialog(true);
        return; // Validation failed
      }
    }

    const answersPayload: Record<number, { value?: string, selectedAnswerIds?: number[] }> = {};

    Object.keys(formState).forEach(key => {
      const questionId = Number(key);
      const val = formState[questionId];
      if (val) {
        answersPayload[questionId] = {
          value: val.value,
          selectedAnswerIds: val.selectedAnswerIds
        };
      }
    });

    const payload: QuestionnaireSubmissionDto = {
      instanceID: existingInstanceID || undefined,
      questionnaireTypeID: schema.questionnaire.typeId,
      identificatorValue: identificator,
      identificatorTypeID: idTypeID!,
      answers: answersPayload
    };

    try {
      setLoading(true);
      let res;
      if (existingInstanceID) {
        res = await questionnaireApi.updateQuestionnaire(payload);
        setSuccessMessage(i18n.form.success_update);
      } else {
        res = await questionnaireApi.submitQuestionnaire(payload);
        setSuccessMessage(i18n.form.success_save);
      }

      // On success: Lock form and show dialog
      setIsReadOnly(true);
      setShowSuccessDialog(true);

    } catch (err) {
      console.error(err);
      alert(i18n.form.error_save);
    } finally {
      setLoading(false);
    }
  };

  const handleSuccessClose = () => {
    setShowSuccessDialog(false);
    setFormConfigured(false); // Redirect to start
    setSchema(null);
  };

  return (
    <div className={(embedded ? "embedded-container" : "container") + (formConfigured ? " questionnaire-mode" : " setup-mode")}>
      <header>
        <h1>Wiener Städtische - Health Questionnaire</h1>
      </header>

      {/* Success Modal */}
      {showSuccessDialog && (
        <div className="modal-overlay">
          <div className="modal-content">
            <h3>Uspešno!</h3>
            <p>{successMessage}</p>
            <button onClick={handleSuccessClose} className="btn-primary">OK</button>
          </div>
        </div>
      )}

      {/* Error Modal */}
      {showErrorDialog && (
        <div className="modal-overlay">
          <div className="modal-content" style={{ borderTop: '5px solid #dc3545' }}>
            <h3 style={{ color: '#dc3545' }}>Greška!</h3>
            <p>Forma sadrži greške. Molimo vas da proverite unete podatke i pokušate ponovo.</p>
            <button onClick={() => setShowErrorDialog(false)} className="btn-primary" style={{ backgroundColor: '#dc3545' }}>U redu</button>
          </div>
        </div>
      )}

      {!formConfigured ? (
        <div className="setup-panel" style={{ padding: 20, border: '1px solid #ddd', borderRadius: 8 }}>
          <h3>{i18n.setup.title}</h3>
          <div className="setup-fields-wrapper">
            <div style={{ marginBottom: 15 }}>
              <label>{i18n.setup.type_label}: </label>
              <select
                value={selectedType}
                onChange={e => { setSelectedType(e.target.value); setSetupErrors(prev => ({ ...prev, type: false })); }}
                style={setupErrors.type ? { borderColor: 'red', backgroundColor: '#fff5f5', color: '#333' } : {}}
              >
                <option value="">-- Izaberi --</option>
                {types.map(t => <option key={t.code} value={t.code}>{t.name}</option>)}
              </select>
            </div>
            <div style={{ marginBottom: 15 }}>
              <label>{i18n.setup.id_type_label}: </label>
              <select
                value={idTypeID || ""}
                onChange={e => { setIdTypeID(Number(e.target.value)); setSetupErrors(prev => ({ ...prev, idType: false })); }}
                style={setupErrors.idType ? { borderColor: 'red', backgroundColor: '#fff5f5', color: '#333' } : {}}
              >
                <option value="">-- Izaberi --</option>
                {idTypes.map(it => <option key={it.questionnaireIdentificatorTypeID} value={it.questionnaireIdentificatorTypeID}>{it.name}</option>)}
              </select>
            </div>
            <div style={{ marginBottom: 15 }}>
              <label>{i18n.setup.id_value_label}: </label>
              <input
                type="text"
                value={identificator}
                onChange={e => { setIdentificator(e.target.value); setSetupErrors(prev => ({ ...prev, id: false })); }}
                placeholder="Npr. Lokacija ABC"
                style={setupErrors.id ? { borderColor: 'red', backgroundColor: '#fff5f5', color: '#333' } : {}}
              />
            </div>
            <button onClick={handleConfigure} disabled={loading}>{i18n.setup.button_show}</button>
          </div>
        </div>
      ) : (
        <main>
          <div style={{ marginBottom: 20, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <strong>{i18n.form.type_label}:</strong> {schema?.questionnaire.typeName} |
              <strong> {i18n.form.id_label}:</strong> {identificator}
              {existingInstanceID && <span style={{ marginLeft: 10, color: '#e30613' }}>(Izmena postojećeg)</span>}
            </div>
            <button onClick={() => setFormConfigured(false)}>{i18n.form.button_change}</button>
          </div>
          {loading && <p>{i18n.form.loading}</p>}
          {error && <p className="error">{error}</p>}

          {schema && (
            <div>
              <QuestionnaireRenderer
                ref={rendererRef}
                schema={schema.questions}
                rules={schema.rules}
                initialState={initialFormState}
                readOnly={isReadOnly}
                validationMessages={{
                  success: i18n.form.validation_alert,
                  error: i18n.form.validation_alert,
                  required: i18n.form.error_required,
                  format: i18n.form.error_format
                }}
                onChange={(state) => setFormState(state)}
              />
              <div className="form-actions" style={{ marginTop: 20 }}>
                {isReadOnly ? (
                  <button onClick={() => setIsReadOnly(false)} className="btn-secondary" style={{ marginRight: 10 }}>
                    Izmeni
                  </button>
                ) : (
                  <button onClick={handleSubmit} className="btn-primary">
                    {i18n.form.button_save}
                  </button>
                )}
              </div>
            </div>
          )}
        </main>
      )}
    </div>
  );
}

export default App;
