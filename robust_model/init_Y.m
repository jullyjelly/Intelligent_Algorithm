function Y=init_Y(m,num_E,num_N,n_qlevel,G,cost_jk,quality_index,rjk)
%初始化新设施所在位点以及质量水平
% sort_rjk=sortrows(rjk,4);
% for i=1:num_N
%     Y(i,:)=[sort_rjk(i,4),sort_rjk(i,2),sort_rjk(i,3)];
% end%遇到预算非常小的时候，初始候选解无法正常生成
index_l_N=sort(randperm(m-num_E,num_N));%新设施位点索引
index_q_N=randsrc(1,num_N,(1:n_qlevel));
Y=zeros(num_N,3);
for i=1:num_N
    %选择哪个设施的哪个质量，设施索引，质量索引
    Y(i,:)=[cost_jk(index_l_N(i),index_q_N(i)),cost_jk(index_l_N(i),n_qlevel+1),index_q_N(i)];
end
Y=budget_limit(G,num_N,cost_jk,n_qlevel,quality_index,Y);
end