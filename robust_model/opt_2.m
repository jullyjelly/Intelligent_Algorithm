function [YN,QY,oz_YN]=opt_2(m,num_E,location_E,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma,QY,cost_jk_all,oz_Y)
 len=size(Y,1);
 YN=Y;
 oz_YN=oz_Y;
for i=1:len-1
    for j=i+1:len
        Y1=Y;
        oz_Y1=oz_Y;
        if Y(i,3)~=Y(j,3)
        Y1(i,3)=Y(j,3);
        Y1(j,3)=Y(i,3);
        [~,index,~]=intersect(oz_Y1(:,3:4),Y1(i,2:3),"rows");
		Y1(i,1)=cost_jk_all(Y1(i,2),Y1(i,3));
        oz_Y1(index,1)=1;oz_Y1(index,2)=Y1(i,1);
        
        [~,index,~]=intersect(oz_Y1(:,3:4),Y1(j,2:3),"rows");
		Y1(j,1)=cost_jk_all(Y1(j,2),Y1(j,3));
        oz_Y1(index,1)=1;oz_Y1(index,2)=Y1(j,1);
        QY1=min_market(m,num_E,location_E,len,dij,Rc,Rq,Y1,q_t,quality_N,Qj,Wi,gamma);
        else 
            QY1=QY;
        end
        if QY1>QY
            QY=QY1;
            YN=Y1;
            oz_YN=oz_Y1;
        end
    end
end
end