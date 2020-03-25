function [Y,oz_Y,QY]=addquality(G,Y,oz_Y,alpha,cost_jk,n_qlevel,QY,m,num_E,location_E,dij,Rc,Rq,q_t,quality_N,Qj,Wi,gamma)
    [s,~]=size(Y);
    while floor((G-sum(oz_Y(:,2)))/(20*alpha))>=1  
        YN=Y;oz_YN=oz_Y;
        if sum(Y(:,3))<s*n_qlevel
            [s,~]=size(Y);maxQY=0;
            for index=1:s
                Y1=Y;oz_Y1=oz_Y;
                if Y1(index,3)<5
                    [~,x,~]=intersect(oz_Y1(:,3:4),Y1(index,2:3),"rows");

                    oz_Y1(x,1:2)=0;
                    oz_Y1(x+1,1)=1;
                    y=find(cost_jk(:,n_qlevel+1)==oz_Y1(x+1,3));
                    oz_Y1(x+1,2)=cost_jk(y,oz_Y1(x+1,4));
                    x=find(oz_Y1(:,2)~=0);
                    Y1=oz_Y1(x,2:4);
                    s=size(Y1,1);
                    QY1=min_market(m,num_E,location_E,s,dij,Rc,Rq,Y1,q_t,quality_N,Qj,Wi,gamma);
                
                    if QY1>maxQY
                        maxQY=QY1;
                        YN=Y1;
                        oz_YN=oz_Y1;
                    end
                end
            end
        else 
            break;
        end
        Y=YN;oz_Y=oz_YN;QY=maxQY;
    end
    
end
