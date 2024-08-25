function obj = plus(x, y)
% plus adds two UncVal items, or an UncVal to a scalar
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% Let f = x(a) + y(a)
% df/da = dx/da + dy/da

% start with the uncertainty from x, and modify
srcs = x1.srcs;

% then add in y terms
for k = y1.srcs.keys'
    if isKey(srcs, k)
        % data is present in both sets
        assert(x1.srcs(k).xvar == y1.srcs(k).xvar, ...
            "UncVal:InconsistentVariance", ...
            "Inconssitent variance for id: '%s' %g vs %g", ...
            k, x1.srcs(k).xvar, y1.srcs(k).xvar);
        srcs(k).sens = srcs(k).sens + y1.srcs(k).sens;
    else
        % data only in y set, we can copy both variance and sensitivity
        srcs(k) = y1.srcs(k);
    end
end

% create the output object
obj = UncVal.UncValInt(x1.val + y1.val, srcs);
end