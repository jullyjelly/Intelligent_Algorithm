function [Y,oz_Y]=addquality1(G,Y,oz_Y,alpha,cost_jk,n_qlevel)
    [s,~]=size(Y);
    while floor((G-sum(oz_Y(:,2)))/(20*alpha))>=1  
        if sum(Y(:,3))<s*n_qlevel
            [s,~]=size(Y);
            index=randsrc(1,1,(1:s));
            if Y(index,3)<5
                [~,x,~]=intersect(oz_Y(:,3:4),Y(index,2:3),"rows");

                oz_Y(x,1:2)=0;
                oz_Y(x+1,1)=1;
                y=find(cost_jk(:,n_qlevel+1)==oz_Y(x+1,3));
                oz_Y(x+1,2)=cost_jk(y,oz_Y(x+1,4));
                x=find(oz_Y(:,2)~=0);
                Y=oz_Y(x,2:4);
            end
        else 
            break;
        end
    end
    
end