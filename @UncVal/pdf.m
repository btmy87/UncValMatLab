function [y, x] = pdf(obj, x)
%PDF Return probability distribution of UncVal object at x
%
% y = pdf(obj, x) returns pdf of UncVal object evaluated at `x`
%
% [y, x] = pdf(obj) returns pdf of UncVal object evaluated along default 
%                   `x` vector


arguments
    obj (1, 1) UncVal;
    x double = [];
end

% get standard deviation
s = std(obj);

if isempty(x)
    x = linspace(-3, 3, 91).*std(obj) + obj.val;
end

z = (x - obj.val)./s;
y = 1.0./(s.*sqrt(2.*pi)).*exp(-0.5.*z.^2);

end

