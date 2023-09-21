function []=alg3()
%---------configuration-----
addpath('./../../clustering_code')
addpath('../../clustering_code/lightweight/algorithm3')
ep = [0.6,0.8,1,2,4,6];
ratio = [1,1.333,1.666,2];
samp_ratio = 0.005;
%
ep_len = size(ep,2);
ratio_num = size(ratio,2);
times = 20;
cost_avg = zeros(ep_len,ratio_num); cost_var = zeros(ep_len,ratio_num);
time_avg = zeros(ep_len,ratio_num); time_var = zeros(ep_len,ratio_num);
saveFile = './alg3_results/alg3.mat';
folderPath = './alg3_results';
if ~isfolder(folderPath)
mkdir(folderPath);
end
% looping for k(different datasets)
for i = 1:ep_len %enumerate synthetic datasets based on k
    writeFile = ['./alg3_results/alg3_ep',num2str(10*ep(i)),'.txt'];
    paths = ['./../../datasets/datasets_gen/',num2str(10*ep(i)), 'data.mat'];
    if (exist(writeFile,'file'))
        delete(writeFile);
    end
    diary(writeFile);
    diary on;
    % get data
    X = load(paths); [row, column]=size(X.data);
    data = X.data; k = X.k; e1 = X.e1; e2 = X.e2; eta = 0.1;
    tabulate(X.target);
    fprintf('----KM_alg3 %d-dataset -------\n',i);
    
    % looping for different k_prime
    for beta = 1:ratio_num
        fprintf('----KM_alg3 %d-dataset %f-k beta=%f-------\n',i,k,beta);
        [n_data,~] = size(data);
        S_num=round(n_data*samp_ratio);
        k_prime = round((ratio(beta))*k) - k;
        % repeat to get AVGs and VARs
        cost_min = inf;
        cost = zeros(1,times);timer = zeros(1,times);
        for j = 1:times
            [centers,sampNum,k_prime,timer(j)] = algorithm3(data,k,X.z,...
                'sampNum',S_num,'k_prime',k_prime,'Times',10,'ValdnRatio',0.02);
            cost(j) = Sum_sqdist(centers,data,X.z);
            if cost(j) < cost_min %update
                best = j;
                cost_min = cost(j);
            end
            fprintf('%d times-- radius=%f Time=%f\n',j,cost(j) ,timer(j));
        end
        cost_avg(i,beta) = mean(cost); cost_var(i,beta) = var(cost);
        time_avg(i,beta) = mean(timer); time_var(i,beta) = var(timer);
    end
    diary off
end
save(saveFile,'cost_avg','cost_var','time_avg','time_var');
end


