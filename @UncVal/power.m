function obj = power(x, y)
% power raises one UncVal to the power of another
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);



% f(a) = x(a).^y(a)
% df/da = (y*x^(y-1))*dx/da + (x^y)*ln(x)*dy/dx
%         -----------         -----------
%            Cx                   Cy

f = x1.val.^y1.val;
Cx = y1.val.*x1.val.^(y1.val-1.0);
Cy = f.*log(x1.val);

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
obj = UncVal.UncValInt(f, srcs);
end