function [Y,z,MinDist,MaxDist,p,weight] = sampleCoreset1(X,k,z)
[n,d] = size(X);
Y = X;
p = 2.5*k*log(n)/z;
if p > 1
    K =round( k + z);
    [idx,centers] = kmeans(Y,K);
else
    sampHit = rand(n,1) <= p;
    S = X(sampHit,:);
    K =round( k + z*p);
    [idx,centers] = kmeans(S,K); 
    z = round(p*z);
end
weight=zeros(K,1);
for i=1:K
    weight(i)=sum(idx==i);
end
    
Dist = pdist(centers);
MinDist = min(Dist);
MaxDist = max(Dist);
Y = centers;
end




