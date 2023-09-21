function [radius, pred_label, pred_otlIdx] = Radius(centers, data, z)
    D = pdist2(data,centers);
    [dist,pred_label] = min(D,[],2);
    [maxkDist,pred_otlIdx] = maxk(dist,z+1); 
    pred_otlIdx(z+1) = [];
    radius = maxkDist(z+1,:);
end