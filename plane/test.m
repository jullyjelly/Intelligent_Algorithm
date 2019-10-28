close all;
position=xlsread('C:\Users\Jian\桌面\新建文件夹\hangji.xlsx');
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

locpop=[  1
   347
   295
   238
   234
   599
   316
   449
   486
   303
   613];
[rlen,~]=size(locpop);
result=zeros(rlen,3);
sumdist=0
for i=1:rlen-1
    result(i+1,2)=result(i,2)+distance(locpop(i,1),locpop(i+1,1))*0.001;
    result(i+1,3)=result(i,3)+distance(locpop(i,1),locpop(i+1,1))*0.001;
    sumdist=sumdist+distance(locpop(i,1),locpop(i+1,1));
    result(i+1,1)=sumdist;
    if position(locpop(i+1,1),4)==1
        result(i+1,2)=0;
    elseif position(locpop(i+1,1),4)==0
        result(i+1,3)=0;
    end
end
disp(result)
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
    set(ph,'Color','m')
end
axis equal;
axis([0 100000 0 100000 0 10000])
xlabel('x轴')
ylabel('y轴')
zlabel('z轴')
xyz=zeros(x,4);
for i=1:x
    xyz(i,:)=position(locpop(i,1),1:4);
end
disp(xyz)
