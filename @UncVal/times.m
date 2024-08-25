function obj = times(x, y)
% times multiplies two UncVal items, or an UncVal to a scalar
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% Uncertainty propogation accounting for correlation
% f = x(a)*y(a)
% df/da = x*dy/da + y*dx/da;

srcs = UncVal.propagate(x1.srcs, y1.srcs, y1.val, x1.val);

% create the output object
obj = UncVal.UncValInt(x1.val.*y1.val, srcs);
end