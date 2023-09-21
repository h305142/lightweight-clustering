function []=median_alg4_otl()
%---------configuration-----
addpath('./../../clustering_code/')
addpath('./../../clustering_code/lightweight/median_algorithm4')
times=20;
otl_set = [0.2,0.6,1,2,4,6,8,10];
samp_ratio = 0.005;
otl_num = size(otl_set,2);
repetition = 4;
ValdnNum = 3000;
cost_avg=zeros(otl_num,1);cost_var=zeros(otl_num,1);
time_avg=zeros(otl_num,1);time_var=zeros(otl_num,1);
saveFile='./median_alg4_otl_results/alg4_otl.mat';
folderPath = './median_alg4_otl_results';
if ~isfolder(folderPath)
mkdir(folderPath);
end
for i=1:otl_num
    writeFile=['./median_alg4_otl_results/alg4_otl',num2str(otl_set(i)),'.txt'];
    paths = ['../../datasets/datasets_gen_otl/k4_otl',num2str(otl_set(i)), '_data.mat'];
    if (exist(writeFile,'file'))
        delete(writeFile);
    end
    diary(writeFile);
    diary on;
    % get data
    X = load(paths);[row, column]=size(X.data);
    data= X.data; k = X.k; e1=X.e1; e2=X.e2; eta=0.1; eta=0.5;delta = 0.9;
    [n_data,~] = size(data);
    tabulate(X.target);
    e1 = X.e1;e2 = X.e2; ksi = 0.2;
    eta_arr = X.eta;   %>¡Ì(e2/e1)
    delta_arr = X.delta;         %<1-¡Ì(e2/e1)
    [~, eta_delta_pairs]=size(eta_arr);
    if(eta_delta_pairs>0)
        fprintf('eta :  ');disp(eta_arr); fprintf('delta:  ');disp(delta_arr);
        eta=eta_arr(1);delta=delta_arr(1);
    end
    
    % repeat to get AVGs and VARs
    cost_min=inf;
    cost=zeros(1,times);timer=zeros(1,times);
    ValdnRatio = ValdnNum/n_data; %ValdnRatio=0.3;
    for j = 1:times
        S_num=round(n_data*samp_ratio);
        s(1) = 3*k/(delta*delta*e1)*log(2*k/eta);
        s(2) = k/(2*ksi*ksi*e1*(1-delta))*log(2*k/eta);%set beta=1,2,3,4
        S_num = round(max(s));
        z_prime = round(2*e2/k*S_num);
        [centers,sampNum,z_prime,timer(j)]=algorithm4(data,k,X.z,...
            'sampNum',S_num,'z_prime',z_prime,'Times',repetition,'ValdnRatio',ValdnRatio);
        cost(j) = Sum_dist(centers,data,X.z);
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


