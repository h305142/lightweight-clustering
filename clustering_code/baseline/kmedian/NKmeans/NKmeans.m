function [centers_best,cost_z] = NKmeans(X,k,z)
z_org=z;
[Y,z,MinDist,MaxDist,p] = sampleCoreset(X,k,z);
[Y_row,Y_col] = size(Y);
lbound = Y_row*power(MinDist, 2);
ubound = Y_row*power(MaxDist, 2);
cost_z = inf;
distMatrix = pdist2(Y,Y);
for rpt=1:1
    l = lbound;
    balls = rand(Y_row,Y_row);
    
    while l <= ubound
        OPT = l;
        Radius = 2*sqrt(OPT/2);
        % find heavy points
        heavypoints = [];
        for i=1:Y_row
            dist_i = distMatrix(i,:);
            idx = dist_i <= Radius;
            count = sum(idx);
            balls(i,:) = idx;
            %disp(count)
            if count >= 2*z*p
             
                heavypoints = [heavypoints;i];
            end
        end
        % discardKZ
        pointsIdx = 1:Y_row;
        balls = logical(balls);
        KZoutliers = zeros(Y_row,1);
        inliersIdx = zeros(Y_row,1);
        for i=1:Y_row
            inBalls_i = pointsIdx(balls(i,:));
            inBalls_heavy = intersect(inBalls_i,heavypoints);
            [heavypoints_num,~]=size(inBalls_heavy);
            if(heavypoints_num==0)
                KZoutliers(i)=1;
            else
                inliersIdx(i)=1;
            end
        end
        inliersIdx = logical(inliersIdx);
        Lloydpointsset = Y(inliersIdx,:);
        [Lloydpointsset_row,~]=size(Lloydpointsset);
        if Lloydpointsset_row <= k
            l = l*2;
            continue;
        end
        [Idx,centers] = kmeans(Lloydpointsset,k);
        
        [cost_cur,~,~] = Sum_dist(centers,X,z_org);
        if cost_cur < cost_z
            cost_z = cost_cur;
            centers_best = centers;
        end
        l = l*2;
    end
    
end



end