close all;clear all;clc;
%作图
position=xlsread('pos.xlsx');
x1=position(1,1:3);
[m,~]=size(position);
x2=position(m,1:3);
plot3(x1(1,1),x1(1,2),x1(1,3),'ro',x2(1,1),x2(1,2),x2(1,3),'ro')
text(x1(1,1)+25,x1(1,2)+25,x1(1,3)+55,'A')
text(x2(1,1)+25,x2(1,2)+25,x2(1,3)+55,'B')
line([x1(1,1);x2(1,1)],[x1(1,2);x2(1,2)],[x1(1,3);x2(1,3)]);
hold on;
across=zeros(306,6);
vertical=zeros(305,6);
a=1;b=1;
for i=1:m
    if position(i,4)==0
        across(a,:)=position(i,:);
        a=a+1;
    elseif position(i,4)==1
        vertical(b,:)=position(i,:);
        b=b+1;
    end
end

plot3(across(:,1),across(:,2),across(:,3),'b.')
hold on;
plot3(vertical(:,1),vertical(:,2),vertical(:,3),'g.')
axis equal;
grid on;
set(gca,'xgrid','on','gridlinestyle','-','Gridalpha',0.4,'Gridcolor','k','LineWidth',1)
pice=20;
unitlen=100000/pice;
set(gca,'xtick',0:unitlen:100000);
set(gca,'ytick',0:unitlen:100000);
axis([0 100000 0 100000 0 10000])

%距离矩阵
distance=zeros(m,m);
finfo=ones(m,m);%初始化信息素
for i=1:m
    for j=1:m
        distance(i,j) = sqrt((position(i,1)-position(j,1))^2+(position(i,2)-position(j,2))^2+(position(i,3)-position(j,3))^2);
    end
end



%每个点在哪个块中，每个块里面有哪些点
piecepop=cell(400,9);
for i=1:pice
    for j=1:pice
        pop=[];
        type=[];
        rangexmin=(i-1)*unitlen;
        rangexmax=(i)*unitlen;
        rangeymin=(j-1)*unitlen;
        rangeymax=(j)*unitlen;
        if i~=pice && j~=pice
            for k=1:m
                if  position(k,1)>=rangexmin && position(k,1)<rangexmax && position(k,2)>=rangeymin && position(k,2)<rangeymax
                    position(k,6)=pice*(j-1)+i;
                    pop=[pop;k];
                    type=[type;position(k,4)];
                end
            end
        elseif i==pice && j~=pice
            for k=1:m
                if  position(k,1)>=rangexmin && position(k,1)<=rangexmax && position(k,2)>=rangeymin && position(k,2)<rangeymax
                    position(k,6)=pice*(j-1)+i;
                    pop=[pop;k];
                    type=[type;position(k,4)];
                end
            end
        elseif j==pice && i~=pice
             for k=1:m
                if  position(k,1)>=rangexmin && position(k,1)<rangexmax && position(k,2)>=rangeymin && position(k,2)<=rangeymax
                    position(k,6)=pice*(j-1)+i;
                    pop=[pop;k];type=[type;position(k,4)];
                end
             end
        else
            for k=1:m
                if  position(k,1)>=rangexmin && position(k,1)<=rangexmax && position(k,2)>=rangeymin && position(k,2)<=rangeymax
                    position(k,6)=pice*(j-1)+i;
                    pop=[pop;k];
                    type=[type;position(k,4)];
                end
             end
        end
        piecepop{(pice*(j-1)+i),1}=pop;    
        piecepop{(pice*(j-1)+i),2}=type;
        if isempty(type)==1
            typeindex=-1;
        elseif isempty(find(type==1))==1
            typeindex=0;
        elseif isempty(find(type==0))==1
            typeindex=1;
        else 
            typeindex=2;
        end
        piecepop{(pice*(j-1)+i),3}=typeindex;
        piecepop{(pice*(j-1)+i),4}=[(rangexmin+rangexmax)/2,(rangeymin+rangeymax)/2];
    end
end
% piecepop{396,1}(2,1)
b=cellfun('isempty',piecepop);%1为空，0为非空

a1=18;a2=11;b1=15;b2=18;
blockdist=zeros(400,400);
uniterr=0.001;
for i=1:400
    for j=1:400
        blockdist(i,j)=sqrt((piecepop{i,4}(1)-piecepop{j,4}(1))^2+(piecepop{i,4}(2)-piecepop{j,4}(2))^2);
    end
end

loc=position(1,6);
locpos=piecepop{loc,4};
err=[0,0];
% minroute=cell(400,4);
piecepop{loc,5}=0;
piecepop{loc,6}=0;
piecepop{loc,7}=[loc];
piecepop{loc,8}=[0,0];
piecepop{loc,9}=[0,0];

% while i==1
if err(1)>=14
    usefulnext=[];
    for next=1:400
        if next~=loc && (blockdist(loc,next)*uniterr+err(1)<=a1 && blockdist(loc,next)*uniterr+err(2)<=a2)...
                && (piecepop{next,3}==1 || piecepop{next,3}==2) 
            usefulnext=[usefulnext;next,blockdist(loc,next)*uniterr+err(1),blockdist(loc,next)*uniterr+err(2),piecepop(next,3)];
            routelen=piecepop{loc,5}+1;
            dis=piecepop{loc,6}+blockdist(loc,next);
            route=[piecepop{loc,7};next];
            if dis<piecepop{next,6}
                piecepop{next,5}=routelen;
                piecepop{next,6}=dis;
                piecepop{next,7}=route;
                piecepop{next,8}=[0,blockdist(loc,next)*uniterr+err(2)];
            end 
        end
    end
elseif err(2)>=14
     usefulnext=[];
    for next=1:400
        if next~=loc && ((blockdist(loc,next)*uniterr+err(1)<=a1 && blockdist(loc,next)*uniterr+err(2)<=a2)...
                && (piecepop{next,3}==0 || piecepop{next,3}==2))
            usefulnext=[usefulnext;next,blockdist(loc,next)*uniterr+err(1),blockdist(loc,next)*uniterr+err(2),piecepop(next,3)];
            routelen=piecepop{loc,5}+1;
            dis=piecepop{loc,6}+blockdist(loc,next);
            route=[piecepop{loc,7};next];
            if dis<piecepop{next,6}
                piecepop{next,5}=routelen;
                piecepop{next,6}=dis;
                piecepop{next,7}=route;
                piecepop{next,8}=[blockdist(loc,next)*uniterr+err(1),0];
            end 
        end
    end
else
     usefulnext=[];
    for next=1:400
        if next~=loc && ((blockdist(loc,next)*uniterr+err(1)<=a1 && blockdist(loc,next)*uniterr+err(2)<=a2)||...
                (blockdist(loc,next)*uniterr+err(1)<=b1 && blockdist(loc,next)*uniterr+err(2)<=b2)) && piecepop{next,3}~=-1
            usefulnext=[usefulnext;next,blockdist(loc,next)*uniterr+err(1),blockdist(loc,next)*uniterr+err(2),piecepop(next,3)];
            routelen=piecepop{loc,5}+1;
            dis=piecepop{loc,6}+blockdist(loc,next);
            route=[piecepop{loc,7};next];
            if dis<piecepop{next,6}
                piecepop{next,5}=routelen;
                piecepop{next,6}=dis;
                piecepop{next,7}=route;
                if piecepop{next,3}==1 
                    piecepop{next,8}=[0,blockdist(loc,next)*uniterr+err(2)];
                elseif piecepop{next,3}==0
                    piecepop{next,9}=[blockdist(loc,next)*uniterr+err(1),0];
                else
                    piecepop{next,8}=[0,blockdist(loc,next)*uniterr+err(2)];
                    piecepop{next,9}=[blockdist(loc,next)*uniterr+err(1),0];
                end
            end 
        end
    end
end

    
    
    
