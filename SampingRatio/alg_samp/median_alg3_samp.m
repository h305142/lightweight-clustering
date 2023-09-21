function []=median_alg3_samp()
%---------configuration-----
addpath('./../../clustering_code')
addpath('../../clustering_code/lightweight/median_algorithm3')
times=20;
ep = [0.6,0.8,1,2,4,6];
sample = [0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.10]/10;
ep_len = size(ep,2);
sample_len = size(sample,2);
repetition = 10;
ValdnNum = 2000;
cost_avg=zeros(ep_len,sample_len); cost_var=zeros(ep_len,sample_len);
time_avg=zeros(ep_len,sample_len); time_var=zeros(ep_len,sample_len);
saveFile='./median_alg3_samp_results/alg3_samp.mat';
folderPath = './median_alg3_samp_results';
if ~isfolder(folderPath)
mkdir(folderPath);
end
% looping for ep(e1/e2)(different datasets)
for i=1:ep_len %enumerate synthetic datasets based on ep
    writeFile=['./median_alg3_samp_results/alg3_samp',num2str(ep(i)*10),'.txt'];
    paths = ['../../datasets/datasets_gen/',num2str(ep(i)*10), 'data.mat'];
    if (exist(writeFile,'file'))
        delete(writeFile);
    end
    diary(writeFile);
    diary on;
    % get data
    X = load(paths);[row, column]=size(X.data);
    data= X.data; k = X.k; e1=X.e1; e2=X.e2; eta=0.1;
    tabulate(X.target);
    fprintf('----KMedian_alg3_samp %d-dataset ------------------------------------\n',i);
    % looping for different sampling size
    for sampleIndex = 1:sample_len
        fprintf('----KM_alg3_samp %d-dataset %f-sample -------\n',i,sample(sampleIndex));
        [n_data,~] = size(data);
        S_num=round(n_data*sample(sampleIndex));
        k_prime = round(2*e2/k*S_num);
        % k_prime = k;
        % repeat to get AVGs and VARs
        cost_min=inf;
        cost=zeros(1,times);timer=zeros(1,times);
        ValdnRatio = ValdnNum/n_data;
        for j = 1:times
            [centers,sampNum,k_prime,timer(j)]=algorithm3(data,k,X.z,...
                'sampNum',S_num,'k_prime',k_prime,'Times',repetition,'ValdnRatio',ValdnRatio);
            cost(j) = Sum_dist(centers,data,X.z);
            if cost(j)<cost_min %update
                best=j;
                cost_min = cost(j);
            end
            fprintf('%d times-- radius=%f Time=%f\n',j,cost(j) ,timer(j));
        end
        cost_avg(i,sampleIndex) = mean(cost); cost_var(i,sampleIndex) = var(cost);
        time_avg(i,sampleIndex) = mean(timer); time_var(i,sampleIndex) = var(timer);
    end
    diary off
end
save(saveFile,'cost_avg','cost_var','time_avg','time_var');
end


