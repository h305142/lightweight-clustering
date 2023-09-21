% disp('setp3');
if l<=k && number_free_points<=(k-l)*z+z
    [new_centers,cover_number]=RobustCluster(free_points(:,2:dim+1),eta*r,k-l);
    if cover_number>=number_free_points-z
        breakout=1;
        if(size(centers,1) == 0)
            all_centers = new_centers;
        else
            all_centers = [P(centers(:,1),:);new_centers];
        end
    else
        r=r*alpha;
        % disp(r);
        step4;
    end
else
    r=r*alpha;
    %disp(r);
    step4;
end

function [centers,cover_number]=RobustCluster(data,r,k)
if k==0||size(data,1) == 0
    cover_number=0;
    centers = [];
    return;
end
% Given k and r
ball_ampli_coeff=3;

distance_matrix=dist(data,data');

[n,d] = size(data);
coverd = zeros(1,n);
centers = zeros(k,d);
% k1=k; 
G = distance_matrix<=r;
E = distance_matrix<=ball_ampli_coeff*r;
for i = 1:k
    [r,heaviest_index] = max(sum(G,2));
    coverd(E(heaviest_index,:)) = 1;
    if r == 0
        break;
    end
    centers(i,:) = data(heaviest_index,:);
    G(:,E(heaviest_index,:)) = 0; G(E(heaviest_index,:),:) = 0;
    E(:,E(heaviest_index,:)) = 0; E(E(heaviest_index,:),:) = 0;
end

cover_number= sum(coverd);

end