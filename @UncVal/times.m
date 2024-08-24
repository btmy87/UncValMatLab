function obj = times(x, y)
% times multiplies two UncVal items, or an UncVal to a scalar
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% calculate square of derivatives for uncertainty propagation
dfdxsq = y1.val.^2;
dfdysq = x1.val.^2;

% start with the uncertainty from x, and modify
srcs = x1.srcs;
for k = srcs.keys
    srcs(k) = dfdxsq.*srcs(k);
end

% then add in y terms
for k = y1.srcs.keys
    xvar = 0.0;
    if isKey(srcs, k)
        xvar = srcs(k);
    end
    srcs(k) = xvar + dfdysq.*y1.srcs(k);
end

% create the output object
obj = UncVal.UncValInt(x1.val.*y1.val, srcs);
end