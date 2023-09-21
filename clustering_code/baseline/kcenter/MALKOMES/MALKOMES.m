function [centers,time]=MALKOMES(data,k,z,m)
tic;
%
[row, column]=size(data);
k_prime = k+z;
coresets =zeros(m*k_prime,column); weights = zeros(m*k_prime,1);
r_or = randperm(row);
per = round(row/m);
for ii = 1:m-1
    [subset,subweight] = Gonzalez(data(r_or((ii-1)*per+1:ii*per),:),k_prime);
    coresets((ii-1)*k_prime+1:ii*k_prime,:) = subset;
    weights((ii-1)*k_prime+1:ii*k_prime,:) = subweight;
end
[subset,subweight] = Gonzalez(data(r_or((m-1)*per+1:row),:),k_prime);
coresets((m-1)*k_prime+1:m*k_prime,:) = subset;
weights((m-1)*k_prime+1:m*k_prime,:) = subweight;
centers = Weighted_CHARIKAR(m*k_prime,coresets,k,z,weights);
%
time=toc;
end


