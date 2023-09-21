function [cover_ratio,centers] = RobustCluster(data,k,r,distance_matrix,ball_ampli_coeff)
% Given k and r
[n,d] = size(data);
coverd = zeros(1,n);
centers = zeros(k,d);
% k1=k; %%use for draw the picture
G = distance_matrix<=r;
E = distance_matrix<=ball_ampli_coeff*r;
for i = 1:k
    [r,heaviest_index] = max(sum(G,2));
    coverd(E(heaviest_index,:)) = 1;
    if r == 0
        break;
    end
    centers(i,:) = data(heaviest_index,:);
    G(:,E(heaviest_index,:)) = 0; %G(E(heaviest_index,:),:) = 0;
    E(:,E(heaviest_index,:)) = 0; %E(E(heaviest_index,:),:) = 0;
end

cover_ratio=sum(coverd)/n;
end

            
            

            