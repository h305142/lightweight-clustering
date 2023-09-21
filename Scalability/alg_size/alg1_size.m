function []=alg1_size()
%---------configuration-----
addpath('./../../clustering_code/')
addpath('./../../clustering_code/lightweight/algorithm1')
size_set = [3,4,5];

size_num = size(size_set,2);
RPT = 20;
Times = 3;
cost_avg=zeros(size_num,1);cost_var=zeros(size_num,1);
time_avg=zeros(size_num,1);time_var=zeros(size_num,1);
purity_avg=zeros(size_num,1);purity_var=zeros(size_num,1);
pre_avg=zeros(size_num,1);pre_var=zeros(size_num,1);
saveFile='./alg1_size_results/alg1_size.mat';
folderPath = './alg1_size_results';
if ~isfolder(folderPath)
mkdir(folderPath);
end
for i = 1:size_num
    writeFile=['./alg1_size_results/alg1_size',num2str(size_set(i)),'.txt'];
    paths = ['../../datasets/datasets_gen_size/n',num2str(size_set(i)), '_data.mat'];
    if (exist(writeFile,'file'))
        delete(writeFile);
    end
    diary(writeFile);
    diary on;
    % get data
    X = load(paths);[row, column]=size(X.data);
    data= X.data; k = X.k; e1=X.e1; e2=X.e2; eta=0.001;
    [n_data,~] = size(data);
    tabulate(X.target);
    % repeat to get AVGs and VARs
    cost_min=inf;
    cost=zeros(1,RPT);timer=zeros(1,RPT);purity=zeros(1,RPT);pre=zeros(1,RPT);

    ValdnNum = 2000;
    ValdnRatio = ValdnNum/n_data;
    if ValdnRatio >= 1
        ValdnRatio = 1;
    end
    S_num = 1000;
    k_prime = round(2*e2/k*S_num);
    
%%
    for j = 1:RPT
        [centers,sampNum,k_prime,timer(j)]=algorithm1(data,k,X.z,...
            'sampNum',S_num,'k_prime',k_prime,'Times',Times,'ValdnRatio',ValdnRatio);
        [cost(j), pred_label, pred_otlIdx] = Radius(centers,data,X.z);
        true_otlIdx = find(X.target==0); true_label = X.target;
        [purity(j), pre(j)] = kc_eval(true_label,true_otlIdx,pred_label,pred_otlIdx);
        if cost(j)<cost_min %update
            best=j;
            cost_min = cost(j);
        end
        fprintf('%d RPT-- radius=%f Time=%f pre=%f purity=%f\n',j,cost(j),timer(j),pre(j),purity(j));
    end
    cost_avg(i)=mean(cost); cost_var(i)=var(cost);
    time_avg(i)=mean(timer); time_var(i)=var(timer);
    purity_avg(i)=mean(purity); purity_var(i)=var(purity);
    pre_avg(i)=mean(pre); pre_var(i)=var(pre);
    diary off
end
save(saveFile,'cost_avg','cost_var','time_avg','time_var','purity_avg','purity_var','pre_avg','pre_var');
end

