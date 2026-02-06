import React, { useEffect, useState } from 'react';
import { Card, Col, Row, Button, Statistic, Spin, Typography, message } from 'antd';
import { PlusOutlined, EditOutlined, ApartmentOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';
import { questionnaireTypesService } from '../services/flowApiService';
import type { QuestionnaireType } from '../types/flow';

const { Title } = Typography;

const DashboardPage: React.FC = () => {
    const [loading, setLoading] = useState(true);
    const [types, setTypes] = useState<QuestionnaireType[]>([]);
    const navigate = useNavigate();

    useEffect(() => {
        loadData();
    }, []);

    const loadData = async () => {
        try {
            const data = await questionnaireTypesService.getWithCounts();
            setTypes(data);
        } catch (error) {
            console.error(error);
            message.error('Failed to load questionnaire types');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div style={{ padding: '24px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 24 }}>
                <Title level={2} style={{ margin: 0 }}>
                    <ApartmentOutlined style={{ marginRight: 12 }} />
                    Questionnaire Flows
                </Title>
                <Button type="primary" icon={<PlusOutlined />} size="large" onClick={() => navigate('/flow-builder/new')}>
                    Create New Logic
                </Button>
            </div>

            {loading ? (
                <div style={{ textAlign: 'center', marginTop: 50 }}>
                    <Spin size="large" tip="Loading questionnaires..." />
                </div>
            ) : (
                <Row gutter={[24, 24]}>
                    {types.map(t => (
                        <Col xs={24} sm={12} md={8} lg={6} key={t.questionnaireTypeID}>
                            <Card
                                title={t.name}
                                extra={
                                    <Button
                                        type="link"
                                        icon={<EditOutlined />}
                                        onClick={() => navigate(`/flow-builder/${t.questionnaireTypeID}`)}
                                    >
                                        Edit
                                    </Button>
                                }
                                hoverable
                                actions={[
                                    <Button type="text" block onClick={() => navigate(`/flow-builder/${t.questionnaireTypeID}`)}>
                                        Open Flow Builder
                                    </Button>
                                ]}
                            >
                                <Statistic title="Active Instances" value={t.questionnaireCount} suffix="records" />
                                <div style={{ marginTop: 12, color: '#888', fontSize: '12px' }}>
                                    System Code: <code style={{ background: '#f5f5f5', padding: '2px 4px', borderRadius: '4px' }}>{t.code}</code>
                                </div>
                            </Card>
                        </Col>
                    ))}

                    {/* Empty State / Add New Placeholder */}
                    <Col xs={24} sm={12} md={8} lg={6}>
                        <Button
                            type="dashed"
                            style={{ width: '100%', height: '100%', minHeight: '180px', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}
                            onClick={() => navigate('/flow-builder/new')}
                        >
                            <PlusOutlined style={{ fontSize: '24px', marginBottom: '8px' }} />
                            <span>Create New Questionnaire Type</span>
                        </Button>
                    </Col>
                </Row>
            )}
        </div>
    );
};

export default DashboardPage;
