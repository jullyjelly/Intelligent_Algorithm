function Y=budget_limit(G,num_N,cost_jk,n_qlevel,quality_index,Y)
while sum(Y(:,1))>G  
    %����ʼ���ɵĽ����Ԥ����Ҫ�����������
    cross_index1=randsrc(1,1,(1:num_N));%����λ��
    %���Խ�����ѡ��
    cross_candi=cost_jk;
    for i=1:num_N
        if i~=cross_index1
            x=find(cross_candi(:,n_qlevel+1)==Y(i,2));
            cross_candi(x,:)=[];
        end
    end
    [size_crocandi,~]=size(cross_candi);
    
    cross_index2=randsrc(1,1,(1:size_crocandi));
    if cross_candi(cross_index2,n_qlevel+1)==Y(cross_index1,2) 
        if Y(cross_index1,3)~=1
            quality_candi=quality_index;
            quality_candi=quality_candi(1,1:Y(cross_index1,3)-1);
            q_index=randsrc(1,1,(1:length(quality_candi)));
            Y(cross_index1,3)=q_index;
            Y(cross_index1,1)=cross_candi(cross_index2,q_index);
        else
              return;
        end
    else
        q_index=randsrc(1,1,(1:length(quality_index)));
        Y(cross_index1,2)=cross_candi(cross_index2,n_qlevel+1);
        Y(cross_index1,3)=q_index;
        Y(cross_index1,1)=cross_candi(cross_index2,q_index);
    end
end
end