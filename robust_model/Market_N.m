function [QY,xstar]=Market_N(Qj,dij,N_exist,N_new,d_t,q_t,yjk,Wi,gamma)
[ACY,AQY]=Attraction_obj(Qj,dij,N_exist,N_new,d_t,q_t,yjk);  %根据解yjk生成新进企业获取的客户便利性需求及质量性需求比例
ai=ACY-AQY;
bi=Wi;
lambda=gamma*sum(Wi);
[QY1,xstar]=SortA(ai,bi,lambda);
QY=QY1+sum(Wi.*AQY);     %求得最坏情景下yjk所对应的新进企业所获取的总需求