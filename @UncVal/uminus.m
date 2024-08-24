function obj = uminus(x)
% uminus uninary minus for UncVal object
obj = x;
obj.val = -obj.val;
end