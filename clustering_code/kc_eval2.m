function [purity, pre]=kc_eval2(true_label,pred_label)%true_label,pred_label
%% true_label: the true labels of data
%% pred_label: the labels obtained by clustering algorithm.
% true_label = [1,1,1,1,1,1,1,1,1,2,1,1,1,1,2];%class labels
% pred_label = [1,1,2,1,1,1,1,1,2,1,2,1,2,1,1];%cluster labels
% pred_label = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];%cluster labels
% true_label = [1,1,1,1,1,1,1,1,2,2,2,2,2,3,3,3,3];%class labels
% pred_label = [1,1,1,1,1,2,3,3,2,2,2,2,1,2,3,3,3];%cluster labels
%% function [NMI, RI, F] = compute_clutering_metric(idx, item_ids)

N = length(true_label);
class_label = unique(true_label);
cluster_label = unique(pred_label);
count = 0;
for i = 1:numel(cluster_label)
    member_idx = find(pred_label == cluster_label(i));
    member_true_label = true_label(member_idx);
    [M,F] = mode(member_true_label);
    count = count + F;
end

purity = count / (N);

end

