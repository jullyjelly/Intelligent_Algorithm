% close all;clear all;clc;
position=xlsread('hangji.xlsx');
x1=position(1,1:3);
[m,~]=size(position);
x2=position(m,1:3);
plot3(x1(1,1),x1(1,2),x1(1,3),'ro',x2(1,1),x2(1,2),x2(1,3),'ro')
text(x1(1,1)+25,x1(1,2)+25,x1(1,3)+55,'A')
text(x2(1,1)+25,x2(1,2)+25,x2(1,3)+55,'B')
line([x1(1,1);x2(1,1)],[x1(1,2);x2(1,2)],[x1(1,3);x2(1,3)]);
hold on;
across=[];
vertical=[];
for i=1:m
    if position(i,4)==0
        across=[across;position(i,:)];
    elseif position(i,4)==1
        vertical=[vertical;position(i,:)];
    end
end
            
plot3(across(:,1),across(:,2),across(:,3),'b.')
hold on;
plot3(vertical(:,1),vertical(:,2),vertical(:,3),'g.')
xlabel('x轴')
ylabel('y轴')
zlabel('z轴')
set(gca,'xtick',0:5000:100000);
set(gca,'ytick',0:5000:100000);

% axis equal;
axis([0 100000 0 100000 0 10000])
grid on;
set(gca,'xgrid','on','gridlinestyle','-','Gridalpha',0.4,'Gridcolor','k','LineWidth',1)


distance=zeros(m,m);
finfo=ones(m,m);%初始化信息素
% finfo=s;

format long;

for i=1:m
    for j=1:m
        distance(i,j) = sqrt((position(i,1)-position(j,1))^2+(position(i,2)-position(j,2))^2+(position(i,3)-position(j,3))^2);
    end
end


uniterr=0.001;
a1=25;a2=15;b1=20;b2=25;
Alfa = 5;
Beta = 8;

% disp(distance)
loc=1;%起始位点
err=[0,0];%初始误差
et=[];

% for t=1:10
% sumroute=cell(30,2);
for gen=1:10
    

    zinfo=zeros(m,m);

    for time=1:5
        locpop=[1];
        loc=1;%起始位点
        err=[0,0];%初始误差
        errpop=[0,0];
        while loc~=m%到达b点结束
            usefulnext=[];%可行的下一个位点
            for next=1:m%以当前起始点为中心计算走到不同点的误差
                if err(1,1)+distance(loc,next)>0 && err(1,1)+distance(loc,next)<25/uniterr...
                            && err(1,2)+distance(loc,next)>0 && err(1,2)+distance(loc,next)<25/uniterr  
        %         if distance(loc,next)>0 && distance(loc,next)<=20/uniterr
                %if next~=loc%除去自身的点
                    errtest=[err(1,1)+distance(loc,next)*uniterr,err(1,2)+distance(loc,next)*uniterr];
        %             et=[et;errtest];
                    if errtest(1,1)<=a1 && errtest(1,2)<=a2
                        toB=distance(next,m);%可行点到B点的距离
                        usefulnext=[usefulnext;next,toB,errtest];
                    elseif errtest(1,1)<=b1 && errtest(1,2)<=b2
                        toB=distance(next,m);
                        usefulnext=[usefulnext;next,toB,errtest];%找到可行的下一个点的集合，以及到B点的距离
                    end 
                end
            end
            [u,~]=size(usefulnext);%loc周围可行点的数量
            if u==0
                break
            end
            %生成概率矩阵 loc当前点 usefulnext（：，1）可行的next点
            attraction=zeros(u,1);
            for i=1:u
                attraction(i,:)=finfo(loc,usefulnext(i,1))^Alfa*(10000/usefulnext(i,2))^Beta;
        %         attraction(i,:)=finfo(loc,usefulnext(i,1))^Alfa*(10000/usefulnext(i,2))^Beta*(10000/distance(loc,usefulnext(i,1))^2);
        %         plot3(position(usefulnext(i,1),1),position(usefulnext(i,1),2),position(usefulnext(i,1),3),'go')
        %         hold on;
            end

            sumattract=cumsum(attraction);
            pij=sumattract./sumattract(u,1);
            %plot3(position(30,1),position(30,2),position(30,3),'r.')
            pij=[0;pij];


            if any(usefulnext(:,1)==m)
                st=find(usefulnext(:,1)==m);
                loc=m;
                err=usefulnext(st,3:4);
                errpop=[errpop;err];
            else
                count=0;
    %             a=0;
                while count<5
    %                 if a~=0
    %                     [sv,~]=size(errpop);
    %                     errpop(sv,:)=[];
    %                 end

    %                 while err(1,1)==0||err(1,2)==0
                    lunpan = rand;%生成轮盘随机数
                    for i=1:u
                        if lunpan>=pij(i,1) && lunpan<pij(i+1,1)
                            loc=usefulnext(i,1);
                            err=usefulnext(i,3:4);
                            if position(loc,4)==1 && err(1,1)<=a1 && err(1,2)<=a2%垂直
                                err(1,1)=0;
    %                             errpop=[errpop;err];
                            elseif position(loc,4)==0&& err(1,1)<=b1 && err(1,2)<=b2%水平
                                err(1,2)=0;
    %                             errpop=[errpop;err];
                            else
                                lunpan=rand;
                                continue
                            end

                        end
                        errpop=[errpop;err];
                    end
    %                 end


                    count=0;
                    for n=1:m%以当前起始点为中心计算走到不同点的误差
                        if err(1,1)+distance(loc,n)>0 && err(1,1)+distance(loc,n)<a1/uniterr...
                            && err(1,2)+distance(loc,n)>0 && err(1,2)+distance(loc,n)<a1/uniterr    
                            errtest=[err(1,1)+distance(loc,n)*uniterr,err(1,2)+distance(loc,n)*uniterr];
                            if (errtest(1,1)<=a1 && errtest(1,2)<=a2)||(errtest(1,1)<=b1 && errtest(1,2)<=b2)
                                count=count+1;
                            end
                        end
                    end
%                     a=a+1;
                end
            end
        %     disp(loc);
            locpop=[locpop;loc];

        end

        dist=0;
        [x,y]=size(locpop);

        for cc=1:x-1
            zinfo(locpop(cc),locpop(cc+1))=zinfo(locpop(cc),locpop(cc+1))+2;
        end

        for i=1:x-1
            dist=dist+distance(locpop(i,1),locpop(i+1,1));
        end
        bd=5000000;
        if dist<bd
            bd=dist;
            bl=locpop;
            be=errpop;
        end
        
    end
    
    zinfo=zeros(m,m);
    [aa,bb]=size(bl);
    for cc=1:aa-1
        zinfo(bl(cc),bl(cc+1))=2;
    end
    finfo=0.5*finfo+zinfo;
    gd=500000;
    if bd<gd
        gl=bl;
        ge=be;
    end

end
    
locpop=gl;


%locpop=[  1
 %  347
%   295
%   238
 %  234
 %  599
 %  316
 %  449
 %  486
 %  613];
[x,y]=size(locpop);
dist=0;
for i=1:x
    plot3(position(locpop(i,1),1),position(locpop(i,1),2),position(locpop(i,1),3),'r.')
    
   
    hold on;
end
distpop=[];
for i=1:x-1
    dist=dist+distance(locpop(i,1),locpop(i+1,1));
    distpop=[distpop;dist];
    ph=line([position(locpop(i,1),1);position(locpop(i+1,1),1)],[position(locpop(i,1),2);...
        position(locpop(i+1,1),2)],[position(locpop(i,1),3);position(locpop(i+1,1),3)]);
    set(ph,'Color','k')
end
disp(locpop)
disp(dist)
% disp(be)
disp(distpop)
