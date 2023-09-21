function [E,time,maxr] = DYW(data,z,k,eta,epsilon,Size)
% Bi-criteria Approximation for (k,z)_epsilon Center Clustering
% Input: An instance P of k-center clustering with z outliers; the
% parameters  eta and t.

% select points from P add them to E
tic;
[rowP,colP] = size(data);                   

% t = round(k+sqrt(k));
t=k;
ini_num=1;
cir_num = Size;

rand_order = randperm(rowP);            
E = data(rand_order(1:ini_num),:);         % initialization
% data(rand_order(1:ini_num),:) = [];        % 
z1 = round((1+epsilon)*z);            % Q_j is the farthest (1+\epsilon)z vertices to E
E = [E;zeros((t-1)*cir_num,colP)];

r1 = ini_num;
[dist_PE,Qj_index] = farthest_disk1(data,E(1:r1,:),z1);
rand_order = randperm(z1);    
r_order2 = Qj_index(rand_order(1:cir_num));
E(r1+1:r1+cir_num,:) = data(r_order2,:);       
% data(r_order2,:) = [];           
% dist_PE(r_order2,:) = [];

for j = 2:t-1
    r1 = r1 + cir_num;
    [dist_PE,Qj_index] = farthest_disk2(data,E(r1-cir_num+1:r1,:),z1,dist_PE);
    rand_order = randperm(z1);    
    r_order2 = Qj_index(rand_order(1:cir_num));
    E(r1+1:r1+cir_num,:) = data(r_order2,:);       
end

r1 = r1 + cir_num;
[dist_PE,Qj_index] = farthest_disk2(data,E(r1-cir_num+1:r1,:),z1,dist_PE);
rand_order = randperm(z1);    
r_order2 = Qj_index(rand_order(1:cir_num));
E(r1+1:r1+cir_num,:) = data(r_order2,:);       
mD = maxk(dist_PE,z+1);
maxr = mD(z+1,:);
maxr
time = toc;
end

function [dist_PE,index] = farthest_disk1(Q1,Q2,k)
D = pdist2(Q1,Q2);
dist_PE = min(D,[],2); 
[~,index] = maxk(dist_PE,k);  % index of the maximum k values in dist_PE 
end

function [dist_PE,index] = farthest_disk2(Q1,Q2,k,dist_PE) 
D = pdist2(Q1,Q2);
dist_PE1 = min(D,[],2);  
less = dist_PE>dist_PE1;    
dist_PE(less) = dist_PE1(less);
[~,index] = maxk(dist_PE,k);  
end