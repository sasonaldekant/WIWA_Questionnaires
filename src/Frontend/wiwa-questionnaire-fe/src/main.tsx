import { StrictMode, useEffect, useState, useRef } from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App.tsx';
import {
  MSG_TYPES,
  type WiwaInitPayload,
  type WiwaThemePayload,
  sendToHost,
  applyTheme
} from './services/messageService';

const isEmbedded = window.parent !== window;

function Main() {
  const [initData, setInitData] = useState<WiwaInitPayload | null>(null);
  const [ready, setReady] = useState(!isEmbedded);
  const submitTriggerRef = useRef<(() => void) | null>(null);
  const cancelTriggerRef = useRef<(() => void) | null>(null);

  useEffect(() => {
    if (isEmbedded) {
      console.log('[WiwaEmbedded] Waiting for INIT message...');

      const handleMessage = (event: MessageEvent) => {
        const { type, payload } = event.data || {};

        switch (type) {
          case MSG_TYPES.INIT:
            console.log('[WiwaEmbedded] Received INIT:', payload);
            setInitData(payload as WiwaInitPayload);
            setReady(true);
            // Send READY back to host
            sendToHost(MSG_TYPES.READY, { version: '1.0' });
            break;

          case MSG_TYPES.THEME:
            console.log('[WiwaEmbedded] Received THEME:', payload);
            applyTheme(payload as WiwaThemePayload);
            break;

          case MSG_TYPES.SUBMIT:
            console.log('[WiwaEmbedded] Received SUBMIT trigger');
            if (submitTriggerRef.current) {
              submitTriggerRef.current();
            }
            break;

          case MSG_TYPES.CANCEL:
            console.log('[WiwaEmbedded] Received CANCEL');
            if (cancelTriggerRef.current) {
              cancelTriggerRef.current();
            }
            break;
        }
      };

      window.addEventListener('message', handleMessage);

      // Timeout to show manual start option if host is unresponsive
      const timer = setTimeout(() => {
        console.warn('[WiwaEmbedded] No INIT received after 3s.');
        const debugEl = document.getElementById('wiwa-debug-overlay');
        if (debugEl) debugEl.style.display = 'flex';
      }, 3000);

      return () => {
        window.removeEventListener('message', handleMessage);
        clearTimeout(timer);
      };
    }
  }, []);

  // Callback for App to register its submit handler
  const registerSubmitTrigger = (fn: () => void) => {
    submitTriggerRef.current = fn;
  };

  const registerCancelTrigger = (fn: () => void) => {
    cancelTriggerRef.current = fn;
  };

  if (!ready) {
    return (
      <div style={{
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100vh',
        fontFamily: 'var(--wiwa-font-family, system-ui, sans-serif)',
        backgroundColor: 'var(--wiwa-background-color, #fff)'
      }}>
        <p>Čekanje inicijalizacije od host aplikacije...</p>
        <div id="wiwa-debug-overlay" style={{
          display: 'none',
          flexDirection: 'column',
          alignItems: 'center',
          marginTop: 20
        }}>
          <p style={{ color: 'orange', fontSize: 12 }}>⚠️ Nema signala od host aplikacije.</p>
          <button
            onClick={() => {
              setInitData({
                questionnaireType: 'LOCATION',
                identificatorTypeID: 1,
                identificatorValue: 'DEBUG-001'
              });
              setReady(true);
            }}
            style={{
              padding: '8px 16px',
              cursor: 'pointer',
              background: '#eee',
              border: '1px solid #ccc',
              borderRadius: 4,
              marginBottom: 8
            }}
          >
            Debug: Start (LOCATION)
          </button>
          <button
            onClick={() => {
              setInitData({
                questionnaireType: 'GREAT_QUEST',
                identificatorTypeID: 1,
                identificatorValue: 'DEBUG-002'
              });
              setReady(true);
            }}
            style={{
              padding: '8px 16px',
              cursor: 'pointer',
              background: '#eee',
              border: '1px solid #ccc',
              borderRadius: 4
            }}
          >
            Debug: Start (GREAT_QUEST)
          </button>
        </div>
      </div>
    );
  }

  return (
    <App
      embedded={isEmbedded}
      initialType={initData?.questionnaireType}
      initialIdentificator={initData?.identificatorValue}
      initialIdentificatorTypeID={initData?.identificatorTypeID}
      initialInstanceId={initData?.instanceId}
      forceReadOnly={initData?.readOnly}
      contextData={initData?.contextData}
      onRegisterSubmit={registerSubmitTrigger}
      onRegisterCancel={registerCancelTrigger}
    />
  );
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <Main />
  </StrictMode>,
);
