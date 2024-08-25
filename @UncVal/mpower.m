function obj = mpower(x, y)
%MPOWER for UncVal objects
% only supports scalars, really intended for when the user forgets the .

assert(isscalar(x) && isscalar(y), "UncVal:NotSupported", ...
    "Matrix power is not supported for UncVal objects.")

obj = x.^y; % forward to element-wise

end

