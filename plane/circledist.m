% close all;clear all;clc;
% R=5;r=5;
% syms u v;
% ezmesh((R+r*cos(u))*cos(v),(R+r*cos(u))*sin(v),r*sin(u),[-pi,pi]);
% hold on;
% % ezmesh(r*cos(u)*cos(v),r*cos(u)*sin(v),r*sin(u),[-pi,pi])
% grid off
% 
% axis equal;
% axis([-20 20 -20 20 -30 30]);
% line([20 0] ,[ 10 0],[ -30 0]);
% hold on;
% line([20 0] ,[ 10 0],[ 30 0])
% format long;
% 
position=xlsread('hangji2.xlsx');
[m,~]=size(position);
distance=zeros(m,m);
for i=1:m
    for j=1:m
        distance(i,j) = sqrt((position(i,1)-position(j,1))^2+(position(i,2)-position(j,2))^2+(position(i,3)-position(j,3))^2);
    end
end
locpop=[ 1
   151
   115
   235
   129
   228
   310
   306
   124
   232
   161
    93
    94
    62
   293
   327];
[x,~]=size(locpop);
a=0;
b=0;
bpop=[];
for i=1:x-2
    A=position(locpop(i,1),1:3);
    B=position(locpop(i+1,1),1:3);
    C=position(locpop(i+2,1),1:3);
    AB=B-A;
    CA=A-C;
    d=AB(1,1)*CA(1,1)+AB(1,2)*CA(1,2)+AB(1,3)*CA(1,3);
    m=sqrt(AB(1,1)^2+AB(1,2)^2+AB(1,3)^2)*sqrt(CA(1,1)^2+CA(1,2)^2+CA(1,3)^2);
    cosn=d/m;
    angle=acos(cosn)*180/pi;
    dist=distance(locpop(i,1),locpop(i+1,1))-2*cosd(angle/2)*400+(1-angle/180)*400*pi;
    a=a+dist;
    rdist=dist-cosd(angle/2)*400+(1-angle/180)*200*pi
    b=b+rdist;
    bpop=[bpop;b];
end
a=a+(1-angle/180)*200*pi+distance(locpop(x-1,1),locpop(x,1))-cosd(angle/2)*400;
b=b+(1-angle/180)*200*pi+distance(locpop(x-1,1),locpop(x,1))-cosd(angle/2)*400;
bpop=[bpop;b]    