 clc;
clear all;
city=xlsread('partially_binary.xlsx');
[citynum,~]=size(city);

location=zeros(citynum,5);
for i=1:citynum
    locate=Millier(city(i,3),city(i,4));
    location(i,:)=[city(i,1),locate,city(i,2),1];
end
ranklocation=flipud(sortrows(location,4));
 plot(location(:,2),location(:,3),'b.'); 
 hold on;
%  http://www.tageo.com/index-e-sp-cities-ES.htm
 distance=zeros(citynum,citynum);
 for i=1:citynum
     for j=1:citynum
         distance(i,j)=((location(i,2)-location(j,2))^2+(location(i,3)-location(j,3))^2)^0.5;
     end
 end
  aij=1./(1+distance);%吸引力
  
existfirm=3;%现有公司数
firmfacility=5;%每家公司已有设施数
newfacility=5;%新进入的设施数
potentfacility=100;%候选设施数
  
  
 firmindex=randperm(existfirm*firmfacility*2,existfirm*firmfacility);
 firm=zeros(existfirm*firmfacility,5);
 for i=1:existfirm
     for j=1:firmfacility
        firm((i-1)*firmfacility+j,:)=ranklocation(firmindex((i-1)*firmfacility+j),:);
     end
 end
 plot(firm(:,2),firm(:,3),'ro');
 candilocate=ranklocation;%获取候选位点
 for i=1:existfirm*firmfacility
     [l,~]=size(candilocate);
     for j=1:l
         if candilocate(j,1)==firm(i,1)
             candilocate(j,:)=[];
             break;
         end
     end
 end
 [l,~]=size(candilocate);
 L=zeros(potentfacility,5);
 Lindex=randperm(l,potentfacility);
 for i=1:potentfacility
     L(i,:)=candilocate(Lindex(i),:);
 end
L= flipud(sortrows(L,4));

%以上部分为题目

newindex=randperm(potentfacility,newfacility);
X=zeros(newfacility,5);
for i=1:newfacility
    X(i,:)=L(newindex(i),:);
end


newcandi=updatecandi(L,newfacility,X);
[change,X1]=newX(newcandi,newfacility,X);
newcandi=updatecandi(newcandi,newfacility,X1);

[sl,~]=size(L);
R=L;


maxmarket=0;
 for gen=1:3000
format long;
[firmattractionbX,firmattractionpbX]=calattrat(existfirm,firmfacility,newfacility,X,citynum,ranklocation,firm,aij);
[allfirmmarketX,marketpbX,marketbX]=calmarket(existfirm,firmfacility,newfacility, ...
    X,firmattractionpbX,firmattractionbX,ranklocation,firm,citynum); 

[firmattractionbX1,firmattractionpbX1]=calattrat(existfirm,firmfacility,newfacility,X1,citynum,ranklocation,firm,aij);
[allfirmmarketX1,marketpbX1,marketbX1]=calmarket(existfirm,firmfacility,newfacility, ...
    X1,firmattractionpbX1,firmattractionbX1,ranklocation,firm,citynum); 
if marketpbX<marketpbX1
    for i=1:newfacility
        for j=1:sl
            if X(i,1)==L(j,1) && X(i,1)~=X1(i,1)
                R(j,5)=R(j,5)-1;
            elseif X1(i,1)==L(j,1) && X(i,1)~=X1(i,1)
                 R(j,5)=R(j,5)+1;   
            end
        end
    end
else
    for i=1:newfacility
        for j=1:sl
            if X1(i,1)==L(j,1) && X(i,1)~=X1(i,1)
                R(j,5)=R(j,5)-1;
            end
        end
    end
end
for i=1:sl
    if R(i,5)==0
        R(i,5)=1;
    end
end

newcandi=updatecandi(L,newfacility,X);
newcandi=updatecandi(newcandi,newfacility,X1);


[mc,~]=size(newcandi);

lunpan=cumsum(newcandi(:,5));
pij=lunpan./lunpan(mc,1);

pij=[0;pij];
if marketpbX<marketpbX1
    X=X1;
else
    X1=X;
end

for i=1:newfacility
    if rand<1/newfacility
        
        for j=1:mc
            rnum=rand;
            if rnum>pij(j,1)&&rnum<=pij(j+1,1)
                X1(i,:)=newcandi(j,:);
                newcandi=updatecandi(L,newfacility,X);
                newcandi=updatecandi(newcandi,newfacility,X1);
                [mc,~]=size(newcandi);
                lunpan=cumsum(newcandi(:,5));
                pij=lunpan./lunpan(mc,1);
                pij=[0;pij];
                break;
            end
        end
    end
end
if marketpbX>maxmarket
    maxmarket=marketpbX;
    maxX=X;
end
end
newR=flipud(sortrows(R,5));
format short;    
plot(maxX(:,2),maxX(:,3),'gsquare');
title('新进入公司设施位点（绿色方框）')
disp('最大市场份额:')
disp(maxmarket);
disp('最大市场份额时新进入公司的设施位点:')
disp(maxX(:,1));





function [change,X1]=newX(newcandi,newfacility,X)
[n,~]=size(newcandi);
X1=X;
change=[];
for i=1:newfacility
    if rand<1/newfacility
        changeindex=randperm(n,1);
        X1(i,:)=newcandi(changeindex,:);
        change=[change; X1(i,:)];
        newcandi(changeindex,:)=[];
        [n,~]=size(newcandi);
    end
end
end


function newcandi=updatecandi(candilocate,newfacility,X)
newcandi=candilocate;
for i=1:newfacility
    [n,~]=size(newcandi);
    for j=1:n
        if X(i,1)==newcandi(j,1)
            newcandi(j,:)=[];
            break;
        end
    end
end
end

function [firmattractionb,firmattractionpb]=calattrat(existfirm,firmfacility,newfacility,X,citynum,ranklocation,firm,aij)
%获取每个需求点被每个公司的设施的吸引力情况
firmattractionpb=zeros(citynum,(existfirm+1)*4);
firmattractionb=zeros(citynum,3);
for c=1:citynum
% for c=1:1
    allattraction=zeros(existfirm,firmfacility);
    maxattract=0;%所有公司最优
    for i=1:existfirm
        maxfirmattract=0;%该公司最优
        for j=1:firmfacility
            allattraction(i,j)=aij(ranklocation(c,1),firm((i-1)*firmfacility+j,1));
            if allattraction(i,j)>maxfirmattract
                maxfirmattract=allattraction(i,j);
                maxindex=firm((i-1)*firmfacility+j,1);
            end
        end
        firmattractionpb(c,(i-1)*4+1:i*4-1)=[maxindex,i,maxfirmattract];
        if maxfirmattract>maxattract
            maxattract=maxfirmattract;
            maxcity=maxindex;
            maxfirm=i;
        end
        firmattractionb(c,:)=[maxcity,maxfirm,maxattract];%索引，公司，吸引力
    end
    newattraction=zeros(1,newfacility);
    
    maxnew=0;
    for u=1:newfacility
        newattraction(1,u)=aij(ranklocation(c,1),X(u,1));
        if newattraction(1,u)>maxnew
            maxnew=newattraction(1,u);
            maxnewindex=X(u,1);
            
        end
        newfirmattraction=[maxnewindex,4,maxnew];%索引，公司，吸引力
    end
    firmattractionpb(c,existfirm*4+1:(existfirm+1)*4-1)=newfirmattraction;
    
    attractsum=0;
    for f=1:existfirm+1
        attractsum=attractsum+firmattractionpb(c,f*4-1);
    end
    for f=1:existfirm+1
        firmattractionpb(c,f*4)=firmattractionpb(c,f*4-1)/attractsum;
    end
    
    if firmattractionb(c,3)<newfirmattraction(1,3);
        firmattractionb(c,:)=newfirmattraction;
    end
    
end
end


function [allfirmmarket,marketpb,marketb]=calmarket(existfirm,firmfacility,newfacility,X,firmattractionpb,firmattractionb, ...
    ranklocation,firm,citynum)
%计算新进入设施获得的市场份额
allfirmmarket=zeros(existfirm*firmfacility+newfacility,7); 
%设施在需求点的索引，x坐标，y坐标，需求量（人口数），设施质量（=1），部分二元规则市场份额，二元规则市场份额
allfirmmarket(1:existfirm*firmfacility,1:5)=firm;
allfirmmarket(existfirm*firmfacility+1:existfirm*firmfacility+newfacility,1:5)=X;

for i=1:existfirm*firmfacility+newfacility
    for c=1:citynum
        for j=1:(existfirm+1)
            if allfirmmarket(i,1)==firmattractionpb(c,(j-1)*4+1)
                allfirmmarket(i,6)=allfirmmarket(i,6)+ranklocation(c,4)*firmattractionpb(c,j*4);
            end
        end
        if allfirmmarket(i,1)==firmattractionb(c,1)
            allfirmmarket(i,7)=allfirmmarket(i,7)+ranklocation(c,4);
        end
    end
end
marketpb=cumsum(allfirmmarket(existfirm*firmfacility+1:existfirm*firmfacility+newfacility,6));
marketpb=marketpb(newfacility,1);
marketb=cumsum(allfirmmarket(existfirm*firmfacility+1:existfirm*firmfacility+newfacility,7));
marketb=marketb(newfacility,1);

end

 
function locate=Millier(lat,lon)
L = 6381372 *pi * 2;%地球周长  
W=L;% 平面展开后，x轴等于周长  
H=L/2;% y轴约等于周长一半  
mill=2.3;%米勒投影中的一个常数，范围大约在正负2.3之间  
x = lon *pi / 180;% 将经度从度数转换为弧度  
y = lat * pi / 180;% 将纬度从度数转换为弧度  
y=1.25 *log(tan( 0.25 * pi+ 0.4 * y ) );% 米勒投影的转换  
%弧度转为实际距离  
x = ( W / 2 ) + ( W / (2 * pi) ) * x;  
y = ( H / 2 ) - ( H / ( 2 * mill ) ) * y;  
locate=[x,y];
end