function obj = times(x, y)
% times multiplies two UncVal items, or an UncVal to a scalar
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% Uncertainty propogation accounting for correlation
% s^2 ~ (xy)^2*( (sx/x)^2 + (sy/y)^2 + 2sxy/xy)
% s^2 ~ y^2*sx^2 + x^2*sy^2 + 2*x*y*sx*sy
% start with the uncertainty from x
srcs = x1.srcs;
for k = srcs.keys'
    srcs{k} = y1.val.^2.*srcs{k};
end

% then add in y terms and any correlation
for k = y1.srcs.keys'
    if isKey(srcs, k)
        srcs{k} = srcs{k} + x1.val.^2.*y1.srcs{k} ...
                + 2.0.*x1.val.*y1.val.*sqrt(x1.srcs{k}.*y1.srcs{k});
    else
        srcs{k} = x1.val.^2.*y1.srcs{k};
    end
end

% create the output object
obj = UncVal.UncValInt(x1.val.*y1.val, srcs);
end