close all;clear all;clc
position=xlsread('hangji2.xlsx');
[m,~]=size(position);
distance=zeros(m,m);
for i=1:m
    for j=1:m
        distance(i,j) = sqrt((position(i,1)-position(j,1))^2+(position(i,2)-position(j,2))^2+(position(i,3)-position(j,3))^2);
    end
end

x1=position(1,1:3);
x2=position(m,1:3);
plot3(x1(1,1),x1(1,2),x1(1,3),'ro',x2(1,1),x2(1,2),x2(1,3),'ro')
hold on;
text(x1(1,1)+25,x1(1,2)+25,x1(1,3)+55,'A')
text(x2(1,1)+25,x2(1,2)+25,x2(1,3)+55,'B')

racross=[];
wacross=[]
rvertical=[];
wvertical=[];
for i=1:m
    if position(i,4)==0
        if position(i,5)==0
            racross=[racross;position(i,:)];
        else
            wacross=[wacross;position(i,:)];
        end
    elseif position(i,4)==1
        if position(i,5)==0
            rvertical=[rvertical;position(i,:)];
        else
            wvertical=[wvertical;position(i,:)];
        end
    end
end

plot3(racross(:,1),racross(:,2),racross(:,3),'b.')
hold on;
plot3(wacross(:,1),wacross(:,2),wacross(:,3),'bx')
hold on;
plot3(rvertical(:,1),rvertical(:,2),rvertical(:,3),'g.')
hold on;
plot3(wvertical(:,1),wvertical(:,2),wvertical(:,3),'gx')


xlabel('x÷·')
ylabel('y÷·')
zlabel('z÷·')
set(gca,'xtick',0:5000:100000);
set(gca,'ytick',0:5000:100000);

% axis equal;
axis([0 100000 0 100000 0 10000])
grid on;
set(gca,'xgrid','on','gridlinestyle','-','Gridalpha',0.4,'Gridcolor','k','LineWidth',1)
