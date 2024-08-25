function obj = times(x, y)
% times multiplies two UncVal items, or an UncVal to a scalar
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% Uncertainty propogation accounting for correlation
% f = x(a)*y(a)
% df/da = x*dy/da + y*dx/da;

% start with the x sensitivities, dx/da terms
srcs = x1.srcs;
for k = srcs.keys'
    srcs(k).sens = y.val.*srcs(k).sens;
end

% then add in y terms and any correlation
for k = y1.srcs.keys'
    xsens = 0.0;
    if isKey(srcs, k)
        % data is present in both sets
        assert(x1.srcs(k).xvar == y1.srcs(k).xvar, ...
            "UncVal:InconsistentVariance", ...
            "Inconssitent variance for id: '%s' %g vs %g", ...
            k, x1.srcs(k).xvar, y1.srcs(k).xvar);

        xsens = srcs(k).sens;
    else
        % data present in y only
        srcs(k) = y1.srcs(k);
    end
    srcs(k).sens = xsens + x1.val.*y1.srcs(k).sens;
end

% create the output object
obj = UncVal.UncValInt(x1.val.*y1.val, srcs);
end