function obj = rdivide(x, y)
% rdivide divides two UncVal items, or an UncVal to a scalar
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% f = x(a)/y(a)
% df/da = (y*dx/da - x*dy/da)/y^2
% df/da = (1/y)*dx/da - (x/y^2)*dy/da
%         -----         -------
%           Cx             Cy

% first a couple constants
Cx = (1.0./y1.val);
Cy = (-x1.val./y1.val.^2);

srcs = UncVal.propagate(x1.srcs, y1.srcs, Cx, Cy);

% create the output object
obj = UncVal.UncValInt(x1.val./y1.val, srcs);
end