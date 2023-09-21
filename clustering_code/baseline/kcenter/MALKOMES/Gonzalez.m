function [centers, weight] = Gonzalez(data,k)  
    [n,d] = size(data);
    centers = zeros(k,d);
    ini_center = randi(n);
    centers(1,:) = data(ini_center,:);
    D = zeros(n,k);
    if k>n
        fprintf('k is too big !!\n');
        return;
    end
    for i = 1:k-1
        D(:,i) = next_center(data,centers(i,:));   %the next cetner
        [~,index] = max(min(D(:,1:i),[],2));      
        centers(i+1,:) = data(index,:);
        data(index,:) = [];
        D(index,:) = [];
        if rem(i,500)==0
             fprintf('Gonzalez i=%d---------\n',i);
        end
    end
    dist = pdist2(data,centers);  weight = zeros(k, 1);
    [~,I] = min(dist, [], 2);
    for i = 1:k
        weight(i) = sum(I==i);
    end
    fprintf('Gonzalez finished---------\n');
end

function [D] = next_center(data,centers)
    D = pdist2(data,centers); 
end