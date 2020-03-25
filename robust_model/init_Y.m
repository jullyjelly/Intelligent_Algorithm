function [oz_Y,Y]=init_Y(m,num_E,n_qlevel,G,cost_jk)
%初始化新设施所在位点以及质量水平
avg=mean(mean(cost_jk(:,1:5)));
avg_num_N=ceil(G/avg);

index_l_N=sort(randperm(m-num_E,avg_num_N));%新设施位点索引
index_q_N=randsrc(1,avg_num_N,(1:n_qlevel));
oz_Y=zeros((m-num_E)*n_qlevel,4);
for i=1:avg_num_N
    oz_Y((index_l_N(i)-1)*n_qlevel+index_q_N(i),1)=1;
    oz_Y((index_l_N(i)-1)*n_qlevel+index_q_N(i),3)=cost_jk(index_l_N(i),n_qlevel+1);
    oz_Y((index_l_N(i)-1)*n_qlevel+index_q_N(i),4)=index_q_N(i);
    oz_Y((index_l_N(i)-1)*n_qlevel+index_q_N(i),2)=cost_jk(index_l_N(i),index_q_N(i));
end

for i=1:(m-num_E)
    for j=1:n_qlevel
        oz_Y((i-1)*n_qlevel+j,3)=cost_jk(i,n_qlevel+1);
        oz_Y((i-1)*n_qlevel+j,4)=j;
    end
end
x=find(oz_Y(:,2)~=0);
Y=oz_Y(x,2:4);

while sum(oz_Y(:,2))>G
    [s,~]=size(Y);
    cross_index=randsrc(1,1,(1:s));
    [~,x,~]=intersect(oz_Y(:,3:4),Y(cross_index,2:3),"rows");
    oz_Y(x,1)=0;oz_Y(x,2)=0;
    Y(cross_index,:)=[];
end
end