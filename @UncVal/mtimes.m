function obj = mtimes(x, y)
% mtimes matrix multiplication for UncVal objects

% make sure we have compatible inputs
assert(ismatrix(x), "First input to mtimes must be a matrix.")
assert(ismatrix(y), "Second input to mtimes must be a matrix.")

sx = size(x);
sy = size(y);
assert(sx(2) == sy(1), "Incompatible sizes for array multiplication.");

% Initialize an UncVal
nrow = sx(1);
ncol = sy(2);

x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);
% Then we'll go element by element
obj = zeros(nrow, ncol).*x1(1, 1); % this leaves an extra constant in the srcs dictionary, but it works
for i = 1:nrow
    for j = 1:ncol
        obj(i, j) = sum(x1(i, :).*y1(:, j)');
    end
end

% % for now, we'll just implement for scalars
% assert(isscalar(x) || isscalar(y), "UncVal:NotSupported", ...
%     "Only supported for scalars at this time");
% obj = x.*y;

end