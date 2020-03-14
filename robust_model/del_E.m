function cost_jk=del_E(n_qlevel,location_E,cost_jk_all)
cost_jk=cost_jk_all;
for i=1:1:n_qlevel
    x=find(cost_jk(:,n_qlevel+1)==location_E(i));
    cost_jk(x,:)=[];
end
end