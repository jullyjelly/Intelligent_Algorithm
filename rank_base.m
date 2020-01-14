% close all;clear all;clc;

% data
% data=xlsread("mydata.xlsx");
% beta=30;%覆盖半径
% sigma=12;%质量阈值

% data=xlsread("data5.xlsx");%索引，x，y，质量，需求量
% beta=2000;%覆盖半径
% sigma=180;%质量阈值

in=5;%locate中参数个数
[m,~]=size(data);

locate=zeros(m,in);
locate(:,1:5)=data;
plot(locate(:,2),locate(:,3),"k.");
hold on;
c=3;%公司数
n=3;%每家公司设施数
r=5;%新进入公司设施数

dij=zeros(m,m);
for i=1:m
    if locate(i,4)>sigma
        plot(locate(i,2),locate(i,3),"m.");
    end
    text(locate(i,2)+1,locate(i,3)+1,num2str(i));
   for j=1:m
       dij(i,j)=((locate(i,2)-locate(j,2))^2+(locate(i,3)-locate(j,3))^2)^0.5;
   end
end

%吸引力矩阵，i需求点，j设施
aij=zeros(m,m);
for i=1:m
    for j=1:m
        %两种吸引力模式
        if dij(i,j)<=beta || locate(j,4)>sigma
%         if dij(i,j)<=beta
            aij(i,j)=locate(j,4)/(1+dij(i,j)^2);
        end
    end
end

existLocate=locate(1:c*n,:);%现有设施
plot(existLocate(:,2),existLocate(:,3),"ro");
tts=0;
for i=1:c*n
    if existLocate(:,4)>=sigma
        tts=tts+1;
    end
end
disp("已有设施超过质量阈值个数:");
disp(tts);

existattract=zeros(m,1);
for i=1:m
    for j=1:c*n
        %需求点i被已有公司吸引的总吸引力
        existattract(i,1)=existattract(i,1)+aij(i,existLocate(j,1));
    end
end


potentialLocate=locate;%潜在可选择位点
for i=1:c*n
    [ps,~]=size(potentialLocate);
    for j=1:ps
        if potentialLocate(j,1)==existLocate(i,1)
            potentialLocate(j,:)=[];
            break;
        end
    end
end
potentialLocate(:,in+1)=1;


%生成竞争者初始解
XIndex=randperm(m-c*n,r);
X=zeros(r,in+1);
for i=1:r
    X(i,:)=potentialLocate(XIndex(i),:);
end
candiLocate=potentialLocate;
for j=1:r
    x=find(candiLocate(:,1)==X(1,j));
    candiLocate(x,:)=[];
end

[csize,~]=size(candiLocate);
X1=X;
for i=1:r
    if rand<1/r
        X1(i,:)=candiLocate(randperm(csize,1),:);
    end
end
for j=1:r
    x=find(candiLocate(:,1)==X1(1,j));
    candiLocate(x,:)=[];
end


rank=zeros(m-c*n,1);
maxmarket=0;
for gen=1:40000
    
%计算市场份额
Mp=getMarket(m,r,X,existattract,locate,aij);
Mp1=getMarket(m,r,X1,existattract,locate,aij);

if Mp<Mp1
    for i=1:r
        for j=1:m-c*n
            if X(i,1)==potentialLocate(j,1) && X(i,1)~=X1(i,1)
                potentialLocate(j,in+1)=potentialLocate(j,in+1)-1;
            elseif X1(i,1)==potentialLocate(j,1) && X(i,1)~=X1(i,1)
                 potentialLocate(j,in+1)=potentialLocate(j,in+1)+1;   
            end
        end
    end 
    
 else
    for i=1:r
        for j=1:m-c*n
            if X1(i,1)==potentialLocate(j,1) && X(i,1)~=X1(i,1)
                potentialLocate(j,in+1)=potentialLocate(j,in+1)-1;
            end
        end
    end 
end


if Mp<Mp1
    X=X1;
else
    X1=X;
end


for i=1:m-c*n
    if potentialLocate(i,in+1)==0
        potentialLocate(i,in+1)=1;
    end
end

candiLocate=potentialLocate;
for j=1:r
    x=find(candiLocate(:,1)==X(j,1));
    candiLocate(x,:)=[];
end

[csize,~]=size(candiLocate);
lunpan=cumsum(candiLocate(:,in+1));
pij=lunpan./lunpan(csize,1);
pij=[0;pij];



for i=1:r
    if rand<1/r
        rnum=rand;
        for j=1:csize
            
            if rnum>pij(j,1)&&rnum<=pij(j+1,1)
                X1(i,:)=candiLocate(j,:);
                candiLocate(j,:)=[];
                [csize,~]=size(candiLocate);
                lunpan=cumsum(candiLocate(:,in+1));
                pij=lunpan./lunpan(csize,1);
                pij=[0;pij];
                break;
            end
        end
    end
end

if Mp>maxmarket
    maxmarket=Mp;
    maxX=X;
end

end

format short;
disp("最大市场份额：");
disp(maxmarket);

% disp("最优放置位点：");
% disp(maxX);

function Mp=getMarket(m,r,newLocate,existattract,locate,aij)
    Mp=0;
    for i=1:m
        attract=0;
        for j=1:r
            %需求点i被新公司吸引的总吸引力
            attract=attract+aij(i,newLocate(j,1));
        end
        %竞争公司获取需求点i的需求的概率
        pi=attract/(existattract(i,1)+attract+0.00001);
        Mp=Mp+locate(i,5)*pi;
    end
end