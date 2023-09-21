function []=DataSummary_otl()
%---------configuration-----
addpath('./../../../clustering_code/baseline/kmedian/DataSummary')
times = 20; m=2;
otl_set = [0.2,0.6,1,2,4,6,8,10];
otl_num = size(otl_set,2);
cost_avg=zeros(otl_num,1);cost_var=zeros(otl_num,1);
time_avg=zeros(otl_num,1);time_var=zeros(otl_num,1);
saveFile='./results/DataSummary.mat';
folderPath = './results';
if ~isfolder(folderPath)
mkdir(folderPath);
end
%% looping for k(different datasets)
for i=1:otl_num%enumerate synthetic datasets based on k
    writeFile=['./results/DataSummary_otl',num2str(otl_set(i)),'.txt'];
    paths = ['../../../datasets/datasets_gen_otl/k4_otl',num2str(otl_set(i)), '_data.mat'];
    if (exist(writeFile,'file'))
        delete(writeFile);
    end
    diary(writeFile);
    diary on;
    % get data
    X = load(paths);
    data= X.data; k = X.k; z=X.z;
    tabulate(X.target);
    %% repeat to get AVGs and VARs
    cost_min=inf;
    cost=zeros(1,times);timer=zeros(1,times);
    for j = 1:times
        %
        [centers, timer(j)] = DataSummary(data,k,z,m); 
        %
        cost(j) = Sum_dist(centers,X.data,X.z);
        if cost(j)<cost_min %update
            best=j;
            cost_min = cost(j);
        end
        fprintf('%d times-- radius=%f Time=%f\n',j,cost(j) ,timer(j));
    end
    cost_avg(i)=mean(cost); cost_var(i)=var(cost);
    time_avg(i)=mean(timer); time_var(i)=var(timer);
    diary off
end
save(saveFile,'cost_avg','cost_var','time_avg','time_var');
end


