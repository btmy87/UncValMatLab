function obj = mrdivide(x, y)
%MRDIVIDE mrdivide for UncVal objects
% only supports scalars, really intended for when the user forgets the .

assert(isscalar(x) && isscalar(y), "UncVal:NotSupported", ...
    "Matrix division is not supported for UncVal objects.")

obj = x./y; % forward to element-wise division.

end

