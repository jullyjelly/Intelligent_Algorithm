function [QY,xstar]=SortA(ai,bi,lambda)
% sorting-based algorithm to solve the linear programming: \min \sum (ai*bi*xi) s.t. \sum(bi*xi)>=lambda, 0\leq xi\leq 1.
n=length(ai);
xstar=zeros(1,n);
[a,b]=sort(ai);
a1=a;
b1=bi(b);
s=sum(a1<0);
bcum=cumsum(b1);
k=sum(bcum<lambda);
c=a1.*b1;
if s>=k+1
    QY=sum(c(1:s));
    xstar(1:s)=1;
else
    QY=sum(c(1:k))+a(k+1)*(lambda-sum(b1(1:k)));
    xstar(1:k)=1;
    xstar(k+1)=(lambda-sum(b1(1:k)))/b1(k+1);
end
xstar(b)=xstar;
end