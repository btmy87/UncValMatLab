function out = iqr(obj)
%IQR Interquartile range of UncVal object
out = quantile(obj, 0.75) - quantile(obj, 0.25);
end

