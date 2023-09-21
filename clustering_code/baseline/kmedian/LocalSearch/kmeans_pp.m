function [C,weight_kmean_pp,index]=kmeans_pp(X,k)
% Select the first seed by sampling uniformly at random
S = RandStream('mlfg6331_64');
index = zeros(1,k);
[C(1,:), index(1)] = datasample(S,X,1,1);
minDist = inf(size(X,1),1);
nst_ct = ones(1,size(X,1));
 

counter=k;

    
% Select the rest of the seeds by a probabilistic model
for ii = 2:counter                   
    minDist = min(minDist,pdist2(X,C(ii-1,:),'euclidean'));
    denominator = sum(minDist);
    if denominator==0 || isinf(denominator) || isnan(denominator)
        C(ii:k,:) = datasample(S,X,k-ii+1,1,'Replace',false);
        break;
    end
    sampleProbability = minDist/denominator;
    [C(ii,:), index(ii)] = datasample(S,X,1,1,'Replace',false,'Weights',sampleProbability);  
    nst_ct(minDist>pdist2(X,C(ii,:),'euclidean')) = ii;
end    


%set the weight
%[~,nst_ct]=min(pdist2(X,C),[],2);
for i=1:counter 
    weight_kmean_pp(i)=sum(nst_ct==i);
end
weight_kmean_pp=weight_kmean_pp';
