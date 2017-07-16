[a, b] = getP(5,5,5,7);
div=length(b)/5;
count=0;
for i=1:div
    for j=1:div
        count=count+1;
        c(i,j) = b(count);
    end
end