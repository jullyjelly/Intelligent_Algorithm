function [oz_Y,Y,QY]=greedy_init(m,num_E,location_E,dij,Rc,Rq,q_t,quality_N,Qj,Wi,gamma,n_qlevel,cost_jk,G)
oz_Y=zeros((m-num_E)*n_qlevel,4);
for i=1:(m-num_E)
    for j=1:n_qlevel
        oz_Y((i-1)*n_qlevel+j,3)=cost_jk(i,n_qlevel+1);
        oz_Y((i-1)*n_qlevel+j,4)=j;
    end
end

[sozY,~]=size(oz_Y);
Y=[];
while sum(oz_Y(:,2))+min(min(cost_jk(:,1:5)))<=G
if ~isempty(Y)
    [s,~]=size(Y);
    QY=min_market(m,num_E,location_E,s,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma);
else
    QY=0;
end

b_dita=0;
for i=1:sozY
    x=find(cost_jk(:,n_qlevel+1)==oz_Y(i,3));
    if oz_Y(i,2)==0 & sum(oz_Y(:,2))+cost_jk(x,oz_Y(i,4))<=G
        st_oz_Y=oz_Y;
        st_oz_Y(i,2)=cost_jk(x,oz_Y(i,4));st_oz_Y(i,1)=1;
        y=find(st_oz_Y(:,2)>0);
        st_Y=st_oz_Y(y,2:4);
        [s,~]=size(st_Y);
        st_QY=min_market(m,num_E,location_E,s,dij,Rc,Rq,st_Y,q_t,quality_N,Qj,Wi,gamma);
        dita=(st_QY-QY)./cost_jk(x,oz_Y(i,4));
    end
    if dita>b_dita
        b_dita=dita;
        b_Y=st_Y;
        b_oz_Y=st_oz_Y;
        b_QY=st_QY;
    end
end
oz_Y=b_oz_Y;
Y=b_Y;
QY=b_QY;
end
end