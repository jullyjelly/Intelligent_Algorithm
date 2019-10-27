%����ָ����������������£�n ��������Ҫָ�ɸ�n �����˷ֱ���ɣ�
%����i ��ɹ��� j ��ʱ��Ϊdij ������ΰ��ſ�ʹ�ܵĹ���ʱ��ﵽ��
%С�������һ�� SA �㷨���������ָ�����⡣
%��n =100��Ҫ���������dij ��



close all;clear all;clc;
n=100;
time=zeros(n,n);
for i=1:n
    for j=1:n
       time(i,j)=randsrc(1,1,(1:100));
    end   
end


t0=6000;   %����
tend=0.1;  %�����¶�
L=200;%���¶��µĵ�������
a=0.98;%����ϵ��
dist=randperm(n);%��ȡ��ʼ����
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
        newdist(r1)=bestdist(r2);  %����
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
        %ѡ��
    end
    T=a*T;
    temp=[temp;T];
    B=[B;besttime];
    count=count+1;
end
disp('���´�����')
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
xlabel('���´���')
legend('��ʱ��','�¶�')
disp('��С����ʱ��')
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
