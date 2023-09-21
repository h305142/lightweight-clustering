function [centers] = Weighted_CHARIKAR(n,data,k,z,weights)
    
    accept_ratio = (n-z)/n;
    %*******************CONTROL CONFIGURATION********************
    distance_cmprs_coeff=1;
    ball_ampli_coeff=3;
    %******************************************************
    
    % get the sorted pairwise distance
    distance_matrix=pdist2(data,data);
    distance_matrix_upper=triu(distance_matrix);
    distance = distance_matrix_upper(:);
    distance = sort(distance(distance>0));
    % distance_compressed = distance./distance_cmprs_coeff;
    % using binary search to obtain the smallest r that satisfy our cover
    % number
    left = 1;right = size(distance,1);
    mid = floor((left+right)/2);
    while left ~= right 
        [cover_ratio,~] = RobustCluster(data, k, distance(mid),...
            distance_matrix, ball_ampli_coeff, weights);
        if cover_ratio == accept_ratio
            break;
        end
        if cover_ratio > accept_ratio
            mid = floor((mid + left)/2); right = mid; 
        else
            mid = floor((mid + right)/2); left = mid;
        end
    end
    [~,centers] = RobustCluster(data,k,distance(mid),...
        distance_matrix,ball_ampli_coeff,weights);

end