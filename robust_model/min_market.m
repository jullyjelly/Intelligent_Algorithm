function QY=min_market(m,num_E,location_E,num_N,dij,Rc,Rq,Y,q_t,quality_N,Qj,Wi,gamma)
[ACY,AQY]=Attraction_obj(m,num_E,location_E,num_N,dij,Rc,Rq,Y,q_t,quality_N,Qj);
ai=ACY-AQY;
bi=Wi;
lambda=gamma*sum(Wi);
[QY1,xstar]=SortA(ai,bi,lambda);
QY=QY1+sum(Wi.*AQY);
end