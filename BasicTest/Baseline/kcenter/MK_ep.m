function []=MK_ep()
%---------configuration-----
addpath('./../../../clustering_code')
addpath('./../../../clustering_code/baseline/kcenter/MK')
times = 20;
ep = [0.6,0.8,1,2,4,6];
ep_len = size(ep,2);
cost_avg=zeros(ep_len,1);cost_var=zeros(ep_len,1);
time_avg=zeros(ep_len,1);time_var=zeros(ep_len,1);
saveFile='./results/MK.mat';
folderPath = './results';
if ~isfolder(folderPath)
mkdir(folderPath);
end
%% looping for k(different datasets)
for i=1:ep_len%enumerate synthetic datasets based on k
    writeFile=['./results/MK_ep',num2str(10*ep(i)),'.txt'];
    paths = ['./../../../datasets/datasets_gen/',num2str(10*ep(i)), 'data.mat'];
    if (exist(writeFile,'file'))
        delete(writeFile);
    end
    diary(writeFile);
    diary on;
    % get data
    X = load(paths);
    data= X.data; k = X.k;
    tabulate(X.target);
    %% repeat to get AVGs and VARs
    cost_min=inf;
    cost=zeros(1,times);timer=zeros(1,times);
    for j = 1:times
        tmark= tic;
        %
        [centers,time] = MK(data,k,X.z);
        %
        timer(j) = toc(tmark);
        cost(j) = Radius(centers,data,X.z);
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


