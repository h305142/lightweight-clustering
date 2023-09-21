%-----Control Part-------
function [r,all_centers] = streaming(P,k, z)
[number_of_data,dim] = size(P);
% P = P(randperm(number_of_data),:);
amp=3;% you can change this if 3 is not suitable
r=ann(P(1:k+z+1,:))/amp;
r_initial=r;
alpha=4;beta=8;eta=16;
l=0;
free_points=[];
centers = [];
% centers :column[index in original data,z+1 support points index
% in original data]
% free_points :[index in orgnl data, coordinate]
for part=0:ceil(number_of_data/(k*z))-1
    % fprintf('new batch:%d\n',part+1);
    if k*z*(part+1)<=number_of_data
        left=k*z*part+1;
        right=k*z*(part+1);
    else
        left=k*z*part+1;
        right=number_of_data;
    end
    breakout=0;
    free_points=[free_points;[(left:right)' P(left:right,:)]];
    % disp(free_points);
    number_free_points=size(free_points,1);
    step1;
end
r=eta*r;
end
function r=ann(A)
r = min(pdist(A));
if r<0.01
    r=0.01;
end
end