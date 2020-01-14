% close all;clear all;clc;

% data
data=xlsread("data5.xlsx");%������x��y��������������
beta=2000;%���ǰ뾶
sigma=190;%������ֵ

% data=xlsread("mydata.xlsx");
% beta=30;%���ǰ뾶
% sigma=10;%������ֵ

in=5;%locate�в�������
[m,~]=size(data);

upsig=0;
for i=1:m
    if data(i,4)>=sigma
        upsig=upsig+1;
    end
end
disp("������ֵ��λ�����");
disp(upsig);


locate=zeros(m,in);
locate(:,1:5)=data;
plot(locate(:,2),locate(:,3),"k.");
hold on;
c=3;%��˾��
n=3;%ÿ�ҹ�˾��ʩ��
r=5;%�½��빫˾��ʩ��

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

%����������i����㣬j��ʩ
aij=zeros(m,m);
for i=1:m
    for j=1:m
        %����������ģʽ
        if dij(i,j)<=beta || locate(j,4)>sigma
%         if dij(i,j)<=beta
            aij(i,j)=locate(j,4)/(1+dij(i,j)^2);
        end
    end
end
 
existLocate=locate(1:c*n,:);%������ʩ
plot(existLocate(:,2),existLocate(:,3),"ro");

tts=0;
for i=1:c*n
    if existLocate(:,4)>=sigma
        tts=tts+1;
    end
end
disp("������ʩ����������ֵ����:");
disp(tts);


existattract=zeros(m,1);
for i=1:m
    for j=1:c*n
        %�����i�����й�˾��������������
        existattract(i,1)=existattract(i,1)+aij(i,existLocate(j,1));
    end
end

potentialLocate=locate;%Ǳ�ڿ�ѡ��λ��
for i=1:c*n
    [ps,~]=size(potentialLocate);
    for j=1:ps
        if potentialLocate(j,1)==existLocate(i,1)
            potentialLocate(j,:)=[];
            break;
        end
    end
end

chromnum=10;
bestall=0;

chrompop=zeros(chromnum,r+1);%r����������Լ��¹�˾��õ��г��ݶ�
for chrom=1:chromnum
    %���ɾ����߳�ʼ��
    newLocateIndex=randperm(m-c*n,r);
    newLocate=zeros(r,in);
    for i=1:r
        newLocate(i,:)=potentialLocate(newLocateIndex(i),:);
        chrompop(chrom,i)=newLocate(i,1);
    end
    %�����г��ݶ�
    Mp=getMarket(m,r,newLocate,existattract,locate,aij);
    chrompop(chrom,r+1)=Mp;
end

pc=0.8;
pm=0.2;
potentialLocate(:,in+1)=1;

bpop=[];
for gen=1:20   
%����
newchrom=[];
for i=1:2:chromnum
    if pc>rand
        %���������Ⱦɫ��
        f1=chrompop(i,:);
        f2=chrompop(i+1,:);
        [f1,f2]=interset(f1,f2,r);
        newchrom=[newchrom;f1;f2];
    end
end

[sn,~]=size(newchrom);
for i=1:sn
    newLocate=zeros(r,in);
    for j=1:r
        x=find(locate(:,1)==newchrom(i,j));
        newLocate(j,:)=locate(x,:);
    end
    Mp=getMarket(m,r,newLocate,existattract,locate,aij);
    newchrom(i,6)=Mp;%���㽻����Ⱦɫ����г��ݶ�
end

chrompop=[chrompop;newchrom];%����������ɵ�Ⱦɫ��֮���Ⱥ��

%����
newchrom=[];
for i=1:chromnum+sn
    if pm>rand
        f=chrompop(i,:);
        candiLocate=potentialLocate;
        for j=1:r
            x=find(candiLocate(:,1)==chrompop(i,j));
            candiLocate(x,:)=[];
        end
        cl=randsrc(1,1,(1:r));%���ĸ�λ�����
        cn=randsrc(1,1,(1:m-c*n-r));%�����λ�������
        f(1,cl)=candiLocate(cn,1);
        newchrom=[newchrom;f];
    end
end

[sn,~]=size(newchrom);
for i=1:sn
    newLocate=zeros(r,in);
    for j=1:r
        x=find(locate(:,1)==newchrom(i,j));
        newLocate(j,:)=locate(x,:);
    end
    Mp=getMarket(m,r,newLocate,existattract,locate,aij);
    newchrom(i,6)=Mp;%���������Ⱦɫ����г��ݶ�
end
chrompop=[chrompop;newchrom];

[cs,~]=size(chrompop);
bestm=0;
for i=1:cs
    for time=1:200 
        f=chrompop(i,:);
        candiLocate=potentialLocate;
        for j=1:r
            x=find(candiLocate(:,1)==chrompop(i,j));
            candiLocate(x,:)=[];
        end
        cl=randsrc(1,1,(1:r));%���ĸ�λ�����
        
        lunpan=cumsum(candiLocate(:,in+1));
        pij=lunpan./lunpan(m-c*n-r,1);
        pij=[0;pij];
        
        
        f1=f;
        rnum=rand;
        for u=1:m-c*n-r
            if rnum>pij(u,1) && rnum<pij(u+1,1)
                f1(1,cl)=candiLocate(u,1);
            end
        end
%         cn=randsrc(1,1,(1:m-c*n-r));%�����λ�������
%         f(1,cl)=candiLocate(cn,1);

        newLocate=zeros(r,in);
        for j=1:r
            x=find(locate(:,1)==f1(1,j));
            newLocate(j,:)=locate(x,:);
        end
        Mp=getMarket(m,r,newLocate,existattract,locate,aij);
        if Mp>chrompop(i,6)
            
            
            for u=1:r
                for v=1:m-c*n
                    if f(1,u)==potentialLocate(v,1) && f(1,u)~=f1(1,u)
                        potentialLocate(v,in+1)=potentialLocate(v,in+1);
                    elseif f1(1,u)==potentialLocate(v,1) && f(1,u)~=f1(1,u)
                         potentialLocate(v,in+1)=potentialLocate(v,in+1)+2;  
                    elseif f(1,u)==potentialLocate(v,1) && f(1,u)==f1(1,u)
                        potentialLocate(v,in+1)=potentialLocate(v,in+1)+1; 
                    end 
                end
            end 
            chrompop(i,6)=Mp;
            chrompop(i,1:5)=f1(1,1:5);
        else
            
            
            for u=1:r
                for v=1:m-c*n
                    if f1(1,u)==potentialLocate(v,1) && f(1,u)~=f1(1,u)
                        potentialLocate(v,in+1)=potentialLocate(v,in+1);
                    end
                end
            end 

        end
        
%         for u=1:m-c*n
%             if potentialLocate(u,in+1)==0
%                 potentialLocate(u,in+1)=1;
%             end
%         end
        
        
    end
    if chrompop(i,6)>bestm
        bestm=chrompop(i,6);
        bestindex=chrompop(i,:);
    end     
end

if bestm>bestall
    bestall=bestm;
    bestindexall=bestindex;
end
bpop=[bpop;gen,bestall];

%ѡ��
newchrompop=[];
mpop=chrompop(:,6);
allm=cumsum(mpop);
fit=allm./allm(cs,1);
fit=[0;fit];
for i=1:chromnum
    lunpan=rand;
    for j=1:cs
        if lunpan>fit(j,1) && lunpan<=fit(j+1,1)
            newchrompop=[newchrompop;chrompop(j,:)];
        end
    end
end
chrompop=newchrompop;

end

bestindexall(1,1:5)=sort(bestindexall(1,1:5));
disp(bestindexall(1,1)+"��"+bestindexall(1,2)+"��"+bestindexall(1,3)+ ...
    "��"+bestindexall(1,4)+"��"+bestindexall(1,5)+"  "+bestindexall(1,6));
bestl=zeros(r,in);
for j=1:r
    x=find(locate(:,1)==bestindexall(1,j));
    bestl(j,:)=locate(x,:);
    t=0:pi/40:2*pi;
    x1=beta.*cos(t)+ bestl(j,2);
    y1=beta.*sin(t)+ bestl(j,3);
    plot(x1,y1,'b-');   
end

count=0;
for i=1:r
    if bestl(i,4)>=sigma
        count=count+1;
    end
end
disp("������ʩ�ڴ�����ֵ����ʩ����");
disp(count);
plot(bestl(:,2),bestl(:,3),"g^");
axis equal;

figure;
plot(bpop(:,1),bpop(:,2),'b-');






function Mp=getMarket(m,r,newLocate,existattract,locate,aij)
    Mp=0;
    for i=1:m
        attract=0;
        for j=1:r
            %�����i���¹�˾��������������
            attract=attract+aij(i,newLocate(j,1));
        end
        %������˾��ȡ�����i������ĸ���
        pi=attract/(existattract(i,1)+attract+0.00001);
        Mp=Mp+locate(i,5)*pi;
    end
end




function [f1,f2]=interset(f1,f2,r)
    f11=f1;
    f21=f2;
    r1=randsrc(1,1,(1:r));
    r2=randsrc(1,1,(1:r));
    while r1==r2
        r2=randsrc(1,1,(1:r));
    end
    rmin=min(r1,r2);
    rmax=max(r1,r2);
    r1=rmin;r2=rmax;

    %����Ⱦɫ�彻��Ĳ���
    a1=f1(1,r1:r2);
    b1=f2(1,r1:r2);
    for j=1:r2-r1+1
        a=f1(1,r1:r2);
        b=f21(1,r1:r2);
        x=find(f1==b(1,j));
        if ~isempty(x)
            f1(1,x)=a(1,j);
        end
    end
    for j=1:r2-r1+1
        a=f11(1,r1:r2);
        b=f2(1,r1:r2);
        y=find(f2==a(1,j));
        if ~isempty(y)
            f2(1,y)=b(1,j);
        end
    end
    
    f1(1,r1:r2)=b1;
    f2(1,r1:r2)=a1;
end