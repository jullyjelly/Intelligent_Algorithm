%工作指派问题可以描述如下：n 个工作将要指派给n 个工人分别完成，
%工人i 完成工作 j 的时间为dij ，问如何安排可使总的工作时间达到最
%小？请设计一种 SA 算法来解决上述指派问题。
%设n =100，要求随机产生dij ；



close all;clear all;clc;
n=100;
time=zeros(n,n);
for i=1:n
    for j=1:n
       time(i,j)=randsrc(1,1,(1:100));
    end   
end


t0=6000;   %初温
tend=0.1;  %结束温度
L=200;%各温度下的迭代次数
a=0.98;%退温系数
dist=randperm(n);%获取初始分配
besttime=0;
for i=1:n
    besttime=besttime+time(i,dist(i));
end
bestdist=dist;
% disp(sumtime)
gen=500;

T=t0;
B=[];
temp=[];
count=0;
while T>tend
    for i=1:L
        r1=randsrc(1,1,(1:n));
        r2=randsrc(1,1,(1:n));
        newdist=bestdist;
        newdist(r2)=bestdist(r1);
        newdist(r1)=bestdist(r2);  %交换
        newtime=0;
        for j=1:n
            newtime=newtime+time(j,newdist(j));
        end
        if newtime<=besttime
            besttime=newtime;
            bestdist=newdist;
        else
            p=exp((besttime-newtime)/T);
            if p>rand
                besttime=newtime;
                bestdist=newdist;
            end
        end
        %选择
    end
    T=a*T;
    temp=[temp;T];
    B=[B;besttime];
    count=count+1;
end
disp('退温次数：')
disp(count)
figure;
x1=1:count;
y1=B';
plot(x1,y1)
hold on;
x2=1:count;
y2=temp';
plot(x2,y2)
% axis([0,100,4000,6000]);
xlabel('退温次数')
legend('总时长','温度')
disp('最小工作时间')
disp(besttime)
% disp(bestdist)

function newdist=cross(bestdist,n)
r1=randsrc(1,1,(1:n));
    r2=randsrc(1,1,(1:n));
    newdist=bestdist;
    newdist(r2)=bestdist(r1);
    newdist(r1)=bestdist(r2);
end

function [besttime,bestdist]=chose(newtime,newdist,besttime,bestdist,T)
if newtime<=besttime
    besttime=newtime;
    bestdist=newdist;
else
    p=exp((besttime-newtime)/T);
    if p>rand
        besttime=newtime;
        bestdist=newdist;
    end
end
end
