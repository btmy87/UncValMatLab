function y = cdf(obj, x)
%CDF return cummulative distribution function evaluated at x

s = std(obj);
z = (x - obj.val)./s;
y = 0.5*(1+erf(z./sqrt(2)));
end

