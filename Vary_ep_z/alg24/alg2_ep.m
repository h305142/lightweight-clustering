function []=alg2_ep()
%---------configuration-----
addpath('./../../clustering_code/')
addpath('./../../clustering_code/lightweight/algorithm2')
ep = [0.2,0.6,1,2,3,4,5,6];
z_ratio = [1.2,1.4,1.6,1.8,2.0];
samp_ratio = 0.005;
%
ep_len = size(ep,2);
z_len = size(z_ratio,2);
times = 20;
repetition = 10;
cost_avg = zeros(ep_len,z_len); cost_var = zeros(ep_len,z_len);
saveFile = './alg2_ep_results/alg2_ep.mat';
folderPath = './alg2_ep_results';
if ~isfolder(folderPath)
mkdir(folderPath);
end
% looping for ep(e1/e2)(different datasets)
for i = 1:ep_len %enumerate synthetic datasets based on ep
    writeFile = ['./alg2_ep_results/alg2_ep',num2str(ep(i)*10),'.txt'];
    paths = ['./../../datasets/datasets_gen/',num2str(ep(i)*10), 'data.mat'];
    if (exist(writeFile,'file'))
        delete(writeFile);
    end
    diary(writeFile);
    diary on;
    % get data
    X = load(paths); [row, column] = size(X.data);
    data = X.data; k = X.k; e1 = X.e1; e2 = X.e2; eta = 0.1;
    tabulate(X.target);
    fprintf('----KC_alg2_ep %d-dataset -------\n',i);
    
    
    % looping for different z
    for zIdx = 1:z_len
        fprintf('----KC_ALG2_TEST_SYN %d-dataset %f-z -------\n',i,z_ratio(zIdx));
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
            [centers,sampNum,z_prime,timer(j)] = algorithm2(data,k,X.z,...
                'sampNum',S_num,'z_prime',z_prime,'Times',3,'ValdnRatio',0.02);
            cost(j) = Radius(centers,data,X.z);
            if cost(j) < cost_min %update
                best = j;
                cost_min = cost(j);
            end
            fprintf('%d times-- radius=%f Time=%f\n',j,cost(j),timer(j));
        end
        cost_avg(i,zIdx) = mean(cost); cost_var(i,zIdx) = var(cost);
        time_avg(i,zIdx) = mean(timer); time_var(i,zIdx) = var(timer);
    end
    diary off
end
save(saveFile,'cost_avg','cost_var','time_avg','time_var');
end


