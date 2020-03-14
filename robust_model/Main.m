% close all;clear all;clc
Wi=xlsread("Wi_data.xls");
dij=xlsread("dij_data.xls");
Qj=xlsread("Qj_data.xls");
fj=xlsread("fj_data.xlsx");%固定成本
[m,~]=size(Wi);
num_E=5;
num_N=4;
Rc=400;
Rq=800;
G=5000;%预算
q_t=40;
gamma=0.6;

n_qlevel=5;%质量等级数
[alpha,quality_N,quality_index]=al_q_level(n_qlevel);

location_E=[9 28 63 84 100];%num_N个已有设施

%在不同潜在位点新建不同质量的新设施需要的花费
cost_jk_all=cal_cost(alpha,quality_N,n_qlevel,m,fj);
cost_jk=del_E(n_qlevel,location_E,cost_jk_all);


rjk=ones((m-num_E)*n_qlevel,4);
for i=1:(m-num_E)
    for j=1:n_qlevel
        rjk((i-1)*n_qlevel+j,2)=cost_jk(i,n_qlevel+1);
        rjk((i-1)*n_qlevel+j,3)=j;
        rjk((i-1)*n_qlevel+j,4)=cost_jk(i,j);
    end
end
[size_rjk,~]=size(rjk);

Y=init_Y(m,num_E,num_N,n_qlevel,G,cost_jk,quality_index,rjk);
QY=min_market(m,num_E,location_E,num_N,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma);

max_QY=0;
max_QYpop=zeros(3000,1);
for gen=1:3000
    ex_Y=Y;
    ex_QY=QY;
    cross_index1=randsrc(1,1,(1:num_N));
    Y=crossover(cost_jk,num_N,n_qlevel,cross_index1,Y,rjk,G);
    QY=min_market(m,num_E,location_E,num_N,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma);
    inter=intersect(ex_Y,Y,"rows");
    d1=intersect(setxor(ex_Y,Y,"rows"),ex_Y,"rows");
    d2=intersect(setxor(ex_Y,Y,"rows"),Y,"rows");
    
    if QY>ex_QY
        [~,index,~]=intersect(rjk(:,2:3),Y(:,2:3),"rows");
        rjk(index,1)=rjk(index,1)+1;
        [~,index,~]=intersect(rjk(:,2:3),d1(:,2:3),"rows");
        rjk(index,1)=rjk(index,1)-1;
    else
        QY=ex_QY;
        Y=ex_Y;
        [~,index,~]=intersect(rjk(:,2:3),d2(:,2:3),"rows");
        rjk(index,1)=rjk(index,1)-1;
    end
    x=find(rjk(:,1)==0);
    rjk(x,1)=1;
    
    if QY>max_QY
        max_QY=QY;
        max_Y=Y;
    end
    max_QYpop(gen,1)=max_QY;
end

Y=sortrows(Y,2);
disp("最大—最小市场份额：");
disp(max_QY);
disp("放置位点：");
disp(Y);
disp("成本：");
disp(sum(Y(:,1)));

