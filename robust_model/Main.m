% close all;clear all;clc
% Wi=xlsread("Wi_data.xls");
% dij=xlsread("dij_data.xls");
% Qj=xlsread("Qj_data.xls");
% fj=xlsread("fj_data.xlsx");%固定成本
tic;

[m,~]=size(Wi);
num_E=5;
Rc=400;
Rq=800;
G=5000;%预算
q_t=40;
gamma=0.7;
alpha=5;

n_qlevel=5;%质量等级数
[quality_N,quality_index]=al_q_level(n_qlevel);

location_E=[9 28 63 84 100];%num_N个已有设施

%在不同潜在位点新建不同质量的新设施需要的花费
cost_jk_all=cal_cost(alpha,quality_N,n_qlevel,m,fj);
cost_jk=del_E(n_qlevel,location_E,cost_jk_all);


rjk=ones((m-num_E)*n_qlevel,4);
for i=1:(m-num_E)
    for j=1:n_qlevel
        rjk((i-1)*n_qlevel+j,3)=cost_jk(i,n_qlevel+1);
        rjk((i-1)*n_qlevel+j,4)=j;
        rjk((i-1)*n_qlevel+j,2)=cost_jk(i,j);
    end
end

[oz_Y,Y,QY]=greedy_init(m,num_E,location_E,dij,Rc,Rq,q_t,quality_N,Qj,Wi,gamma,n_qlevel,cost_jk,G);

% [oz_Y,Y]=init_Y(m,num_E,n_qlevel,G,cost_jk);
% [s,~]=size(Y);
% QY=min_market(m,num_E,location_E,s,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma);


for gen=1:4000
    ex_Y=Y;
    ex_QY=QY;
    ex_oz_Y=oz_Y;

    
    [Y,oz_Y]=crossover(Y,oz_Y,rjk,G);
    [s,~]=size(Y);
    QY=min_market(m,num_E,location_E,s,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma);
    
   
    
    r1=randsrc(1,1,(1:s));
    r2=randsrc(1,1,(1:s));
    Y1=Y;
    if Y1(r1,3)~=1 && Y1(r2,3)~=n_qlevel
        

        Y1(r1,3)=Y1(r1,3)-1;
        Y1(r2,3)=Y1(r2,3)+1;
        Y1(r1,1)=cost_jk_all(Y1(r1,2),Y1(r1,3));
        Y1(r2,1)=cost_jk_all(Y1(r2,2),Y1(r2,3));
        s=size(Y1,1);
        QY1=min_market(m,num_E,location_E,s,dij,Rc,Rq,Y1,q_t,quality_N,Qj,Wi,gamma);
        if QY1>QY
           QY=QY1;
           Y=Y1;
           oz_Y(:,1:2)=0;
           for i=1:s
                [~,index,~]=intersect(oz_Y(:,3:4),Y(i,2:3),"rows");
                oz_Y(index,1)=1;oz_Y(index,2)=Y(i,1);
           end
        end
    end
    
%     qn=sum(Y(:,3));
%     oz_Y(:,1:2)=0;
%     Y(:,3)=1;
%     for i=1:size(Y,1)
%         Y(i,1)=cost_jk_all(Y(i,2),Y(i,3));
%         [~,index,~]=intersect(oz_Y(:,3:4),Y(i,2:3),"rows");
%         oz_Y(index,1)=1;oz_Y(index,2)=Y(i,1);
%     end
%     s=size(Y,1);
%     QY=min_market(m,num_E,location_E,s,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma);
%     [Y,oz_Y,QY]=addquality3(Y,oz_Y,cost_jk,n_qlevel,QY,m,num_E,location_E,dij,Rc,Rq,q_t,quality_N,Qj,Wi,gamma,qn);
 
%     [Y,QY,oz_Y]=opt_2(m,num_E,location_E,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma,QY,cost_jk_all,oz_Y);

    inter=intersect(ex_Y,Y,"rows");
    d1=intersect(setxor(ex_Y,Y,"rows"),ex_Y,"rows");
    d2=intersect(setxor(ex_Y,Y,"rows"),Y,"rows");
    
    if QY>ex_QY
        [~,index,~]=intersect(rjk(:,3:4),Y(:,2:3),"rows");
        rjk(index,1)=rjk(index,1)+1;
        [~,index,~]=intersect(rjk(:,3:4),d2(:,2:3),"rows");
        rjk(index,1)=rjk(index,1)+2;
    else
        QY=ex_QY;
        Y=ex_Y;
        oz_Y=ex_oz_Y;
%         [~,index,~]=intersect(rjk(:,3:4),d2(:,2:3),"rows");
%         rjk(index,1)=rjk(index,1)-1;
    end
    x=find(rjk(:,1)==0);
    rjk(x,1)=1;
end


oz_Y(:,1:2)=0;
Y(:,3)=1;
for i=1:size(Y,1)
    Y(i,1)=cost_jk_all(Y(i,2),Y(i,3));
    [~,index,~]=intersect(oz_Y(:,3:4),Y(i,2:3),"rows");
    oz_Y(index,1)=1;oz_Y(index,2)=Y(i,1);
end
s=size(Y,1);
QY=min_market(m,num_E,location_E,s,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma);

[Y,oz_Y,QY]=addquality(G,Y,oz_Y,alpha,cost_jk,n_qlevel,QY,m,num_E,location_E,dij,Rc,Rq,q_t,quality_N,Qj,Wi,gamma);


Y=sortrows(Y,2);
disp("最大—最小市场份额：");
disp(QY);
disp("放置位点：");
disp(Y);
disp("成本：");
disp(sum(Y(:,1)));

toc;
