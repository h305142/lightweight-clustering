function [centers] = RC1(n,data,k,z,weight)
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
    r = distance(round((1+n)/2));
    right = distance(n);
    left = distance(1);
    % centers = zeros(k,d);
    count = 1;
    while count < log(n)/log(2)
        [cover_ratio,~] = RobustCluster1(data,k,r,distance_matrix,ball_ampli_coeff);
        if cover_ratio == accept_ratio
            break;
        end
        if cover_ratio > accept_ratio
           r = (r+left)/2;
           right = r;
        else
           r = (r+right)/2;
           left = r;
        end
        count = count+1;
    end
    [~,centers] = RobustCluster1(data,k,r,distance_matrix,ball_ampli_coeff,weight);

end