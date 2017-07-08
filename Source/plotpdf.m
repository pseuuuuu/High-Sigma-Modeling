function [] = plotpdf(varname,binwidth,lowerbound, uppperbound,scale)
hold on;
% resolution 
b=10;
select = varname(find(varname >= lowerbound & varname <= uppperbound));

if(binwidth == 0)
    binwidth = (max(select)-min(select))/b;
else
    b = ceil((max(select)-min(select))/binwidth);
end
[n,bin]= hist(select,b);

bar(bin,n/binwidth*scale);

end