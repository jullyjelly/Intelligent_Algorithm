function [QY,xstar]=Market_N(Qj,dij,N_exist,N_new,d_t,q_t,yjk,Wi,gamma)
[ACY,AQY]=Attraction_obj(Qj,dij,N_exist,N_new,d_t,q_t,yjk);  %���ݽ�yjk�����½���ҵ��ȡ�Ŀͻ������������������������
ai=ACY-AQY;
bi=Wi;
lambda=gamma*sum(Wi);
[QY1,xstar]=SortA(ai,bi,lambda);
QY=QY1+sum(Wi.*AQY);     %�����龰��yjk����Ӧ���½���ҵ����ȡ��������