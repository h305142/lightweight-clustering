function index=BinarySearch(a,value,len)
    r=len;
    l=1;
    
    while l<r && a(floor((l+r)/2)) ~= value
        if a(floor((l+r)/2))>value
            r=floor((l+r)/2)-1;
        else
            l=floor((l+r)/2)+1;
        end
    end
       
    if l>=r
        if l>r 
            index=0;
        elseif a(l)==value
            index=l;
        else 
            index=0;
        end
    else
        index=floor((l+r)/2);
    end
    
end
