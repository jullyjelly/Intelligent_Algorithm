%在一范围为(0,0)到(100，100)的矩形区域内，散布着40个连锁超市，各个连锁超市的坐标及需求量见表1。
%要求在该矩形区域内确定9个位置建立配送中心。已知各配送中心容量不限，每个超市只由一个配送中心负责配送，
%使得9个配送中心到所有超市的总配送物流量（距离×需求量）最小，其中配送中心到超市的距离为直线距离。
%请建立该问题的模型，利用粒子群算法编程求解上述问题。
%表1 各需求点坐标及需求量
%No.	坐标	需求量	No.	 坐标	需求量	No.	  坐标	需求量	No.	  坐标	需求量
%1	   (1,0)	10		11	(82,95)	  30	21	(56,34)	  70	31	(17,80)	  90
%2	   (33,3)	10		12	(21,42)	  40	22	(86,26)	  20	32	(29,33)	  50
%3	   (35,21)	40		13	(95,83)	  30	23	(17,42)	  10	33	(40,24)	  20
%4	   (53,19)	10		14	(92,81)	  20	24	(69,16)	  20	34	(41,5)	  40
%5	   (70,94)	40		15	(45,60)	  20	25	(53,64)	  30	35	(49,98)	  10
%6	   (27,44)	30		16	(66,59)	  30	26	(62,0)	  30	36	(0,40)	  40
%7	   (10,69)	10		17	(54,72)	  20	27	(78,26)	  30	37	(6,7)	  20
%8	   (56,4)	20		18	(11,40)	  10	28	(46,38)	  20	38	(25,97)	  20
%9	   (16,81)	40		19	(12,67)	  20	29	(37,58)	  50	39	(35,40)	  30
%10	   (68,76)	30		20	(47,49)	  30	30	(60,27)	  30	40	(19,19)	  50

close all;clear all;clc;
market=[1 0 10;33 3 10;35 21 40;53 19 10;70 94 40;
    27 44 30;10 69 10;56 4 20;16 81 40;68 76 30;
    82 95 30;21 42 40;95 83 30;92 81 20;45 60 20;
    66 59 30;54 72 20;11 40 10;12 67 20;47 49 30;
    56 34 70;86 26 20;17 42 10;69 16 20;53 64 30;
    62 0 30;78 26 30;46 38 20;37 58 50;60 27 30;
    17 80 90;29 33 50;40 24 20;41 5 40;49 98 10;
    0 40 40;6 7 20;25 97 20;35 40 30;19 19 50];

dmin=0;
dmax=100;
vmin=-20;
vmax=20;
size=20;%粒子数
c1=2;
c2=2;
maxgen=300;

%初始化粒子和速度
center=randsrc(20,18,(0:100));
v=randsrc(20,18,(-20:20));

[chosepop,flowpop]=calminflow( market,center,size);
pbest=center;
bestpflow=flowpop;
[~,mindex]=sort(bestpflow);
gbest=pbest(mindex(1,1),:);
bestgflow=bestpflow(mindex(1,1),:);


gflowpop=[];
for dai=1:maxgen
    [center,v]=update(pbest,gbest,v,c1,c2,vmax,vmin,dmax,dmin,size,center);
    [chosepop,flowpop]=calminflow( market,center,size);
    for i=1:size
        if flowpop(i,:)<bestpflow(i,:)
            bestpflow(i,:)=flowpop(i,:);
            pbest(i,:)=center(i,:);
        end
    end
    [~,mindex]=sort(bestpflow);
    gbest=pbest(mindex(1,1),:);
    bestgflow=bestpflow(mindex(1,1),:);
    gflowpop=[gflowpop;bestgflow];
end
% disp(pbest)
disp(gbest)
% disp(flowpop)
disp(bestgflow)
for i=1:2:18
    distcenter(((i+1)/2 ),1)=gbest(1,i);
    distcenter(((i+1)/2 ),2)=gbest(1,i+1);   %转化为位置坐标
end
 disp(distcenter)
 plot(market(:,1),market(:,2),'.')
for i=1:40
    text(market(i,1),market(i,2),num2str(i));
end
hold on;
plot(distcenter(:,1),distcenter(:,2),'o') 
hold on;

[minchose,minflow]=findmin(distcenter,market);
disp(minchose)
for i=1:9
    h=find(minchose==i);
    l=length(h);
    for j=1:l
        %连接配送中心和配送点
        line([market(h(1,j),1);distcenter(i,1)], ...
            [market(h(1,j),2);distcenter(i,2)])
        hold on;
    end
end

figure;
x=1:maxgen;
y=gflowpop;
plot(x,y)


function [chosepop,flowpop]=calminflow( market,center,size)
flowpop=[];
chosepop=[];
for num=1:size
    for i=1:2:18
       distcenter(((i+1)/2 ),1)=center(num,i);
       distcenter(((i+1)/2 ),2)=center(num,i+1);
    end
    %计算最佳分配方案和最小物流量
    [minchose,minflow]=findmin(distcenter,market);
    flowpop=[flowpop;minflow];
    chosepop=[chosepop;minchose];
end
end
function [center,v]=update(pbest,gbest,v,c1,c2,vmax,vmin,dmax,dmin,size,center)
    for i=1:size
        v(i,:)=v(i,:)+c1*rand*(pbest(i,:)-center(i,:))+ ...
            c2*rand*(gbest-center(i,:));
        for j=1:18
            if v(i,j)>vmax 
                v(i,j)=vmax;
            elseif v(i,j)<vmin
                v(i,j)=vmin;
            end
        end
    end
    center=center+v;
    for i=1:size
        for j=1:18
            if center(i,j)>dmax
                center(i,j)=dmax;
            elseif center(i,j)<dmin
                center(i,j)=dmin;
            end
        end
    end
end   

function [minchose,minflow]=findmin(distcenter,market)
    mindistance=0;
    minflow=0;
    minchose=zeros(1,40);
    for j=1:40
        distancepop=[];
        for k=1:9
            distance=((market(j,1)-distcenter(k,1))^2+ ...
                (market(j,2)-distcenter(k,2))^2)^0.5;
            distancepop=[distancepop;distance];
        end
        [B,index]=sort(distancepop);
        mindistance=mindistance+B(1,1);
        minflow=minflow+B(1,1)*market(j,3);
        minchose(1,j)=index(1,1);
    end
end
