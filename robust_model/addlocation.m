function  [Y,oz_Y]=addlocation(rjk,Y,oz_Y)
    candi_rjk=rjk;
    [s,~]=size(Y);
    for i=1:s
        x=find(candi_rjk(:,3)==Y(i,2));
        candi_rjk(x,:)=[];
    end    
    sum_rjk=candi_rjk;
    sum_rjk(:,1)=cumsum(candi_rjk(:,1));
    [size_srjk,~]=size(sum_rjk);
    sum_rjk(:,1)=sum_rjk(:,1)./sum_rjk(size_srjk,1);
    sum_rjk=[0 0 0 0;sum_rjk];
    lunpan=rand;
    for i=1:size_srjk
        if lunpan>=sum_rjk(i,1) && lunpan<sum_rjk(i+1,1)
            [~,y,~]=intersect(oz_Y(:,3:4),candi_rjk(i,3:4),"rows");
            oz_Y(y,1)=1;
            oz_Y(y,2)=candi_rjk(i,2);
            break;
        end
    end
    x=find(oz_Y(:,2)~=0);
    Y=oz_Y(x,2:4);