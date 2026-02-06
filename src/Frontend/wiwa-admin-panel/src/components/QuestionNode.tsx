import React, { memo } from 'react';
import { Handle, Position } from 'reactflow';
import './QuestionNode.css';

interface QuestionNodeData {
    label?: string;
    questionText?: string;
    questionFormat?: string;
    isChild?: boolean;
    childType?: 'parent-child' | 'subquestion' | null;
    isRequired?: boolean;
    isComputed?: boolean;
    specificQuestionTypeID?: number;
    onDelete?: () => void;
}

interface QuestionNodeProps {
    data: QuestionNodeData;
    isConnectable: boolean;
}

const QuestionNode: React.FC<QuestionNodeProps> = ({ data, isConnectable }) => {
    // Determine CSS class based on childType
    let nodeClass = 'question-node';
    if (data.childType === 'parent-child') {
        nodeClass += ' parent-child-question';
    } else if (data.childType === 'subquestion') {
        nodeClass += ' subquestion-child';
    }

    return (
        <div className={nodeClass}>
            {/* Top Handles */}
            {/* Top Handles - increased density (7 handles) */}
            <Handle type="target" position={Position.Top} id="top-5" isConnectable={isConnectable} className="handle-top handle-extra" style={{ left: '5%' }} />
            <Handle type="target" position={Position.Top} id="top-20" isConnectable={isConnectable} className="handle-top handle-extra" style={{ left: '20%' }} />
            <Handle type="target" position={Position.Top} id="top-35" isConnectable={isConnectable} className="handle-top handle-extra" style={{ left: '35%' }} />
            <Handle type="target" position={Position.Top} id="top" isConnectable={isConnectable} className="handle-top" style={{ left: '50%' }} />
            <Handle type="target" position={Position.Top} id="top-65" isConnectable={isConnectable} className="handle-top handle-extra" style={{ left: '65%' }} />
            <Handle type="target" position={Position.Top} id="top-80" isConnectable={isConnectable} className="handle-top handle-extra" style={{ left: '80%' }} />
            <Handle type="target" position={Position.Top} id="top-95" isConnectable={isConnectable} className="handle-top handle-extra" style={{ left: '95%' }} />

            {/* Left Handles */}
            {/* Left Handles - 4 handles */}
            <Handle type="target" position={Position.Left} id="left-20" isConnectable={isConnectable} className="handle-left handle-extra" style={{ top: '20%' }} />
            <Handle type="target" position={Position.Left} id="left-40" isConnectable={isConnectable} className="handle-left handle-extra" style={{ top: '40%' }} />
            <Handle type="target" position={Position.Left} id="left-60" isConnectable={isConnectable} className="handle-left handle-extra" style={{ top: '60%' }} />
            <Handle type="target" position={Position.Left} id="left-80" isConnectable={isConnectable} className="handle-left handle-extra" style={{ top: '80%' }} />

            {/* Right Handles - 4 handles */}
            <Handle type="source" position={Position.Right} id="right-20" isConnectable={isConnectable} className="handle-right handle-extra" style={{ top: '20%' }} />
            <Handle type="source" position={Position.Right} id="right-40" isConnectable={isConnectable} className="handle-right handle-extra" style={{ top: '40%' }} />
            <Handle type="source" position={Position.Right} id="right-60" isConnectable={isConnectable} className="handle-right handle-extra" style={{ top: '60%' }} />
            <Handle type="source" position={Position.Right} id="right-80" isConnectable={isConnectable} className="handle-right handle-extra" style={{ top: '80%' }} />

            <div className="node-header">
                <span className="node-label">{data.label || 'Question'}</span>
                <div className="node-badges">
                    {data.isRequired && <span className="badge required">*</span>}
                    {data.isComputed && <span className="badge computed">C</span>}
                    <span
                        className="node-delete-btn"
                        onClick={(e) => {
                            e.stopPropagation();
                            data.onDelete?.();
                        }}
                    >
                        ×
                    </span>
                </div>
            </div>

            <div className="node-content">
                <p className="node-text">{data.questionText || 'Double-click to edit'}</p>
                {data.questionFormat && (
                    <span className="node-format">{data.questionFormat}</span>
                )}
            </div>

            {/* Bottom Handles */}
            {/* Bottom Handles - increased density (7 handles) */}
            <Handle type="source" position={Position.Bottom} id="bottom-5" isConnectable={isConnectable} className="handle-bottom handle-extra" style={{ left: '5%' }} />
            <Handle type="source" position={Position.Bottom} id="bottom-20" isConnectable={isConnectable} className="handle-bottom handle-extra" style={{ left: '20%' }} />
            <Handle type="source" position={Position.Bottom} id="bottom-35" isConnectable={isConnectable} className="handle-bottom handle-extra" style={{ left: '35%' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" isConnectable={isConnectable} className="handle-bottom" style={{ left: '50%' }} />
            <Handle type="source" position={Position.Bottom} id="bottom-65" isConnectable={isConnectable} className="handle-bottom handle-extra" style={{ left: '65%' }} />
            <Handle type="source" position={Position.Bottom} id="bottom-80" isConnectable={isConnectable} className="handle-bottom handle-extra" style={{ left: '80%' }} />
            <Handle type="source" position={Position.Bottom} id="bottom-95" isConnectable={isConnectable} className="handle-bottom handle-extra" style={{ left: '95%' }} />
        </div>
    );
};

export default memo(QuestionNode);
