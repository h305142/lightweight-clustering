function [centers,time]=LocalSearch_k(data,k,z)
tic;
ep_lso=0.1;
k_prime = 2*(k+z);
[~,coresets,~,D] = kmeans(data,k_prime);
[~,nst_ct] = min(D,[],2);
weight = zeros(k_prime,1);
for ii=1:k_prime
    weight(ii)=sum(nst_ct==ii);
end
[centers,~] = local_search_outlier(coresets,k,z,ep_lso,weight);
time = toc;
end


