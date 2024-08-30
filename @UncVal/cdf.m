function [y, x] = cdf(obj, x)
%CDF return cummulative distribution of UncVal object x
%
% y = cdf(obj, x) returns cdf of UncVal object evaluated at `x`
%
% [y, x] = cdf(obj) returns cdf of UncVal object evaluated along default 
%                   `x` vector

arguments
    obj (1, 1) UncVal;
    x double = [];
end

s = std(obj);

if isempty(x)
    x = linspace(-3, 3, 91).*std(obj) + obj.val;
end

z = (x - obj.val)./s;
y = 0.5*(1+erf(z./sqrt(2)));
end

