close all;clear all;clc;
m=60;%输入想要求的需求点个数
c=3;%公司数
n=4;%每家公司设施数
r=5;%新进入公司设施数
beta=2;%覆盖半径
sigma=4.5;%质量阈值

choselocate=zeros(m,6);
% choselocate(:,4)=0;
locatenow=zeros(c*n,6);
distance=zeros(m,m);
for i=1:30
    if m<=i^2
        locaterange=zeros(i^2,3);
        for vertical=1:i
            for across=1:i
                %正方形可放置需求点区域
                locaterange((vertical-1)*i+across,:)=[across-1 vertical-1 10*rand];
            end
        end
        choselocateindex=randperm(i^2,m);
        [choselocateindex,~]=sort(choselocateindex);%需求点在可选择的位置中的顺序索引
        for s=1:m
            %需求点位置以及需求量
            choselocate(s,1:3)=locaterange(choselocateindex(s),:);
            choselocate(s,5)=5*rand;
            choselocate(s,6)=s;
            plot(choselocate(s,1),choselocate(s,2),'k^');
            text(choselocate(s,1)+0.1,choselocate(s,2),num2str(s));
            hold on;
        end 
        for x=1:m
            for y=1:m
                distance(x,y)=((choselocate(x,1)-choselocate(y,1))^2+(choselocate(x,2)-choselocate(y,2))^2)^0.5;
                if distance(x,y)<=beta||choselocate(y,5)>=sigma
%                 if distance(x,y)<=beta
                    choselocate(x,4)=choselocate(x,4)+choselocate(y,3);
                end
            end
        end
        
        choselocate=flipud(sortrows(choselocate,3));
        locateallindex=randperm(c*n*2,c*n);
        for x=1:c*n
            locatenow(x,:)=choselocate(locateallindex(1,x),:);
        end
        plot(locatenow(:,1),locatenow(:,2),'go');
        potentiallocate=choselocate;
        
        for y=1:c*n
            [l,~]=size(potentiallocate);
            for x=1:l
                if potentiallocate(x,6)==locatenow(y,6)
                    potentiallocate(x,:)=[];
                    break;
                end
            end
        end
        choselocate=sortrows(choselocate,6);
        potentiallocate=sortrows(potentiallocate,6);
        %locatenow=sortrows(locatenow,6);
        break;
    end
end


%题目
distance=zeros(m,m);
aij=zeros(m,m);
 for i=1:m
     for j=1:m
         distance(i,j)=((choselocate(i,1)-choselocate(j,1))^2+(choselocate(i,2)-choselocate(j,2))^2)^0.5;
         if distance(i,j)<=beta || choselocate(j,5)>=sigma
%          if distance(i,j)<=beta
             aij(i,j)=choselocate(j,5)/(1+distance(i,j)^2);
         else
             aij(i,j)=0;
         end
     end
 end



newindex=randperm(m-c*n,r);
X=zeros(r,6);
for i=1:r
    X(i,:)=potentiallocate(newindex(i),:);
end



% function newcandi=updatecandi(candilocate,newfacility,X)
newcandi=potentiallocate;
for i=1:r
    [nc,~]=size(newcandi);
    for j=1:nc
        if X(i,6)==newcandi(j,6)
            newcandi(j,:)=[];
            break;
        end
    end
end
% end


X1=X;



[sl,~]=size(potentiallocate);
R=ones(sl,7);
R(:,1:6)=potentiallocate;


maxmarket=0;

for gen=1:3000
[firmattractionbX,firmattractionpbX]=calattrat(c,n,r,X,m,choselocate,locatenow,aij);
[allfirmmarketX,marketpbX,marketbX]=calmarket(c,n,r,X,firmattractionpbX,firmattractionbX, ...
    choselocate,locatenow,m);

[firmattractionbX1,firmattractionpbX1]=calattrat(c,n,r,X1,m,choselocate,locatenow,aij);
[allfirmmarketX1,marketpbX1,marketbX1]=calmarket(c,n,r,X1,firmattractionpbX1,firmattractionbX1, ...
    choselocate,locatenow,m);
% if marketpbX<marketpbX1
if marketbX<marketbX1
    for i=1:r
        for j=1:sl
            if X(i,6)==potentiallocate(j,6) && X(i,6)~=X1(i,6)
                R(j,7)=R(j,7)-1;
            elseif X1(i,6)==potentiallocate(j,6) && X(i,6)~=X1(i,6)
                 R(j,7)=R(j,7)+1;   
            end
        end
    end
else
    for i=1:r
        for j=1:sl
            if X1(i,6)==potentiallocate(j,6) && X(i,6)~=X1(i,6)
                R(j,7)=R(j,7)-1;
            end
        end
    end
end
for i=1:sl
    if R(i,7)==0
        R(i,7)=1;
    end
end


 newcandi=updatecandi(potentiallocate,r,X);
 newcandi=updatecandi(newcandi,r,X1);


[mc,~]=size(newcandi);

lunpan=cumsum(newcandi(:,5));
pij=lunpan./lunpan(mc,1);

pij=[0;pij];
% if marketpbX<marketpbX1
if marketbX<marketbX1
    X=X1;
else
    X1=X;
end

for i=1:r
    if rand<1/r
        
        for j=1:mc
            rnum=rand;
            if rnum>pij(j,1)&&rnum<=pij(j+1,1)
                X1(i,:)=newcandi(j,:);
                newcandi=updatecandi(potentiallocate,r,X);
                newcandi=updatecandi(newcandi,r,X1);
                [mc,~]=size(newcandi);
                lunpan=cumsum(newcandi(:,5));
                pij=lunpan./lunpan(mc,1);
                pij=[0;pij];
                break;
            end
        end
    end
end

if marketbX>maxmarket
    maxmarket=marketbX;
    maxX=X;
end
% if marketpbX>maxmarket
%     maxmarket=marketpbX;
%     maxX=X;
% end

end
newR=flipud(sortrows(R,7));
format short;    
plot(maxX(:,1),maxX(:,2),'rsquare');
title('新进入公司设施位点（红色方框）')
disp('最大市场份额:')
disp(maxmarket);
disp('最大市场份额时新进入公司的设施位点:')
disp(maxX(:,6));




function newcandi=updatecandi(potentiallocate,r,X)
newcandi=potentiallocate;
for i=1:r
    [n,~]=size(newcandi);
    for j=1:n
        if X(i,6)==newcandi(j,6)
            newcandi(j,:)=[];
            break;
        end
    end
end
end







function [allfirmmarket,marketpb,marketb]=calmarket(c,n,r,X,firmattractionpb,firmattractionb, ...
    choselocate,locatenow,m)
%计算新进入设施获得的市场份额
allfirmmarket=zeros(c*n+r,8); 
%x坐标，y坐标，需求量,覆盖需求量，设施质量，设施在需求点的索引，部分二元规则市场份额，二元规则市场份额
allfirmmarket(1:c*n,1:6)=locatenow;
allfirmmarket(c*n+1:c*n+r,1:6)=X;

for i=1:c*n+r
    for dem=1:m
        for j=1:(c+1)
            if allfirmmarket(i,6)==firmattractionpb(dem,(j-1)*4+1)
                allfirmmarket(i,7)=allfirmmarket(i,7)+choselocate(dem,3)*firmattractionpb(dem,(j-1)*4+3);
            end
        end
        if allfirmmarket(i,6)==firmattractionb(dem,1)
            allfirmmarket(i,8)=allfirmmarket(i,8)+choselocate(dem,3);
        end
    end
end
marketpb=cumsum(allfirmmarket(c*n+1:c*n+r,7));
marketpb=marketpb(r,1);
marketb=cumsum(allfirmmarket(c*n+1:c*n+r,8));
marketb=marketb(r,1);
end


function [firmattractionb,firmattractionpb]=calattrat(c,n,r,X,m,choselocate,locatenow,aij) 
firmattractionpb=zeros(m,(c+1)*4);
firmattractionb=zeros(m,3);
for dem=1:m
% for c=1:1
    allattraction=zeros(c,n);
    maxattract=0;%所有公司最优
    for i=1:c
        maxfirmattract=0;%该公司最优
        for j=1:n
            allattraction(i,j)=aij(choselocate(dem,6),locatenow((i-1)*n+j,6));
            if allattraction(i,j)>=maxfirmattract
                maxfirmattract=allattraction(i,j);
                maxindex=locatenow((i-1)*n+j,6);
            end
        end
        firmattractionpb(dem,(i-1)*4+1:i*4-1)=[maxindex,i,maxfirmattract];
        if maxfirmattract>=maxattract
            maxattract=maxfirmattract;
            maxcity=maxindex;
            maxfirm=i;
        end
        firmattractionb(dem,:)=[maxcity,maxfirm,maxattract];%索引，公司，吸引力
    end
    newattraction=zeros(1,r);
    
    maxnew=0;
    for u=1:r
        newattraction(1,u)=aij(choselocate(dem,6),X(u,6));
        if newattraction(1,u)>=maxnew
            maxnew=newattraction(1,u);
            maxnewindex=X(u,6);
            
        end
        newfirmattraction=[maxnewindex,c+1,maxnew];%索引，公司，吸引力
    end
    firmattractionpb(dem,c*4+1:(c+1)*4-1)=newfirmattraction;
    
    attractsum=0;
    for f=1:c+1
        attractsum=attractsum+firmattractionpb(dem,f*4-1);
    end
    for f=1:c+1
        firmattractionpb(dem,f*4)=firmattractionpb(dem,f*4-1)/(1+attractsum);
    end
    
    if firmattractionb(dem,3)<newfirmattraction(1,3)
        firmattractionb(dem,:)=newfirmattraction;
    end
    
end
end
