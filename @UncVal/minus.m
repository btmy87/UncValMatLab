function obj = minus(x, y)
% minus subtracts two UncVal items, or an UncVal to a scalar
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% start with the uncertainty from x, and modify
srcs = x1.srcs;

% then add in y terms
for k = y1.srcs.keys'
    if isKey(srcs, k)
        % data is present in both sets
        % s^2 = sx^2 + sy^2 + 2*sxy
        % since they're perfectly correlated, sxy = sx*sy
        vx = x1.srcs{k};
        vy = y1.srcs{k};
        srcs{k} = vx + vy - 2.0.*sqrt(vx.*vy);
    else
        % data only in y set
        srcs{k} = y1.srcs{k};
    end
end

obj = UncVal.UncValInt(x1.val - y1.val, srcs);
end