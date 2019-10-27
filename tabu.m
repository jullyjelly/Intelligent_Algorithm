%某5个城市旅行商问题，城市间距离矩阵如下：
%用禁忌搜索算法实现TSP问题。
len=[0 10 15 6 2;
    10 0 8 13 9;
    15 8 0 20 15;
    6 13 20 0 5; 
    2 9 15 5 0];
slect=[1 2 3 4 5];
m=length(slect);
change=nchoosek(2:m,2);
Ban=zeros(3,2);
minsunlen=45;
for i=1:5
    [sumlen,slect]=prelen(slect,len,m);
    %获取上一代的距离总长度
    [row,trans,next]=circ(m,len,change,slect);
    %交换后的排列和总长度序列
    [newchange,paixu,index,B]=ran(trans,next,row,change);
    %对交换后的序列按长度从小到大排列
    [sumlen,slect,r1,r2]=choseb(slect,newchange,paixu,Ban,B,sumlen);
    %获取禁忌列表和新的slect值
    if sumlen<minsunlen
        minsunlen=sumlen;
    end
    jin=[r1,r2];
    Ban(3,:)=Ban(2,:);
    Ban(2,:)=Ban(1,:);
    Ban(1,:)=jin;
end
disp(slect)
disp(sumlen)
disp(minsunlen)
% 始终以A为起点

function [sumlen,slect]=prelen(slect,len,m)
%上一代的长度
sumlen=0;
for i=1:m
    slect(m+1)=slect(1);
    interlen=len(slect(i),slect(i+1));
    sumlen=sumlen+interlen;
end
slect=slect(1,1:m);
end

function [row,trans,next]=circ(m,len,change,slect)
%交换后的排列和总长度序列
[row,~]=size(change);
next=zeros(row,m);
trans=zeros(1,row);
for i=1:row
    slect0=slect;
    slect1=slect;
    slect1(change(i,2))=slect0(change(i,1));
    slect1(change(i,1))=slect0(change(i,2)); 
    sec=slect1;
    n=length(sec);
    s=0;
    for u=1:n
        sec(n+1)=sec(1);
        inters=len(sec(u),sec(u+1));
        s=s+inters; 
    end
    sec=sec(1,1:m);
    trans(i)=s;
    next(i,:)=slect1;
end
end


function [newchange,paixu,index,B]=ran(trans,next,row,change)
%对交换后的序列按长度从小到大排列
[B,index]=sort(trans);
paixu=zeros(size(next));
newchange=zeros(size(change));
for i=1:row
    paixu(i,:)=next(index(i),:);
    newchange(i,:)=change(index(i),:);
end
end



function [sumlen,slect,r1,r2]=choseb(slect,newchange,paixu,Ban,B,sumlen)
%获取禁忌列表和新的slect值
for i=1:4
    u=newchange(i,1); %获取排序后newchange表的第i行两个交换的值
    v=newchange(i,2);
    slect=paixu(i,:);
    r1=min(slect(u),slect(v));
    r2=max(slect(u),slect(v));
    for j=1:3
        if r1==Ban(j,1)&&r2==Ban(j,2)
            slect=paixu(i+1,:);
        end
    end
    if slect==paixu(i,:)
       sumlen=B(i);
        break
    end
end
end



