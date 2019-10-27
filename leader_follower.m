close all;clear all;clc
% ��������
n=20;%������Ҫ�����������
m=5;
t=3;
beta=1;%���ǰ뾶
[distance,choselocate,leaderlocatenow,followerlocatenow,potentiallocate,locatenowindex,potentiallocateindex]=generate(n,m,t,beta);

%�������
p=2;%�쵼������ʩ��
r=2;%����������ʩ��
sigma=1;
alfa=0.000001;
%�����쵼�߳�ʼ�⣨�������󷨣�
psort=flipud(sortrows(potentiallocate,4));%��Ǳ������㰴���������������������
X=psort(1:p,:);%�쵼�ߵ�ǰ��
maxmarketleader=0;

TL=zeros(7,5);
for lgen=1:30
     %���ɸ����ų�ʼ��  
    leaderall=[leaderlocatenow;X];
    fava=choselocate;
    for i=1:t+p
        [cl,~]=size(fava);
        for j=1:cl
            if leaderall(i,6)==fava(j,6)
                fava(j,:)=[];
                break;
            end
        end
    end
    % fava=psort(p+1:n-m,:);%�����߿�ѡ��ĵ�
    fava=flipud(sortrows(fava,3));%�Ը����߿�ѡ��ĵ㰴�����С��������
    if 2*r<=n-m-p
        Y=flipud(sortrows(fava(1:2*r,:),4));%ѡȡ������ߵ�2r���㲢������������н�������
        Y=Y(1:r,:);%ѡȡ����������ߵ�r������Ϊ�����ߵĳ�ʼ��
    else
        Y=flipud(sortrows(fava,4));
        Y=Y(1:r,:);
    end
    candidateF=updatecandidate(leaderlocatenow,X,followerlocatenow,Y,m,t,p,r,choselocate);%���º�ѡ��
    %���㵱ǰ���µ��쵼�ߺ͸������г��ݶ�
    % [marketleader,marketfollower]=calmarket(m,t,r,p,leaderlocatenow,X,followerlocatenow,Y,sigma,beta,choselocate,n,distance,alfa);
    maxmarketfollower=0;
    % a=Y;
    %���㵱ǰX�µ�����Y�����Լ����������г��ݶ�
    [maxmarketfollower,maxY]=bestfollower(candidateF,n,r, Y,m,t,p,leaderlocatenow,X,followerlocatenow,sigma,beta,choselocate,distance,alfa,maxmarketfollower);
    % Y=maxY;
    % [marketleader,marketfollower]=calmarket(m,t,r,p,leaderlocatenow,X,followerlocatenow,Y,sigma,beta,choselocate,n,distance,alfa);
    candidateL=updatecandidate(leaderlocatenow,X,followerlocatenow,maxY,m,t,p,r,choselocate);
    LC=flipud(sortrows(candidateL,4));
    LC=LC(1:fix(n/3),:);
    LC=[LC;maxY];
    marketleaderpop=[];
    for u=1:fix(n/3)+r
        for v=1:p
            newX=X;
            newX(v,:)=LC(u,:);
            [marketleader,~]=calmarket(m,t,r,p,leaderlocatenow,newX,followerlocatenow,Y,sigma,beta,choselocate,n,distance,alfa);
            marketleaderpop=[marketleaderpop;X(v,6) LC(u,6) marketleader u v];%������λ�㣬������ĸ������г��ݶ�Լ�����λ����FC��Y�е�����
        end
    end
    marketleaderpop=flipud(sortrows(marketleaderpop,3));
    TL1=TL;
    TL(2:7,:)=TL(1:6,:);

    for i=fix(n/3)*p:-1:1
        [xu,~]=ismember(marketleaderpop(i,1:2),TL1(:,1:2),'rows');
        [xv,~]=ismember(fliplr(marketleaderpop(i,1:2)),TL1(:,1:2),'rows');
        if xu||xv
            if marketleaderpop(i,3)>maxmarketleader
                TF(1,:)=marketleaderpop(i,:);
                maxmarketleader=marketleaderpop(i,3);
                maxX=X;
                maxX(TL(1,5),:)=LC(TL(1,4),:);
            else
                TL(1,:)=TL(1,:);
            end
        else
            TL(1,:)=marketleaderpop(i,:);
            if marketleaderpop(i,3)>maxmarketleader
                maxmarketleader=marketleaderpop(i,3);
                maxX=X;
                maxX(TL(1,5),:)=LC(TL(1,4),:);
            end
        end

    end
    X(TL(1,5),:)=LC(TL(1,4),:);
    candidateL=updatecandidate(leaderlocatenow,X,followerlocatenow,Y,m,t,p,r,choselocate);
end

[candidateF,Y]=getY(leaderlocatenow,maxX,choselocate,n,m,p,r,t,followerlocatenow);
maxmarketfollower=0;
[maxmarketfollower,maxY]=bestfollower(candidateF,n,r,Y,m,t,p,leaderlocatenow,maxX,followerlocatenow,sigma,beta,choselocate,distance,alfa,maxmarketfollower);
plot(maxX(:,1),maxX(:,2),'rsquare','linewidth',2);
hold on;
plot(maxY(:,1),maxY(:,2),'gsquare','linewidth',2);
disp('�쵼������ʩλ�ã�')
disp(maxX)
disp('����������ʩλ�ã�')
disp(maxY)
disp('�쵼���г��ݶ')
disp(maxmarketleader)
disp('�������г��ݶ')
disp(maxmarketfollower)



function [candidateF,Y]=getY(leaderlocatenow,maxX,choselocate,n,m,p,r,t,followerlocatenow)
leaderall=[leaderlocatenow;maxX];
fava=choselocate;
for i=1:t+p
    [cl,~]=size(fava);
    for j=1:cl
        if leaderall(i,6)==fava(j,6)
            fava(j,:)=[];
            break;
        end
    end
end
% fava=psort(p+1:n-m,:);%�����߿�ѡ��ĵ�
fava=flipud(sortrows(fava,3));%�Ը����߿�ѡ��ĵ㰴�����С��������
if 2*r<=n-m-p
    Y=flipud(sortrows(fava(1:2*r,:),4));%ѡȡ������ߵ�2r���㲢������������н�������
    Y=Y(1:r,:);%ѡȡ����������ߵ�r������Ϊ�����ߵĳ�ʼ��
else
    Y=flipud(sortrows(fava,4));
    Y=Y(1:r,:);
end
candidateF=updatecandidate(leaderlocatenow,maxX,followerlocatenow,Y,m,t,p,r,choselocate);%���º�ѡ��
end





function [maxmarketfollower,maxY]=bestfollower(candidateF,n,r,Y,m,t,p,leaderlocatenow,X,followerlocatenow,sigma,beta,choselocate,distance,alfa,maxmarketfollower)
TF=zeros(7,5);
for gen=1:30
FC=flipud(sortrows(candidateF,4));
%ѡ��n/3����ѡ�Ⲣ��������������
FC=FC(1:fix(n/3),:);%or ceil����n/3����С����

marketfollowerpop=[];%������Ԫ���Լ���������г��ݶ�

for i=1:fix(n/3)
    for j=1:r
        newY=Y;
        newY(j,:)=FC(i,:);%���򽻻�
        [~,marketfollower]=calmarket(m,t,r,p,leaderlocatenow,X,followerlocatenow,newY,sigma,beta,choselocate,n,distance,alfa);
        marketfollowerpop=[marketfollowerpop;Y(j,6) FC(i,6) marketfollower i j];%������λ�㣬������ĸ������г��ݶ�Լ�����λ����FC��Y�е�����
    end
end
marketfollowerpop=flipud(sortrows(marketfollowerpop,3));
TF1=TF;
TF(2:7,:)=TF(1:6,:);
for i=fix(n/3)*r:-1:1
    [xa,~]=ismember(marketfollowerpop(i,1:2),TF1(:,1:2),'rows');
    [xb,~]=ismember(fliplr(marketfollowerpop(i,1:2)),TF1(:,1:2),'rows');
    if xa||xb
        if marketfollowerpop(i,3)>maxmarketfollower
            TF(1,:)=marketfollowerpop(i,:);
            maxmarketfollower=marketfollowerpop(i,3);
            maxY=Y;
            maxY(TF(1,5),:)=FC(TF(1,4),:);
        else
            TF(1,:)=TF(1,:);
        end
    else
        TF(1,:)=marketfollowerpop(i,:);
        if marketfollowerpop(i,3)>maxmarketfollower
            maxmarketfollower=marketfollowerpop(i,3);
            maxY=Y;
            maxY(TF(1,5),:)=FC(TF(1,4),:);
        end
    end
end
% a=maxY;
Y(TF(1,5),:)=FC(TF(1,4),:);
candidateF=updatecandidate(leaderlocatenow,X,followerlocatenow,Y,m,t,p,r,choselocate);
% [marketleader,marketfollower,leaderall,followerall]=calmarket(m,t,r,p,leaderlocatenow,X,followerlocatenow,Y,sigma,beta,choselocate,n,distance,alfa);
end
% Y=maxY;
end



function candidate=updatecandidate(leaderlocatenow,X,followerlocatenow,Y,m,t,p,r,choselocate)
leaderall=[leaderlocatenow;X];
followerall=[followerlocatenow;Y];
candidate=choselocate;
for i=1:t+p
    [cl,~]=size(candidate);
    for j=1:cl
        if leaderall(i,6)==candidate(j,6)
            candidate(j,:)=[];
            break;
        end
    end
end
for i=1:m-t+r
    [cl,~]=size(candidate);
    for j=1:cl
        if followerall(i,6)==candidate(j,6)
            candidate(j,:)=[];
            break;
        end
    end
end
end
    


function [marketleader,marketfollower]=calmarket(m,t,r,p,leaderlocatenow,X,followerlocatenow,Y,sigma,beta,choselocate,n,distance,alfa)
leaderall=[leaderlocatenow;X];
followerall=[followerlocatenow;Y];
marketleader=0;
marketfollower=0;
% jattract=zeros(n,2);%��ͬ������ܵ����쵼�ߺ͸����ߵ�������
% ui=jattract;
for j=1:n
    %���������쵼�ߺ͸����߷ֱ��õ��г��ݶ�
    leaderattractj=0;
    followerattractj=0;
    for i=1:t+p
        %�쵼����ʩi�Թ˿�j��������
        if distance(leaderall(i,6),j)<=beta
            attraction=leaderall(i,5)/((distance(leaderall(i,6),j))^2+sigma);
%             jattract(j,1)=jattract(j,1)+attraction;
            leaderattractj=leaderattractj+attraction;
        end
    end
    for i=1:m-t+r
        %��������ʩi�Թ˿�j��������
        if distance(followerall(i,6),j)<=beta
            attraction=followerall(i,5)/((distance(followerall(i,6),j))^2+sigma);
%             jattract(j,2)=jattract(j,2)+attraction;
            followerattractj=followerattractj+attraction;
        end
    end
%     if jattract(j,1)+jattract(j,2)~=0
%         ui(j,:)=[jattract(j,1)/(jattract(j,1)+jattract(j,2)) jattract(j,2)/(jattract(j,1)+jattract(j,2))] ;
%         uii(j,:)=[ui(j,1)*choselocate(j,3) ui(j,2)*choselocate(j,3)];
%     end
%     uiii=cumsum(uii);
    attractjall=leaderattractj+followerattractj;
    pleaderj=leaderattractj/(attractjall+alfa); %�˿�j����쵼����ʩ�ĸ���
    pfollowerj=followerattractj/(attractjall+alfa);%�˿�j��˸�������ʩ�ĸ���
    marketleader=marketleader+choselocate(j,3)*pleaderj;%�쵼�߲�����г��ݶ�
    marketfollower=marketfollower+choselocate(j,3)*pfollowerj;%�����߲�����г��ݶ�
end
end
        

function [distance,choselocate,leaderlocatenow,followerlocatenow,potentiallocate,locatenowindex,potentiallocateindex]=generate(n,m,t,beta)
choselocate=zeros(n,6);
leaderlocatenow=zeros(t,6);
followerlocatenow=zeros(m-t,6);
potentiallocate=zeros(n-m,6);
distance=zeros(n,n);
%locatenowindex potentiallocateindex
for i=1:10
    if n<=i^2
        locaterange=zeros(i^2,3);
        for vertical=1:i
            for across=1:i
                %�����οɷ������������
                locaterange((vertical-1)*i+across,:)=[across-1 vertical-1 10*rand];
            end
        end
        choselocateindex=randperm(i^2,n);
        [choselocateindex,~]=sort(choselocateindex);%������ڿ�ѡ���λ���е�˳������
        for s=1:n
            %�����λ���Լ�������
            choselocate(s,1:3)=locaterange(choselocateindex(s),:);
            choselocate(s,5)=5*rand;
            choselocate(s,6)=s;
            plot(choselocate(s,1),choselocate(s,2),'k^');
            text(choselocate(s,1)+0.1,choselocate(s,2),num2str(s));
            hold on;
        end 
        for x=1:n
            for y=1:n
                distance(x,y)=((choselocate(x,1)-choselocate(y,1))^2+(choselocate(x,2)-choselocate(y,2))^2)^0.5;
                if distance(x,y)<=beta
                    choselocate(x,4)=choselocate(x,4)+choselocate(y,3);
                end
            end
        end
        locateallindex=randperm(n);
        locatenowindex=locateallindex(1:m);%������ʩ��������е�����
        potentiallocateindex=sort(locateallindex(m+1:n));%Ǳ����ʩ��������е�����
        for s=1:t
            %�쵼��������ʩλ�ã�����������ʩ����
            leaderlocatenow(s,1:5)=choselocate(locatenowindex(s),1:5);
%             leaderlocatenow(s,5)=5*rand;
            leaderlocatenow(s,6)=locatenowindex(s);
            plot(leaderlocatenow(s,1),leaderlocatenow(s,2),'ro','linewidth',1);
        end
        for s=t+1:m
            %������������ʩλ�ã�����������ʩ����
            followerlocatenow(s-t,1:5)=choselocate(locatenowindex(s),1:5);
%             followerlocatenow(s-t,5)=5*rand;
            followerlocatenow(s-t,6)=locatenowindex(s);
            plot(followerlocatenow(s-t,1),followerlocatenow(s-t,2),'go','linewidth',1);
        end
        for s=1:n-m
            %Ǳ����ʩλ�ã�������
            potentiallocate(s,1:5)=choselocate(potentiallocateindex(s),1:5);
            potentiallocate(s,6)=potentiallocateindex(s);
        end
        break;
    end
end
end

