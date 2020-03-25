function cost_jk_all=cal_cost(alpha,quality_N,n_qlevel,m,fj)
%计算在不同位点开设不同质量新设施的花费
cost_q=quality_N.*alpha;
cost_jk_all=zeros(m,n_qlevel+1);
for i=1:n_qlevel
    cost_jk_all(:,i)=fj;
end

for i=1:m
    cost_jk_all(i,1:n_qlevel)=cost_jk_all(i,1:n_qlevel)+cost_q;
    cost_jk_all(i,n_qlevel+1)=i;
end

end