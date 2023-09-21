function []=CHARIKAR_size()
%---------configuration-----
addpath('./../../../clustering_code/')
addpath('./../../../clustering_code/baseline/kcenter/CHARIKAR')
size_set = [3,4,5];

size_num = size(size_set,2);
RPT = 20; %20
cost_avg=zeros(size_num,1);cost_var=zeros(size_num,1);
time_avg=zeros(size_num,1);time_var=zeros(size_num,1);
purity_avg=zeros(size_num,1);purity_var=zeros(size_num,1);
pre_avg=zeros(size_num,1);pre_var=zeros(size_num,1);
saveFile='./results/CHARIKAR.mat';
folderPath = './results';
if ~isfolder(folderPath)
mkdir(folderPath);
end
for i=1:size_num
    writeFile=['./results/CHARIKAR_size',num2str(size_set(i)),'.txt'];
    paths = ['./../../../datasets/datasets_gen_size/n',num2str(size_set(i)), '_data.mat'];
    if (exist(writeFile,'file'))
        delete(writeFile);
    end
    diary(writeFile);
    diary on;
    % get data
    X = load(paths);[row, column]=size(X.data);
    data= X.data; k = X.k;
    tabulate(X.target);
    % repeat to get AVGs and VARs
    cost_min=inf;
    cost=zeros(1,RPT);timer=zeros(1,RPT);purity=zeros(1,RPT);pre=zeros(1,RPT);
    for j = 1:RPT
        %
        [centers,timer(j)]=CHARIKAR(X.data,X.k,X.z);
        %
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
end
save(saveFile,'cost_avg','cost_var','time_avg','time_var','purity_avg','purity_var','pre_avg','pre_var');
end

