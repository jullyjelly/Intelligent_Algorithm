function [quality_N,quality_index]=al_q_level(n_qlevel)
%��ͬ����ˮƽ�ĵ�λ�ɱ�  ����ˮƽ
quality_N=zeros(1,n_qlevel);
quality_index=zeros(1,n_qlevel);
for i=1:n_qlevel
    quality_N(1,i)=20*i;
    quality_index(1,i)=i;
end
end
