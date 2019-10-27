%����19���ͻ�����ֲ��ڳ�Ϊ10km�������������ڡ���������λ�����������룬������Ϊ��0��0����
%���ͻ������꼰���������±���ʾ����������ӵ��������������Ϊ9t�ĳ������Կͻ����з���ʱ�����������ĳ�����
%��ɶԿͻ��������������ٻص��������ġ���Ҫ�������ٵĳ���������С�ĳ������г�����ɻ������������
%������Ⱥ�㷨����VRP����(vehicle routing problem)��

%No#	   		1	2	3	4	5	6	7	8	9	10
%������		0	0	0	-1	-3	3	-4	-4	1	1
%������		0	-1	3	-2	-3	-1	0	-1	-2	-1
%������(t)	0	1.5	1.8	2.0	0.8	1.5	1.0	2.5	3.0	1.7
%No#	        11	12	13	14	15	16	17	18	19	20
%������		1	3	-3	2	1	2	2	1	-3	-1
%������		3	4	0	0	-3	-1	1	-4	2	-1
%������(t)	0.6	0.2	2.4	1.9	2.0	0.7	0.5	2.2	3.1	0.1




locate=[0 0 0;0 -1 1.5;0 3 1.8;-1 -2 2.0;-3 -3 0.8;
        3 -1 1.5; -4 0 1;-4 -1 2.5; 1 -2 3; 1 -1 1.7;
        1 3 0.6; 3 4 0.2; -3 0 2.4;2 0 1.9;1 -3 2;
        2 -1 0.7; 2 1 0.5; 1 -4 2.2;-3 2 3.1;-1 -1 0.1];
%���ɾ������
[m,~]=size(locate);
len=zeros(m,m);
for i=1:m
    for j=1:m
        x1=locate(i,1);
        x2=locate(j,1);
        y1=locate(i,2);
        y2=locate(j,2);
        d=sqrt((x1-x2)^2+(y1-y2)^2);
        len(i,j)=d;
    end
end
nij=1./len;
load=9;
C=1;%����
finfo=ones(m,m)*C;%��ʼ��Ϣ��
Q=100;
antnum=20;
minlen=80;%��С�ܳ���
maxgen=100;
BR=[];
for dai=1:maxgen
    %��ȡ���ϳ�ʼ����·��
    [antspath,antsjin]=GetRouth(load,finfo,antnum,nij,m,locate);
    %��ȡ����������·�߳���
    [city,routeL]=GetLength(antspath,antnum,len); 
    %����ÿ���ߵ���Ϣ������
    finfo=GetInfomation(m,city,antspath,routeL,Q,finfo,antnum); 
    %��ȡÿһ��������
    [bestlen,bestpath]=GetBest(routeL,antspath);
    if bestlen<minlen
        minlen=bestlen;
        minpath=bestpath;
    end
    pathlocate=[];%·���ľ���λ��
    for i=1:city
        pathlocate=[pathlocate;locate(minpath(i),1:2)];
    end
    plot(pathlocate(:,1),pathlocate(:,2), ...
        'o','MarkerFaceColor','b','linestyle','-')
    axis([-5 5 -5 5]);
    grid on;
    pause(0.03)
    BR=[BR;minlen];

end
disp(minlen)
disp(minpath)
figure;
x=1:maxgen;
y=BR';
plot(x,y)


function [antspath,antsjin]=GetRouth(load,finfo,antnum,nij,m,locate)
antspath=[];
antsjin=[];
for k=1:antnum
    path=[1];
    unban=(2:m);
    a=0;
    jin=[];
    for i=1:m+2
        disv=locate(path(i),3);
        if a+disv<=load
            a=a+disv;
        else
            a=0;
            last1=length(path);
            last2=length(jin);
            unban=[unban,path(last1)];
            path(last1)=[];
            jin(last2)=[];
            path=[path,1];  
        end
        unbanlen=length(unban);%δ�����ɳ�����
        sp=[];
        for j=1:unbanlen
            sp=[sp;(finfo(path(i),unban(j)))*(nij(path(i),unban(j)))^5];
            %ÿ��·���ϵ���Ϣ��singlep     
        end
        ssp=cumsum(sp);%��Ϣ�����µ������
        sumsp=ssp(unbanlen);%��Ϣ���ܺ�
        pij=ssp./sumsp;%��Ϣ������
        pij=[0;pij];
        lunpan=rand;
        for u=1:unbanlen
            if lunpan<pij(u+1,1)&&lunpan>=pij(u,1)
                path=[path,unban(u)];
                jin=[jin,unban(u)];
                unban(u)=[];
            end
        end
    end
    path=[path,1];
    antspath=[antspath;path];
    antsjin=[antsjin;jin];
end
end



function [city,routeL]=GetLength(antspath,antnum,len)
[~,city]=size(antspath);%��ȡ�������ߵĳ�����
    routeL=[];
    for i=1:antnum
        L=0;
        for j=1:city-1
            L=L+len(antspath(i,j),antspath(i,j+1));%�ܾ���
        end
        routeL=[routeL;L];

    end
end

function finfo=GetInfomation(m,city,antspath,routeL,Q,finfo,antnum)
zinfo=zeros(m,m);
    p=0.5;%��Ϣ����ɢ����
    for i=1:antnum
        for j=1:city-1
            zinfo(antspath(i,j),antspath(i,j+1))= ...
                zinfo(antspath(i,j),antspath(i,j+1))+Q/(routeL(i,1));
            %�����ӵ���Ϣ��
        end
    end
    finfo=(1-p).*finfo+zinfo;%���¸�����Ϣ��
end

function [bestlen,bestpath]=GetBest(routeL,antspath)
    newantspath=[];
    [B,index]=sort(routeL);
    bestlen=B(1,1);
    bestpath=antspath(index(1),:);
end
