# light clustering

This code replicates the experiments of our paper. 

> Is Simple Uniform Sampling Effective for Center-Based Clustering with Outliers: When and Why?

### 1, Platform: 

CPU: 2.40GHz Intel(R) Xeon(R) E5-2680

Ubuntu: 18.04

MATLAB: R2020b

### 2, Files & Folders

We put the full dataset in [Google Drive](https://drive.google.com/drive/folders/1DT7369vc7idCEDffv1MDU3kZ5XuarUhe?usp=sharing) due to the large size. 

We also provide a small toy dataset in the directiry 'datasets/datasets_gen'. So you can directly run the code in directory **'.\BasicTest\alg1234'** and **.\BasicTest\Baseline'** without downloading the full dataset.

```
├─BasicTest								
│  ├─alg1234			 % test for our methods
│  └─Baseline			 % test for baselines
│      ├─kcenter
│      ├─kmeans
│      └─kmedian
│  
├─clustering_code
│  ├─baseline      % baselines 
│  │  ├─kcenter
│  │  ├─kmeans
│  │  └─kmedian
│  │
│  └─lightweight		% The implementation of our algorithms 
│      ├─algorithm1
│      ├─algorithm2
│      ├─algorithm3
│      ├─algorithm4
│      ├─median_algorithm3
│      └─median_algorithm4
│  
├─datasets					% datasets, please download from the link mentioned above.
│  ├─datasets_gen
│  ├─datasets_gen_k
│  ├─datasets_gen_otl
│  └─datasets_gen_size
│  
├─SampingRatio			% test by varying the sample size
│  └─alg_samp								
│  
├─Scalability				% test by varying the data size
│  ├─alg_size 							
│  └─Baseline	
│  
├─VaryK						  % test by varying the k
│  ├─alg_k
│  └─Baseline
│  
├─VaryOtl						% test by varying the outliers ratio
│  ├─alg_otl
│  └─Baseline
│  
└─Vary_ep_z				  % test by varying the eps_1/eps_2 and \hat{z}/\tilde{z}
    └─alg24
```



### 3, Interface & Usage

#### 3.1 algorithm1 & algorithm3 

Located at './clustering_code/lightweight/algorithm1' and './clustering_code/lightweight/algorithm3'. 

```
[centers,sampNum,k_prime,time] = algorithm1(data,k,z,varargin)
[centers,sampNum,k_prime,time] = algorithm3(data,k,z,varargin)
```

INPUT: 

**data** is n*d matrix, including n vertices with d attributes; **k** is the number of clusters; **z** is the number of outliers; 

**varargin** configure other parameters: eta, delta, ksi, e1, e2, k_prime represent the parameters η, δ, ξ, ε1, ε2, k' respectively, which will affect the value of sampling size, k_prime. 

We can also set some parameters directly:  sampNum represents sampling size, k_prime represents the extra centers, Times represents times of repetition, ValdnRatio represents Verification set proportion. 

OUTPUT: 

**centers** are the clustering centers; **sampNum** is the sampling size; **k_prime** is the k'; **time** is the running time. 

EXAMPLE: 

```
[centers,sampNum,k_prime,timer(j)] = algorithm1(data,k,z,'sampNum',S_num,'k_prime',k_prime,'Times',5,'ValdnRatio',0.02);
```



#### 3.2 algorithm2 & algorithm4

Located at './clustering_code/lightweight/algorithm2' and './clustering_code/lightweight/algorithm4'. 

```
[centers,sampNum,z_prime,time] = algorithm2(data,k,z,varargin)
[centers,sampNum,z_prime,time] = algorithm4(data,k,z,varargin)
```

INPUT: 

almost the same with algorithm1&algorithm3, except that we set **z_prime**  rather than **k_prime** in varargin. **z_prime**  represents the parameter z'. 

OUTPUT: 

almost the same with algorithm1&algorithm3, except that the algorithm outputs **z_prime**  rather than **k_prime**.

EXAMPLE: 

```
[centers,sampNum,z_prime,timer(j)] = algorithm2(data,k,X.z,'sampNum',S_num,'z_prime',z_prime,'Times',5,'ValdnRatio',0.2);
```
