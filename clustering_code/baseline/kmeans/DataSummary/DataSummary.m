function [centers,time]=DataSummary(data,k,z,m)
tic;
%
[row, column]=size(data);
Summaries = [];Weights = [];
reorder = randperm(row);
span = floor(row/m);
for ii = 1:m-1
    [Q,weight] = summary(...
        data(reorder((ii-1)*span+1:ii*span),:),2*z/m,k);
    Summaries = [Summaries;Q];Weights = [Weights;weight];
end
[Q,weight] = summary(...
    data(reorder((m-1)*span+1:row),:),2*z/m,k);
Summaries = [Summaries;Q];Weights = [Weights;weight];
%[~,centers]=kmeans(Summaries,k);
[centers] = kmeans_mm_weight(Summaries,Weights,k,z);
time=toc;
end


