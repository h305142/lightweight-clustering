function []=alg4_z()
%---------configuration-----
addpath('./../../clustering_code/')
addpath('./../../clustering_code/lightweight/algorithm4')
ep = [2,3,4,5,6];
z_ratio = [1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2.0];
samp_ratio = 0.005;
%
ep_num = size(ep,2);
z_len = size(z_ratio,2);
times = 20;
repetition = 10;
cost_avg = zeros(ep_num,z_len); cost_var = zeros(ep_num,z_len);
saveFile = './alg4_z_results/alg4_z.mat';
folderPath = './alg4_z_results';
if ~isfolder(folderPath)
mkdir(folderPath);
end
% looping for ep(e1/e2)(different datasets)
for i = 1:ep_num %enumerate synthetic datasets based on ep
    writeFile=['./alg4_z_results/alg4_z',num2str(ep(i)*10),'.txt'];
    paths = ['./../../datasets/datasets_gen/',num2str(ep(i)*10), 'data.mat'];
    if (exist(writeFile,'file'))
        delete(writeFile);
    end
    diary(writeFile);
    diary on;
    % get data
    X = load(paths); [row, column]=size(X.data);
    data = X.data; k = X.k; e1 = X.e1; e2 = X.e2; eta=0.1;
    tabulate(X.target);
    fprintf('----KC_alg4_z %d-dataset -------\n',i);
    
    
    % looping for different sampling size
    for zIdx = 1:z_len
        fprintf('----KC_ALG4_TEST_SYN %d-dataset %f-z_ratio -------\n',i,z_ratio(zIdx));
        [n_data,~] = size(data);
        S_num = round(n_data*samp_ratio);
        z_prime = round(z_ratio(zIdx)*e2/k*S_num);
        % repeat to get AVGs and VARs
        cost_min = inf;
        cost=zeros(1,times); timer=zeros(1,times);
        for j = 1:times
            if z_prime > S_num
                fprintf('z_prime is larger than S_num, we set S_num= 2*z_prime!!\n');
                S_num = 2*(z_prime);
            end
            [centers,sampNum,z_prime,timer(j)] = algorithm4(data,k,X.z,...
                'sampNum',S_num,'z_prime',z_prime,'Times',6,'ValdnRatio',0.02);
            cost(j) = Sum_sqdist(centers,data,X.z);
            if cost(j) < cost_min %update
                best = j;
                cost_min = cost(j);
            end
            fprintf('%d times-- radius=%f Time=%f\n',j,cost(j),timer(j));
        end
        cost_avg(i,zIdx) = mean(cost); cost_var(i,zIdx) = var(cost);
        time_avg(i,zIdx) = mean(timer); time_var(i,zIdx) = var(timer);
    end
end
save(saveFile,'cost_avg','cost_var','time_avg','time_var');
end


