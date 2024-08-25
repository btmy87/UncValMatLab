function out = unc(obj)
%unc returns uncertainty from UncVal
out = sqrt(var(obj));
end