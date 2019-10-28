close all;clear all;clc
client=[0 0 2.5 1.5;0 -1 1.5 3.8;0 3 1.8 0.5;-1 -2 2 3;-3 -3 0.8 2.6;
    3 -1 1.5 3.6;-4 0 1 1.4;-4 -1 2.5 2.4;1 -2 3 2;1 -1 1.7 3.4;
    1 3 0.6 2;3 4 0.2 1.2;-3 0 2.4 0.5;2 0 1.9 0.8;1 -3 2 1.3;
    2 -1 0.7 1.6;2 1 0.5 1.7;1 -4 2.2 0.5;-3 2 3.1 0.8;-1 -1 0.1 1.4];
[m,~]=size(client);
plot(client(:,1),client(:,2),'.')
axis([-5 5 -5 5])
hold on;

C=1;
Q=100;
s=0.5;

antsnum=10;%蚂蚁数量
centerindex=nchoosek(1:m,2);%配送中心索引
[num,~]=size(centerindex);
mindistanceall=80;
for i=1:num
    center=client(centerindex(i,:),:);
    newclient=client;
    newclient(centerindex(i,:),:)=[];%确定配送中心后的客户位点
    len=zeros(m-2,m-2);
    for j=1:m-2
        for k=1:m-2
            d=sqrt((newclient(j,1)-newclient(k,1))^2+(newclient(j,2)-newclient(k,2))^2);
            len(j,k)=d;%客户距离矩阵
        end
    end
%     disp(len)
    nij=1./len;%距离矩阵倒数
    finfo=ones(m-2,m-2).*C;
    
    antspath=zeros(antsnum,m-2);
    for dai=1:100
        antsinitindex=randsrc(1,antsnum,(1:m-2));%每只蚂蚁的初始位置
        for j=1:antsnum
            unban=1:m-2;
            path=(antsinitindex(j));
            a=find(unban==antsinitindex(j));
            unban(a)=[];
            for k=1:m-3  %m-3
                unbanlen=length(unban);
                sp=[];
                for n=1:unbanlen
                   sp=[sp;(finfo(path(k),unban(n)))*(nij(path(k),unban(n)))^5];
                end
%                 disp(sp)
                ssp=cumsum(sp);
                p=ssp./ssp(unbanlen);
                p=[0;p];%信息素轮盘
                lunpan=rand;%随机数
                for u=1:unbanlen
                    if lunpan>=p(u,1)&&lunpan<p(u+1,1)
                        path=[path,unban(u)];
                        unban(u)=[];
                    end
                end 
            end 
            antspath(j,:)=path;
            
        end 
%         disp(antspath)
        zinfo=zeros(m-2,m-2);
        routeL=[];
        for j=1:antsnum
            L=0;
            for k=1:m-3
                L=L+len(antspath(j,k),antspath(j,k+1));
            end
            routeL=[routeL;L];
        end
       
        for j=1:antsnum
            for k=1:m-3
                zinfo(antspath(j,k),antspath(j,k+1))=zinfo(antspath(j,k),antspath(j,k+1))+Q./routeL(j,1);%新增加的信息素
            end
        end
        finfo=(1-s).*finfo+zinfo;%更新信息素
    end 
%     disp(antspath)
    minvehicle=8;
    mindistance=80;
    for j=1:antsnum
        weight=0;
        volume=0;
        count=0;
        insert=[0];
        for k=1:m-2
           weight=weight+newclient(antspath(j,k),3);
           volume=volume+newclient(antspath(j,k),4);
           if weight<=9&&volume<=10 
                count=count+1;
            else
                weight=newclient(antspath(j,k),3);
                volume=newclient(antspath(j,k),4);
                count=count+1;
                insert=[insert count-1];
           end
        end
        insert=[insert m-2];
             
        vehicle=length(insert)-1;
%         disp(insert)
        routelengthall=0;
        choosecenter=[];
        for k=1:vehicle
            dist1=sqrt((newclient(antspath(j,insert(k)+1),1)-center(1,1))^2+(newclient(antspath(j,insert(k)+1),2)-center(1,2))^2)+ ...
                sqrt((newclient(antspath(j,insert(k+1)),1)-center(1,1))^2+(newclient(antspath(j,insert(k+1)),2)-center(1,2))^2);
            dist2=sqrt((newclient(antspath(j,insert(k)+1),1)-center(2,1))^2+(newclient(antspath(j,insert(k)+1),2)-center(2,2))^2)+ ...
                sqrt((newclient(antspath(j,insert(k+1)),1)-center(2,1))^2+(newclient(antspath(j,insert(k+1)),2)-center(2,2))^2);
            distall=0;
            for n=(insert(k)+1):(insert(k+1)-1)
                distall=distall+len(antspath(j,n),antspath(j,n+1));
            end
            if dist1<=dist2
                routelength=dist1+distall;
                choosecenter=[choosecenter 1];
            else
                routelength=dist2+distall;
                choosecenter=[choosecenter 2];
            end
            routelengthall=routelengthall+routelength;  
        end
%         disp(routelengthall)
        if vehicle<minvehicle
            minvehicle=vehicle;%选出最小车辆
        end
        %选出确定配送中心后的最优解
        if vehicle==minvehicle
            if routelengthall<=mindistance
                mindistance=routelengthall;
                mininsert=insert;
                minchoosecenter=choosecenter;
                minantspath=antspath(j,:);
            end
        end        
    end
    %选出所有配送中心情况下的最优解和最优配送中心
    if mindistance<=mindistanceall
        mindistanceall=mindistance;
        mininsertall=mininsert;
        minchoosecenterall=minchoosecenter;
        minantspathall=minantspath;
        mincenter=center;
        minnewclient=newclient;
    end

end
disp(mindistanceall)
disp(mininsertall) 
disp(minchoosecenterall)
disp(minantspathall)
disp(mincenter) 
disp(minnewclient)

plot(mincenter(:,1),mincenter(:,2),'ro')
hold on;
%作图
for i=1:minvehicle
    route=[mincenter(minchoosecenterall(i),:);minnewclient(minantspathall(mininsertall(i)+1:mininsertall(i+1)),:);mincenter(minchoosecenterall(i),:)];
     for j=1:(length(route)-1)
        line([route(j,1),route(j+1,1)],[route(j,2),route(j+1,2)])
    end
end

% figure;
% for i=1:m-3
%     line([minnewclient(minantspathall(i),1),minnewclient(minantspathall(i+1),1)],[minnewclient(minantspathall(i),2),minnewclient(minantspathall(i+1),2)])
% end



