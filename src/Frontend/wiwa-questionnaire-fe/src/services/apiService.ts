import axios from 'axios';
import type { QuestionnaireSchemaDto, QuestionTypeDto } from '../types/api';

const API_BASE_URL = 'http://localhost:5238/api'; // Correct port from launchSettings.json

export const questionnaireApi = {
    getSchema: async (typeCode: string): Promise<QuestionnaireSchemaDto> => {
        const response = await axios.get<QuestionnaireSchemaDto>(`${API_BASE_URL}/Questionnaire/schema/${typeCode}`);
        return response.data;
    },
    getTypes: async (): Promise<QuestionTypeDto[]> => {
        const response = await axios.get<QuestionTypeDto[]>(`${API_BASE_URL}/Questionnaire/types`);
        return response.data;
    },
    evaluateRule: async (ruleId: number, inputs: Record<number, string>): Promise<{ value: string | null }> => {
        // Convert input map to generic dictionary if needed, but JS object works usually for JSON
        const response = await axios.post<{ value: string | null }>(`${API_BASE_URL}/Questionnaire/evaluate-rule`, {
            ruleId,
            inputs
        });
        return response.data;
    }
};
