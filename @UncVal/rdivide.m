function obj = rdivide(x, y)
% rdivide divides two UncVal items, or an UncVal to a scalar
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% Uncertainty propogation accounting for correlation

f = x1.val./y1.val;

% start with the uncertainty from x
srcs = x1.srcs;
for k = srcs.keys'
    srcs{k} = 1.0./y1.val.^2.*srcs{k};
end

% then add in y terms and any correlation
for k = y1.srcs.keys'
    if isKey(srcs, k)
        srcs{k} = srcs{k} + (f./y1.val).^2.*y1.srcs{k} ...
                - 2.0.*f.^2./(x1.val.*y1.val).*sqrt(x1.srcs{k}.*y1.srcs{k});
    else
        srcs{k} = (f./y1.val).^2.*y1.srcs{k};
    end
end

% create the output object
obj = UncVal.UncValInt(f, srcs);
end