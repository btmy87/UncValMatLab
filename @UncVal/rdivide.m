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

% start with the uncertainty from x
srcs = x1.srcs;
for k = srcs.keys'
    srcs(k).sens = Cx.*srcs(k).sens;
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
    srcs(k).sens = xsens + Cy.*y1.srcs(k).sens;
end

% create the output object
obj = UncVal.UncValInt(x1.val./y1.val, srcs);
end