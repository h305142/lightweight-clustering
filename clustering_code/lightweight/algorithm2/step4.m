% disp('setp4');
if l==0
    step1;
else
centers(:,z+3)=1;
new_l=0;
while sum(centers(:,z+3))>0
    for num=1:l
        if centers(num,z+3)==1
            new_l=new_l+1;
            keep_centers(new_l)=num;
            centers(num,z+3)=0;
            break;
        end
    end
    for j=1:l
        if centers(j,z+3)==1 && is_conflict(keep_centers(new_l),j,centers,P,r,alpha,z)
            centers(j,z+3)=0;
        end
    end
end
centers=centers(keep_centers,:);
l=new_l;
centers(:,z+3)=[];
step1;
end
function conflict=is_conflict(ct1,ct2,centers,P,r,alpha,z)
for i=1:z+1
    for j=1:z+1
        if norm(P(centers(ct1,i+1),:)-P(centers(ct2,j+1),:))<=2*alpha*r
            conflict=true;
            return;
        end
    end
end
conflict=false;

end