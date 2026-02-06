export interface Question {
    questionID: number;
    questionText: string;
    questionLabel?: string;
    questionOrder?: number;
    questionFormatID?: number;
    parentQuestionID?: number;
    specificQuestionTypeID?: number;
    readOnly?: boolean;
    isRequired?: boolean;
    validationPattern?: string;
    questionFormat?: QuestionFormat;
    parentQuestion?: Question;
    predefinedAnswers?: PredefinedAnswer[];
}

export interface QuestionFormat {
    questionFormatID: number;
    name: string;
    description?: string;
    code: string;
}

export interface PredefinedAnswer {
    predefinedAnswerID: number;
    questionID: number;
    answer: string;
    code?: string;
    preSelected?: boolean;
    statisticalWeight?: number;
    displayOrder: number;
}
