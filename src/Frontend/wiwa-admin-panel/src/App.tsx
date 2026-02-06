import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import { Layout, Menu } from 'antd';
import { TableOutlined, ApartmentOutlined } from '@ant-design/icons';
import QuestionsPage from './pages/QuestionsPage';
import FlowBuilderPage from './pages/FlowBuilderPage';
import DashboardPage from './pages/DashboardPage';
import './App.css';

const { Header, Sider, Content } = Layout;

function App() {
  return (
    <BrowserRouter>
      <Layout style={{ minHeight: '100vh' }}>
        <Header style={{ background: '#001529', color: 'white', fontSize: '20px', fontWeight: 'bold', display: 'flex', alignItems: 'center' }}>
          WIWA Admin Panel
        </Header>
        <Layout>
          <Sider width={200} style={{ background: '#fff' }}>
            <Menu mode="inline" defaultSelectedKeys={['1']} style={{ height: '100%', borderRight: 0 }}>
              <Menu.Item key="1" icon={<ApartmentOutlined />}>
                <Link to="/">Dashboard</Link>
              </Menu.Item>
              <Menu.Item key="2" icon={<TableOutlined />}>
                <Link to="/questions">Questions (Legacy)</Link>
              </Menu.Item>
            </Menu>
          </Sider>
          <Content style={{ padding: '24px', background: '#f0f2f5' }}>
            <Routes>
              <Route path="/" element={<DashboardPage />} />
              <Route path="/questions" element={<QuestionsPage />} />
              <Route path="/flow-builder" element={<FlowBuilderPage />} />
              <Route path="/flow-builder/:id" element={<FlowBuilderPage />} />
            </Routes>
          </Content>
        </Layout>
      </Layout>
    </BrowserRouter>
  );
}

export default App;
