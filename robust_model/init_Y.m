function Y=init_Y(m,num_E,num_N,n_qlevel,G,cost_jk,quality_index,rjk)
%��ʼ������ʩ����λ���Լ�����ˮƽ
% sort_rjk=sortrows(rjk,4);
% for i=1:num_N
%     Y(i,:)=[sort_rjk(i,4),sort_rjk(i,2),sort_rjk(i,3)];
% end%����Ԥ��ǳ�С��ʱ�򣬳�ʼ��ѡ���޷���������
index_l_N=sort(randperm(m-num_E,num_N));%����ʩλ������
index_q_N=randsrc(1,num_N,(1:n_qlevel));
Y=zeros(num_N,3);
for i=1:num_N
    %ѡ���ĸ���ʩ���ĸ���������ʩ��������������
    Y(i,:)=[cost_jk(index_l_N(i),index_q_N(i)),cost_jk(index_l_N(i),n_qlevel+1),index_q_N(i)];
end
Y=budget_limit(G,num_N,cost_jk,n_qlevel,quality_index,Y);
end