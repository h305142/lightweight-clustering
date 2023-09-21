function [centers_]=kmeans_mm_weight(X,weight,k,outliers,centers_initial)
num=floor(sum(weight));

if nargin==5
    centers=centers_initial;
else
    centers_index=randperm(size(X,1),k);
    centers=X(centers_index,:);
end


[distance,nst_ct]=min(pdist2(X,centers,'squaredeuclidean'),[],2);
cost=sum(distance.*weight/(num-outliers));
for i=1:k
    centers_(i,:)=update_centers(X,weight,i,nst_ct);
end
[distance_,nst_ct]=min(pdist2(X,centers_,'squaredeuclidean'),[],2);
cost_=sum(distance_.*weight/(num-outliers));

while abs(cost-cost_)>1e-5
centers=centers_;
cost=cost_;

for i=1:k
    centers_(i,:)=update_centers(X,weight,i,nst_ct);
end
[distance_,nst_ct]=min(pdist2(X,centers_,'squaredeuclidean'),[],2);
cost_=sum(distance_.*weight/(num-outliers));


%fprintf('%f\n',cost_);


end

end



function centers_i=update_centers(X,weight_rm_out,i,nst_ct)
X=X(nst_ct==i,:);
weight=weight_rm_out(nst_ct==i);
X=X.*weight/sum(weight);
centers_i=sum(X,1);

end