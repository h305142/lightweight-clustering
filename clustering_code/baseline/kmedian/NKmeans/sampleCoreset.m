function [Y,z,MinDist,MaxDist,p] = sampleCoreset(X,k,z)
[n,d] = size(X);
Y = X;
p = k*log(n)/z;
if p > 1
    K = 8*round(k + z);
    [idx,centers] = kmeans(Y,K);
else
    sampHit = rand(n,1) <= p;
    S = X(sampHit,:);
    K = 8*round(k + 2.5*z*p);
    if K>size(S,1)
        K=round(size(S,1)*0.2);
    end
    [idx,centers] = kmeans(S,K); 
    z = round(2.5*p*z);
end
Dist = pdist(centers);
MinDist = min(Dist);
MaxDist = max(Dist);
Y = centers;
end





