function [Q,weight]=summary(X,l,k)
%X:input data
%l: outliers number
%Q: output summary data
%weight: weight of Q
alpha=2;
beta=0.45;

[num,dim]=size(X);

k=max(ceil(log2(num)),k);
I=(1:num)';

Q=[];
while size(I,1)>8*l
    S_index=randperm(size(I,1),alpha*k);
    S=I(S_index);
    [distance]=min(pdist2(X(I,:),X(S,:),'euclidean'),[],2);
    distance_sorted=sort(distance);
    rho=distance_sorted(ceil(beta*size(I,1)));
    C=I(distance<=rho);
    [dist,nct]=min(pdist2(X(C,:),X(S,:),'euclidean'),[],2);
    for i=1:size(S,1)
        S(i,2)=sum(nct==i);
    end
    
    I=setdiff(I,C);
    Q=[Q;S];
    
end

I(:,2)=1;
Q=[Q;I];

weight=Q(:,2);
Q=X(Q(:,1),:);

end