function out = unc(obj, p)
%unc returns uncertainty from UncVal
%
% out = unc(obj) returns the 1-sigma uncertainty for the UncVal object
%
% out = unc(obj, p) returns the 2-sided uncertainty (+/-) for the given
% probability.  `p` must be in interval (0, 1)

if nargin < 2
    out = sqrt(var(obj));
else
    % get the 1-sided probability
    p1 = 0.5*(1.0+p);
    out = quantile(obj, p1) - obj.val;
end
end