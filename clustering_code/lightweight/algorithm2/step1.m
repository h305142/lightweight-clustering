% disp('setp1');
if l~=0 && number_free_points>0
    drop=0;
    cou=0;% drop data's index
    for i=1:number_free_points
        for j=1:l
            if norm(free_points(i,2:dim+1)-P(centers(j,1),:))<eta*r
                cou=cou+1;
                drop(cou)=i;
                break;
            end
        end
    end
    if drop~=0 
        free_points(drop,:)=[];
    end
    % disp(free_points);
    number_free_points=size(free_points,1);
    % have drop free points that within distance \eta*r of cluster centers 
    
end

step2;