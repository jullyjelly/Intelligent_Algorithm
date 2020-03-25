function [Y,oz_Y]=crossover(Y,oz_Y,rjk,G)
      
   [Y,oz_Y]=addlocation(rjk,Y,oz_Y);   
 
    while sum(oz_Y(:,2))>G
        [s,~]=size(Y);
        cross_index=randsrc(1,1,(1:s));
        [~,x,~]=intersect(oz_Y(:,3:4),Y(cross_index,2:3),"rows");
        oz_Y(x,1:2)=0;
        Y(cross_index,:)=[];
    end
end



