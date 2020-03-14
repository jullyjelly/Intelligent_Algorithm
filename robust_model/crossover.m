function Y=crossover(cost_jk,num_N,n_qlevel,cross_index1,Y,rjk,G)
    Ystar=Y;
    candi_rjk=rjk;
    for i=1:num_N
        if i~=cross_index1
            x=find(candi_rjk(:,2)==Y(i,2));
            candi_rjk(x,:)=[];
        else
            x=find(candi_rjk(:,2)==Y(i,2) & candi_rjk(:,3)==Y(i,3));
            candi_rjk(x,:)=[];
        end
    end
    
    x=find(candi_rjk(:,4)<=(G-sum(Y(:,1))+Y(cross_index1,1)));
    if ~isempty(x)
        candi_rjk=candi_rjk(x,:);    
        sum_rjk=candi_rjk;
        sum_rjk(:,1)=cumsum(candi_rjk(:,1));
        [size_srjk,~]=size(sum_rjk);
        sum_rjk(:,1)=sum_rjk(:,1)./sum_rjk(size_srjk,1);
        sum_rjk=[0 0 0 0;sum_rjk];
        lunpan=rand;
        for i=1:size_srjk
            if lunpan>=sum_rjk(i,1) && lunpan<sum_rjk(i+1,1)
                x=find(cost_jk(:,n_qlevel+1)==candi_rjk(i,2));
                Y(cross_index1,1)=cost_jk(x,candi_rjk(i,3));
                Y(cross_index1,2)=cost_jk(x,n_qlevel+1);
                Y(cross_index1,3)=candi_rjk(i,3);
            end
        end
    else
        Y=Ystar;
    end
end