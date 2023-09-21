function [centers,X_outliers_index]=local_search_outlier(X,k,z,ep_lso,weight)

num=size(X,1);
centers=kmeans_pp(X,k);

X_outliers_index=[];
alpha=Inf;
while alpha*(1-ep_lso/k)>cost_ct_ins(X,X_outliers_index,centers,weight)
    alpha = cost_ct_ins(X,X_outliers_index,centers,weight);
    
    % (i)local search with no outliers
    centers = local_search(X(setdiff(1:num,X_outliers_index),:),centers,...
                     k,ep_lso,weight(setdiff(1:num,X_outliers_index)));
    return;
    C_=centers;
    X_outliers_index_ = X_outliers_index;
    
    % (ii)cost of discarding l addtional outliers
    if cost_ct_ins(X,X_outliers_index,centers,weight)*(1-ep_lso/k)>...
        cost_ct_ins(X,union(X_outliers_index,...
       outliers(X,centers,X_outliers_index,z)),centers,weight)
   
        cost_ct_ins(X,X_outliers_index,centers,weight)
        cost_ct_ins(X,union(X_outliers_index,...
       outliers(X,centers,X_outliers_index,z)),centers,weight)
   
        X_outliers_index_=union(X_outliers_index,outliers...
            (X,centers,X_outliers_index,z));
         
    end
    
    % (iii)for each center and non-center, perform .....
    TC_Cost = cost_ct_ins(X,X_outliers_index_,C_,weight);
    for i=1:num
        for j=1:k
            centers_=centers;
            centers_(j,:)=X(i,:);
            if cost_ct_ins(X,union(X_outliers_index,...
               outliers(X,centers_,[],z)),centers_,weight)...
               < TC_Cost
                
                C_=centers_;
                X_outliers_index_=union(X_outliers_index,...
                outliers(X,centers_,[],z));
                TC_Cost = cost_ct_ins(X,X_outliers_index_,C_,weight);
            end
            
        end 
    end
    
    if cost_ct_ins(X,X_outliers_index,centers,weight)*(1-ep_lso/k)>...
            cost_ct_ins(X,X_outliers_index_,C_,weight)
        cost_ct_ins(X,X_outliers_index_,C_,weight)
        centers=C_;
        % disp(centers);
        X_outliers_index=X_outliers_index_;
        % disp(size(X_outliers_index,1));
    end
    
end

end



function outliers_index=outliers(X,centers,X_outliers_index,z)
    distance=min(pdist2(X,centers),[],2);
    distance(:,2)=1:size(distance,1);
    distance(X_outliers_index,:)=[];
    if size(distance,1)==0
        outliers_index=[];
        % disp('#');
    else
        distance=sortrows(distance,'descend');
        outliers_index=distance(1:min(z,size(distance,1)),2);
    end
end

function cost=cost_ct_ins(X,X_outliers_index,centers,weight)
    num=size(X,1);
    X_inliers_index=setdiff(1:num,X_outliers_index);
    X=X(X_inliers_index,:);
    weight=weight(X_inliers_index);
    distance=min(pdist2(X,centers,'euclidean'),[],2);
    cost=sum(distance.*weight);
end