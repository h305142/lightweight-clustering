function [centers_]=kmeans_mm_weight(X,weight,k,l,centers_initial)
%global l;
num=floor(sum(weight));
if nargin==5
    centers=centers_initial;
else
    centers_index=randperm(size(X,1),k);
    centers=X(centers_index,:);
end
[distance,nst_ct]=min(pdist2(X,centers,'squaredeuclidean'),[],2);
weight_rm_out=update_weight(distance,weight,l);
cost=sum(distance.*weight_rm_out/(num-l));
for i=1:k
    centers_(i,:)=update_centers(X,weight_rm_out,i,nst_ct);
end
[distance_,nst_ct]=min(pdist2(X,centers_,'squaredeuclidean'),[],2);
weight_rm_out=update_weight(distance_,weight,l);
cost_=sum(distance_.*weight_rm_out/(num-l));
while abs(cost-cost_)>1e-5
    centers=centers_;
    cost=cost_;
    for i=1:k
        centers_(i,:)=update_centers(X,weight_rm_out,i,nst_ct);
    end
    [distance_,nst_ct]=min(pdist2(X,centers_,'squaredeuclidean'),[],2);
    weight_rm_out=update_weight(distance_,weight,l);
    cost_=sum(distance_.*weight_rm_out/(num-l));
    %fprintf('%f\n',cost_);
end
end
function [weight_rm_out]=update_weight(distance,weight,l)
%global l;
[~,X_outlier_index]=maxk(distance,l);
weight_sum=0;
i=0;
while weight_sum<l
    i=i+1;
    if weight_sum+weight(X_outlier_index(i))>=l
        weight(X_outlier_index(i))=weight(X_outlier_index(i))-(l-weight_sum);
        break;
    else
        weight_sum=weight_sum+weight(X_outlier_index(i));
        weight(X_outlier_index(i))=0;
    end
end
weight_rm_out=weight;
end


function centers_i=update_centers(X,weight_rm_out,i,nst_ct)
X=X(nst_ct==i,:);
weight=weight_rm_out(nst_ct==i);
X=X.*weight/sum(weight);
centers_i=sum(X,1);
end
