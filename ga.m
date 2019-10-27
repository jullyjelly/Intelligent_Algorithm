%问题描述：
%现有10个工人去做10件工作，每个工人完成每项工作所需时间不同，如下表所示。
%要求每个工人只做一项工作，每项工作只由一个工人完成。
%怎样指派工人完成工作可以使所用总时间最少？
%利用遗传算法编程求解该问题。


time = [
    82 16 66 71 44 28 76 85 36 8;
    91 98 4 4 39 68 26 26 84 6;
    13 96 85 28 77 66 51 82 59 54;
    92 49 94 5 80 17 70 25 55 78;
    64 81 68 10 19 12 90 93 92 94;
    10 15 76 83 49 50 96 35 29 13;
    28 43 75 70 45 96 55 20 76 57;
    55 92 40 32 65 35 14 26 76 47;
    96 80 66 96 71 59 15 62 39 2;
    97 96 18 4 76 23 26 48 57 34;];
%种群数量
magnit=100;
%工人数pop
[~,pop]=size(time);
%选择概率
cp=0.8;
pc=0.9;  %交叉概率
pm=0.1;
maxgen=100;
[select,rang]=init(magnit,pop);
[sumt,tolsingletime]=cal(magnit,pop,rang,time,select);
[prang,ptol,best]=pai(rang,tolsingletime,sumt,magnit);
B=[];
for i=1:maxgen
    fitlevelplus=fitv(best,magnit);
    [newselect,newtol,chosebest,s]=sel(magnit,fitlevelplus,prang,ptol,best,cp);
    crozi=cross(s,pop,newselect,pc);
    muzi=var(newselect,pop,pm);
    rang=renew(crozi,muzi,magnit,prang);
    [sumt,tolsingletime]=cal(magnit,pop,rang,time,select);
    [prang,ptol,best]=pai(rang,tolsingletime,sumt,magnit);
    B=[B;best(1,1)];
end
 disp(best(1,1))
 disp(prang(1,:))
 
     
%初始化，获得magnit组1~pop的随机排列矩阵rang，并获取每一组的距离长度值
function [select,rang]=init(magnit,pop)
rang=zeros(magnit,pop);
for i=1:magnit
    select=randperm(10);  %每一组的随机排列
    rang(i,:)=select; 
end
end


function [sumt,tolsingletime]=cal(magnit,pop,rang,time,select)
sumt=zeros(magnit,1);
tolsingletime=[];
singletime=zeros(1,pop);
for i=1:magnit
    select=rang(i,:);
    for u=1:pop
       singletime(1,u)=time(u,select(1,u)); 
    end
    tolsingletime(i,:)=singletime(1,:);
%     tolsingletime=[tolsingletime;singletime];
    st=0;
    for t=1:pop
        st=st+singletime(1,t);
    end
    sumt(i,1)=st;
    rang(i,:)=select; 
end
% disp(tolsingletime)
% disp(sumt)
end


function [prang,ptol,best]=pai(rang,tolsingletime,sumt,magnit)
%对rang  best   tolsingletime对应排序
prang=zeros(size(rang));
ptol=zeros(size(tolsingletime));
[best,index]=sort(sumt);
for i=1:magnit
   prang(i,:)=rang(index(i,1),:);
   ptol(i,:)=tolsingletime(index(i,1),:);
end
% disp(best)
% disp(newrang)
% disp(newtol)
end



function fitlevelplus=fitv(best,magnit)
%求适值和适应度
fit=1000.-best;  %适值，最小化为最大
tolfit=0;   %总适值
for s=1:magnit
   tolfit=tolfit+fit(s,:) ;
end
% disp(tolfit)
fitlevel=fit./tolfit; %适应度
fitlevelplus=cumsum(fitlevel); %适应度向下叠加
end

function [newselect,newtol,chosebest,s]=sel(magnit,fitlevelplus,prang,ptol,best,cp)
%选择
newselect=[]; 
newtol=[];
chosebest=[];
for i=1:magnit
    if cp>rand
        lunpan=rand;
        for t=1:(magnit-1)
            if lunpan>=fitlevelplus(t,1)&&lunpan<fitlevelplus(t+1,1)
                newselect=[newselect;prang(t,:)];
                newtol=[newtol;ptol(t,:)];
                chosebest=[chosebest;best(t,:)];
            end
        end
    end  
end
[s,~]=size(newselect);
% disp(newselect)
% disp(newtol)
% disp(chosebest)
end

function crozi=cross(s,pop,newselect,pc)
%交叉
crozi=[];
for i=1:2:(s-rem(s,2))
    if pc>=rand
       %交叉
       r1=randsrc(1,1,(1:pop-3));
       r2=r1+3;
       fa=newselect(i,:);    %父代
       mo=newselect(i+1,:);  %母代
       cr1=fa(1,r1:r2);
       cr2=mo(1,r1:r2);
       for u=1:4
           a=fa(1,r1:r2);
           b=mo(1,r1:r2);
%                cra=(newselect(i,(1:f-1)),b,newselect(i,(l+1):pop));
%                crb=(newselect(i+1,(1:f-1)),a,newselect(i+1,(l+1):pop));
%                b1(1,u)=a0(1,u); 
           x=find(fa==b(1,u));
           fa(1,x)=a(1,u);
       end
       zi1=[fa(1,1:(r1-1)),cr2,fa(1,(r2+1):pop)];
       crozi=[crozi;zi1];
       fa=newselect(i,:);
       mo=newselect(i+1,:);
       for t=1:4
           c=fa(1,r1:r2);
           d=mo(1,r1:r2);
           y=find(mo==c(1,t));
           mo(1,y)=d(1,t);
       end
       zi2=[mo(1,1:(r1-1)),cr1,mo(1,(r2+1):pop)];
       crozi=[crozi;zi2];
   end
end
end



function muzi=var(newselect,pop,pm)
%变异
[m,~]=size(newselect);
muzi=[];
for i=1:m
    if pm>rand
        c1=randsrc(1,1,(1:pop));
        c2=randsrc(1,1,(1:pop));
        cho(1,:)=newselect(i,:);
        u=cho;
        u(1,c1)=cho(1,c2);
        u(1,c2)=cho(1,c1);
        muzi=[muzi;u];
    end
end
end

function rang=renew(crozi,muzi,magnit,prang)
%更新种群
zi=[crozi;muzi];
[x,~]=size(zi);
rang=[prang((1:magnit-x),:);zi];
end
