function [ACY,AQY]=Attraction_obj(m,num_E,location_E,num_N,dij,Rc,Rq,Y,q_t,quality_N,Qj)
%º∆À„Œ¸“˝¡¶
ACE=zeros(m,1);AQE=zeros(m,1);ACN=zeros(m,1);AQN=zeros(m,1);ACY=zeros(m,1);AQY=zeros(m,1);
for i=1:m
    for j=1:num_E
        dist=dij(i,location_E(j));
        if dist<Rc
            ACE(i,1)=ACE(i,1)+Qj(location_E(j),1)/(1+dist^2);
        end
        if dist<Rq && Qj(location_E(j),1)>=q_t
            AQE(i,1)=AQE(i,1)+Qj(location_E(j),1)/(1+dist^2);
        end
    end
    for j=1:num_N
        dist=dij(i,Y(j,2));
        if dist<=Rc
            ACN(i,1)=ACN(i,1)+quality_N(Y(j,3))/(1+dist^2);
        end
        if dist<Rq && quality_N(Y(j,3))>=q_t
            AQN(i,1)=AQN(i,1)+quality_N(Y(j,3))/(1+dist^2);
        end
    end
    ACY(i,1)=ACN(i,1)/(ACE(i,1)+ACN(i,1)+0.1);
    AQY(i,1)=AQN(i,1)/(AQE(i,1)+AQN(i,1)+0.1);
end

end