function [centers,time]=kmeansmm(data,k,z)
tic;
[n,~]=size(data);
%centers_index=randperm(n,k);
%centers=data(centers_index,:);
centers=kmeans_pp(data,k);

[distance,nst_ct]=min(pdist2(data,centers,'squaredeuclidean'),[],2);
[cost,X_inliers_index]=mink(distance,n-z);
%@[~,X_outliers_index]=maxk(distance,l);
%@X_inliers_index=setdiff(1:num,X_outliers_index);
%@cost=sum(distance(X_inliers_index));
cost=sum(cost);
X_inliers= data(X_inliers_index,:);
%X_inliers=[X(X_inliers_index,:),nst_ct(X_inliers_index)];

for i=1:k
    centers(i,:)=mean(X_inliers(nst_ct(X_inliers_index)==i,:),1);
end

distance_1=min(pdist2(data,centers,'squaredeuclidean'),[],2);
cost_1=sum(mink(distance_1,n-z));

while abs(cost-cost_1)>1e-5%norm(centers-centers_1)>1e-5
    [distance,nst_ct]=min(pdist2(data,centers,'squaredeuclidean'),[],2);
    [cost,X_inliers_index]=mink(distance,n-z);
    %@[~,X_outliers_index]=maxk(distance,l);
    %@X_inliers_index=setdiff(1:num,X_outliers_index);
    %@cost=sum(distance(X_inliers_index));
    cost=sum(cost);%cost=sum(cost);
    X_inliers= data(X_inliers_index,:);
    
    for i=1:k
        centers(i,:)=mean(X_inliers(nst_ct(X_inliers_index)==i,:),1);
    end
    distance_1=min(pdist2(data,centers,'squaredeuclidean'),[],2);
    cost_1=sum(mink(distance_1,n-z));
    
end
cost_1=cost_1/(n-z);
time = toc;
end

