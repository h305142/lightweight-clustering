function centers=local_search(X,centers,k,ep_lso,weight)

num=size(X,1);

alpha=Inf;
C = cost_km(X,centers,weight);
while alpha*(1-ep_lso/k)>C
    alpha=C;
    C_=centers;
    
    % for each center and non-center, perform a swap
    TCost = cost_km(X,C_,weight);
    for i=1:num
        for j=1:k
            centers_=centers;
            centers_(j,:)=X(i,:);
            if cost_km(X,centers_,weight)< TCost
                C_=centers_;
                TCost = cost_km(X,C_,weight);
            end
        end
    end
    
    centers=C_;
    C = cost_km(X,centers,weight);
    % disp(alpha);
end

end


function cost=cost_km(X,centers,weight)
    distance=min(pdist2(X,centers,'euclidean'),[],2);
    if nargin==3
        cost=sum(distance.*weight);
    elseif nargin==2
        cost=sum(distance);
    end
end