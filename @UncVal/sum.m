function obj = sum(x, dim)
%SUM Sum of UncVal array
% similar to regular sum command
% does not support arrays with more than 2 dimensions
% does not support vecdim, outtype, or nanflag
% Careful using this for vectors with a single "id".  Not sure it's going
% to do what you want.


arguments
    x UncVal
    dim (1, 1) = 1
end

assert(ndims(x) <= 2, "UncVal:NotSupported", ...
    "UncVal does not support sums for arrays with more than 2 dimensions.");


if isvector(x) || string(dim) == "all"
    obj = x(1);
    for i = 2:numel(x)
        obj = obj + x(i);
    end
elseif dim == 1
    % collapse the first dimension
    obj = x(1, :);
    for i = 2:size(x, 1)
        obj = obj + x(i, :);
    end
elseif dim == 2
    obj = x(:, 1);
    for i = 2:size(x, 2)
        obj = obj + x(:, i);
    end
else
    error("UncVal:InvalidDimension", "Invalid dimension for sum.");
end

end

