function [sum_dis, pred_label, pred_otlIdx] = Sum_dist(centers, data, z)
% calculate the k-means objective value with z outliers. 
    D = pdist2(data,centers,'euclidean');
    [dist,pred_label] = min(D,[],2);
    [~,pred_otlIdx] = maxk(dist,z); 
    dist(pred_otlIdx,:) = [];
    sum_dis = sum(dist);
end
