function [E,time,maxr] = DYW(data,z,k,eta,epsilon,Size)
% Bi-criteria Approximation for (k,z)_epsilon Center Clustering
% Input: An instance data of k-center clustering with z outliers; the
% parameters  eta and t.
    
% select points from data add them to E  
    tic;
    [rowP,colP] = size(data);                  
    dist_PE = zeros(rowP,1);
    gamma = z/rowP;
    t = k;
    t = round(k+sqrt(k));
    ini_num = round(log(eta)/log(1-gamma)/20)/2; 
    % ini_num=1;
    % cir_num = round(log(1/eta)/log(1+epsilon)*Size);   
    cir_num = Size;
    rand_order = randperm(rowP);            
    E = data(rand_order(1:ini_num),:);         
    data(rand_order(1:ini_num),:) = [];        
    dist_PE(rand_order(1:ini_num),:)= [];
    z1 = round((1+epsilon)*z);                    
    E = [E;zeros((t-1)*cir_num,colP)];
    
    r1 = ini_num;
    [dist_PE,Qj_index] = farthest_disk1(data,E(1:r1,:),z1);
    rand_order = randperm(z1);   
    r_order2 = Qj_index(rand_order(1:cir_num));
    E(r1+1:r1+cir_num,:) = data(r_order2,:);       
    data(r_order2,:) = [];            
    dist_PE(r_order2,:) = []; 
  
    for j = 2:t-1
        r1 = r1 + cir_num;
        [dist_PE,Qj_index] = farthest_disk2(data,E(r1-cir_num+1:r1,:),z1,dist_PE);
        rand_order = randperm(z1);   
        r_order2 = Qj_index(rand_order(1:cir_num));
        E(r1+1:r1+cir_num,:) = data(r_order2,:);      
        data(r_order2,:) = [];          
        dist_PE(r_order2,:) = [];
        
    end
    
    r1 = r1 + cir_num;
    [dist_PE,Qj_index] = farthest_disk2(data,E(r1-cir_num+1:r1,:),z1,dist_PE);
    rand_order = randperm(z1);  
    r_order2 = Qj_index(rand_order(1:cir_num));
    E(r1+1:r1+cir_num,:) = data(r_order2,:);              
    dist_PE(r_order2,:) = [];    
    [~,index_max] = maxk(dist_PE,z);
    dist_PE(index_max,:) = [];
    maxr = sqrt(max(dist_PE));
    time = toc;
end

function [dist_PE,index] = farthest_disk1(Q1,Q2,k)

    rowQ1 = size(Q1,1); 
    rowQ2 = size(Q2,1); 
    D = sum(Q1.*Q1,2)*ones(1,rowQ2) + ones(rowQ1,1)*sum(Q2.*Q2,2)' - 2*Q1*Q2';
    dist_PE = min(D,[],2);  
    [~,index] = maxk(dist_PE,k);  
end

function [dist_PE,index] = farthest_disk2(Q1,Q2,k,dist_PE)
    rowQ1 = size(Q1,1); 
    rowQ2 = size(Q2,1); 
    D = sum(Q1.*Q1,2)*ones(1,rowQ2) + ones(rowQ1,1)*sum(Q2.*Q2,2)' - 2*Q1*Q2';
    dist_PE1 = min(D,[],2);  
    less = dist_PE<dist_PE1;     
    dist_PE = dist_PE.*less + dist_PE1.*(1-less);
    [~,index] = maxk(dist_PE,k);  
end