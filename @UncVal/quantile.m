function q = quantile(obj, p)
%QUANTILE Returns the quantile of UncVal object at the given probability
% this is the inverse of the CDF function
%
% q = quantile(obj, p) returns the quantile at a given probability level
%                      p must be in interval [0, 1]
%
% q = quantile(obj, n) returns `n` evenly spaced quantile levels for n > 1

if isscalar(p) && p > 1
    % user wants evenly spaced levels
    n = p;
    p = (1:n)./(n+1);
end

q = obj.val + std(obj).*sqrt(2).*erfinv(2.*p-1);

end

