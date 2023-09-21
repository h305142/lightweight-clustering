function [centers,time]=kmeansmm(data,k,z)
tic;
[n,~]=size(data);
%centers_index=randperm(n,k);
%centers=data(centers_index,:);
centers=kmeans_pp(data,k);

[distance,nst_ct]=min(pdist2(data,centers,'euclidean'),[],2);
[cost,X_inliers_index]=mink(distance,n-z);
%@[~,X_outliers_index]=maxk(distance,l);
%@X_inliers_index=setdiff(1:num,X_outliers_index);
%@cost=sum(distance(X_inliers_index));
cost=sum(cost);
X_inliers= data(X_inliers_index,:);
%X_inliers=[X(X_inliers_index,:),nst_ct(X_inliers_index)];

for i=1:k
    centers(i,:)=mean(X_inliers(nst_ct(X_inliers_index)==i,:),1);
    X_class = X_inliers(nst_ct(X_inliers_index)==i,:);
    [ClassNum,~] = size(X_class);
    %if ClassNum ~= 0
        y = X_class(1,:);
        centers(i,:)=weiszfeld(X_class,y);
    %end
end

distance_1=min(pdist2(data,centers,'euclidean'),[],2);
cost_1=sum(mink(distance_1,n-z));

while abs(cost-cost_1)>1e-5%norm(centers-centers_1)>1e-5
    [distance,nst_ct]=min(pdist2(data,centers,'euclidean'),[],2);
    [cost,X_inliers_index]=mink(distance,n-z);
    %@[~,X_outliers_index]=maxk(distance,l);
    %@X_inliers_index=setdiff(1:num,X_outliers_index);
    %@cost=sum(distance(X_inliers_index));
    cost=sum(cost);%cost=sum(cost);
    X_inliers= data(X_inliers_index,:);
    
    for i=1:k
        centers(i,:)=mean(X_inliers(nst_ct(X_inliers_index)==i,:),1);
%         X_class=X_inliers(nst_ct(X_inliers_index)==i,:);
%         y = X_class(1,:);
%         centers(i,:)=weiszfeld(X_class,y);
    end
    distance_1=min(pdist2(data,centers,'euclidean'),[],2);
    cost_1=sum(mink(distance_1,n-z));
    
end
cost_1=cost_1/(n-z);
time = toc;
end

function [y] = weiszfeld(data,y)
MaxIter=100;
[m,n]=size(data);
%y=data(1,:);
nominator=zeros(1,n);
denominator=zeros(1,n);
for iter=1:MaxIter
    for j=1:m
        xy_norm=norm((data(j,:)-y),2);
        if xy_norm>0.1
            denominator=denominator+1/xy_norm;
            nominator=nominator + data(j,:)*(1/xy_norm);
        end
    end
    y=nominator/denominator;
end
end