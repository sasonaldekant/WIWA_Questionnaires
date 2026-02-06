import { useState, useEffect } from 'react';
import { Table, Button, Space, Modal, message } from 'antd';
import { PlusOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons';
import type { ColumnsType } from 'antd/es/table';
import { questionsService } from '../services/apiService';
import type { Question } from '../types/api';

const QuestionsPage = () => {
    const [questions, setQuestions] = useState<Question[]>([]);
    const [loading, setLoading] = useState(false);

    const loadQuestions = async () => {
        try {
            setLoading(true);
            const data = await questionsService.getAll();
            setQuestions(data);
        } catch (error) {
            message.error('Failed to load questions');
            console.error(error);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadQuestions();
    }, []);

    const handleDelete = async (id: number) => {
        Modal.confirm({
            title: 'Delete Question',
            content: 'Are you sure you want to delete this question?',
            okText: 'Delete',
            okType: 'danger',
            onOk: async () => {
                try {
                    await questionsService.delete(id);
                    message.success('Question deleted successfully');
                    loadQuestions();
                } catch (error) {
                    message.error('Failed to delete question');
                    console.error(error);
                }
            },
        });
    };

    const columns: ColumnsType<Question> = [
        {
            title: 'ID',
            dataIndex: 'questionID',
            key: 'questionID',
            width: 80,
        },
        {
            title: 'Label',
            dataIndex: 'questionLabel',
            key: 'questionLabel',
            width: 150,
        },
        {
            title: 'Text',
            dataIndex: 'questionText',
            key: 'questionText',
        },
        {
            title: 'Format',
            dataIndex: ['questionFormat', 'name'],
            key: 'format',
            width: 120,
        },
        {
            title: 'Required',
            dataIndex: 'isRequired',
            key: 'isRequired',
            width: 100,
            render: (value: boolean) => (value ? 'Yes' : 'No'),
        },
        {
            title: 'Actions',
            key: 'actions',
            width: 150,
            render: (_, record) => (
                <Space>
                    <Button
                        type="link"
                        icon={<EditOutlined />}
                        onClick={() => message.info('Edit functionality coming soon')}
                    >
                        Edit
                    </Button>
                    <Button
                        type="link"
                        danger
                        icon={<DeleteOutlined />}
                        onClick={() => handleDelete(record.questionID)}
                    >
                        Delete
                    </Button>
                </Space>
            ),
        },
    ];

    return (
        <div>
            <div style={{ marginBottom: 16, display: 'flex', justifyContent: 'space-between' }}>
                <h2>Questions</h2>
                <Button
                    type="primary"
                    icon={<PlusOutlined />}
                    onClick={() => message.info('Create functionality coming soon')}
                >
                    New Question
                </Button>
            </div>
            <Table
                columns={columns}
                dataSource={questions}
                loading={loading}
                rowKey="questionID"
                pagination={{ pageSize: 10 }}
            />
        </div>
    );
};

export default QuestionsPage;
