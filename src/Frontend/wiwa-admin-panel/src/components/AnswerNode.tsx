import React, { memo } from 'react';
import { Handle, Position } from 'reactflow';
import './AnswerNode.css';

interface AnswerNodeData {
    label: string;
    answerText?: string;
    code?: string;
    isPreSelected?: boolean;
    onDelete?: () => void;
}

interface AnswerNodeProps {
    data: AnswerNodeData;
    isConnectable: boolean;
}

const AnswerNode: React.FC<AnswerNodeProps> = ({ data, isConnectable }) => {
    return (
        <div className="answer-node">
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

            <div className="node-header answer-header">
                <span className="node-label">{data.label}</span>
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

            <div className="node-content">
                <p className="node-text">{data.answerText || 'Double-click to edit'}</p>
                {data.code && <span className="node-code">Code: {data.code}</span>}
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

export default memo(AnswerNode);
