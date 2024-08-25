function obj = plus(x, y)
% plus adds two UncVal items, or an UncVal to a scalar
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% Let f = x(a) + y(a)
% df/da = dx/da + dy/da

srcs = UncVal.propagate(x1.srcs, y1.srcs, 1.0, 1.0);

% create the output object
obj = UncVal.UncValInt(x1.val + y1.val, srcs);
end