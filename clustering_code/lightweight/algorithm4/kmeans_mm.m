function [centers,cost_1]=kmeans_mm(data,k,z)
[n,~]=size(data);
% Heuristic method to get the centers
centers=kmeans_pp(data,k);
% get inliers
[distance,nst_ct]=min(pdist2(data,centers,'squaredeuclidean'),[],2);
[cost,X_inliers_index]=mink(distance,n-z);
cost=sum(cost);
X_inliers= data(X_inliers_index,:);

for i=1:k
    centers(i,:)=mean(X_inliers(nst_ct(X_inliers_index)==i,:),1);
end

distance_1=min(pdist2(data,centers,'squaredeuclidean'),[],2);
cost_1=sum(mink(distance_1,n-z));

while abs(cost-cost_1)>1e-5
    % get inliers
    [distance,nst_ct]=min(pdist2(data,centers,'squaredeuclidean'),[],2);
    [cost,X_inliers_index]=mink(distance,n-z);
    cost=sum(cost);
    X_inliers= data(X_inliers_index,:);
    % update centers
    for i=1:k
        centers(i,:)=mean(X_inliers(nst_ct(X_inliers_index)==i,:),1);
    end
    distance_1=min(pdist2(data,centers,'squaredeuclidean'),[],2);
    cost_1=sum(mink(distance_1,n-z));
    
end
    cost_1=cost_1/(n-z);
end
    
    