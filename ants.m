%设有19个客户随机分布于长为10km的正方形区域内。配送中心位于区域正中央，其坐标为（0，0）。
%各客户的坐标及需求量如下表所示，配送中心拥有若干辆载重量为9t的车辆，对客户进行服务时都从配送中心出发，
%完成对客户点的配送任务后再回到配送中心。现要求以最少的车辆数、最小的车辆总行程来完成货物的派送任务，
%请用蚁群算法求解该VRP问题(vehicle routing problem)。

%No#	   		1	2	3	4	5	6	7	8	9	10
%横坐标		0	0	0	-1	-3	3	-4	-4	1	1
%纵坐标		0	-1	3	-2	-3	-1	0	-1	-2	-1
%配送量(t)	0	1.5	1.8	2.0	0.8	1.5	1.0	2.5	3.0	1.7
%No#	        11	12	13	14	15	16	17	18	19	20
%横坐标		1	3	-3	2	1	2	2	1	-3	-1
%纵坐标		3	4	0	0	-3	-1	1	-4	2	-1
%配送量(t)	0.6	0.2	2.4	1.9	2.0	0.7	0.5	2.2	3.1	0.1




locate=[0 0 0;0 -1 1.5;0 3 1.8;-1 -2 2.0;-3 -3 0.8;
        3 -1 1.5; -4 0 1;-4 -1 2.5; 1 -2 3; 1 -1 1.7;
        1 3 0.6; 3 4 0.2; -3 0 2.4;2 0 1.9;1 -3 2;
        2 -1 0.7; 2 1 0.5; 1 -4 2.2;-3 2 3.1;-1 -1 0.1];
%生成距离矩阵
[m,~]=size(locate);
len=zeros(m,m);
for i=1:m
    for j=1:m
        x1=locate(i,1);
        x2=locate(j,1);
        y1=locate(i,2);
        y2=locate(j,2);
        d=sqrt((x1-x2)^2+(y1-y2)^2);
        len(i,j)=d;
    end
end
nij=1./len;
load=9;
C=1;%常数
finfo=ones(m,m)*C;%初始信息素
Q=100;
antnum=20;
minlen=80;%最小总长度
maxgen=100;
BR=[];
for dai=1:maxgen
    %获取蚂蚁初始行走路径
    [antspath,antsjin]=GetRouth(load,finfo,antnum,nij,m,locate);
    %获取蚂蚁行走总路线长度
    [city,routeL]=GetLength(antspath,antnum,len); 
    %更新每条边的信息素增量
    finfo=GetInfomation(m,city,antspath,routeL,Q,finfo,antnum); 
    %获取每一代的最优
    [bestlen,bestpath]=GetBest(routeL,antspath);
    if bestlen<minlen
        minlen=bestlen;
        minpath=bestpath;
    end
    pathlocate=[];%路径的具体位置
    for i=1:city
        pathlocate=[pathlocate;locate(minpath(i),1:2)];
    end
    plot(pathlocate(:,1),pathlocate(:,2), ...
        'o','MarkerFaceColor','b','linestyle','-')
    axis([-5 5 -5 5]);
    grid on;
    pause(0.03)
    BR=[BR;minlen];

end
disp(minlen)
disp(minpath)
figure;
x=1:maxgen;
y=BR';
plot(x,y)


function [antspath,antsjin]=GetRouth(load,finfo,antnum,nij,m,locate)
antspath=[];
antsjin=[];
for k=1:antnum
    path=[1];
    unban=(2:m);
    a=0;
    jin=[];
    for i=1:m+2
        disv=locate(path(i),3);
        if a+disv<=load
            a=a+disv;
        else
            a=0;
            last1=length(path);
            last2=length(jin);
            unban=[unban,path(last1)];
            path(last1)=[];
            jin(last2)=[];
            path=[path,1];  
        end
        unbanlen=length(unban);%未被禁忌城市数
        sp=[];
        for j=1:unbanlen
            sp=[sp;(finfo(path(i),unban(j)))*(nij(path(i),unban(j)))^5];
            %每条路径上的信息素singlep     
        end
        ssp=cumsum(sp);%信息素向下叠加求和
        sumsp=ssp(unbanlen);%信息素总和
        pij=ssp./sumsp;%信息素轮盘
        pij=[0;pij];
        lunpan=rand;
        for u=1:unbanlen
            if lunpan<pij(u+1,1)&&lunpan>=pij(u,1)
                path=[path,unban(u)];
                jin=[jin,unban(u)];
                unban(u)=[];
            end
        end
    end
    path=[path,1];
    antspath=[antspath;path];
    antsjin=[antsjin;jin];
end
end



function [city,routeL]=GetLength(antspath,antnum,len)
[~,city]=size(antspath);%获取蚂蚁行走的城市数
    routeL=[];
    for i=1:antnum
        L=0;
        for j=1:city-1
            L=L+len(antspath(i,j),antspath(i,j+1));%总距离
        end
        routeL=[routeL;L];

    end
end

function finfo=GetInfomation(m,city,antspath,routeL,Q,finfo,antnum)
zinfo=zeros(m,m);
    p=0.5;%信息素消散比例
    for i=1:antnum
        for j=1:city-1
            zinfo(antspath(i,j),antspath(i,j+1))= ...
                zinfo(antspath(i,j),antspath(i,j+1))+Q/(routeL(i,1));
            %新增加的信息素
        end
    end
    finfo=(1-p).*finfo+zinfo;%更新父代信息素
end

function [bestlen,bestpath]=GetBest(routeL,antspath)
    newantspath=[];
    [B,index]=sort(routeL);
    bestlen=B(1,1);
    bestpath=antspath(index(1),:);
end
