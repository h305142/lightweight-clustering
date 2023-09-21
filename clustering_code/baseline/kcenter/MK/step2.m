% disp('setp2');
[new_center,new_center_supp_points]=add_cluster(free_points,dim,beta,r,z);
if new_center~=0
    centers(l+1,:)=[new_center,new_center_supp_points];
    % disp(centers);
    l=l+1;
    step1;
else
    step3;
end


function [new_center,new_center_supp_points]=add_cluster(free_points,dim,beta,r,z)
% find some free point that has >=z+1 free points within \beta*r    
    number_free_points=size(free_points,1);
    
    if number_free_points==0
        new_center=0;
        new_center_supp_points=[];
        return; 
    end
    
    for i=1:number_free_points
        cou=0;
%         for j=1:number_free_points
%             if norm(free_points(i,2:dim+1)-free_points(j,2:dim+1))<=beta*r
%                 cou=cou+1;
%                 supp_points(i,cou)=free_points(j,1);
%             end
%         end
        distance=dist(free_points(i,2:dim+1),free_points(:,2:dim+1)');
        for j=1:number_free_points
            if distance(j)<=beta*r
                cou=cou+1;
                supp_points(i,cou)=free_points(j,1);
            end
        end
        
        if cou>=z+1
            new_center=free_points(i,1);
            new_center_supp_points=supp_points(i,1:z+1);
            return;
        else
            new_center=0;
            new_center_supp_points=[];
        end
        
    end
end
