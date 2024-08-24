function out = unc(obj)
%unc returns uncertainty from UncVal
out = sqrt(obj.xvar);
end