function obj = power(x, y)
% power raises one UncVal to the power of another
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% it's helpful to calculate the output value first
f = x1.val.^y1.val;

% start with the uncertainty from x, and modify
srcs = x1.srcs;
for k = srcs.keys
    srcs(k) = (f.*y1.val./x1.val).^2.*srcs(k);
end

% then add in y terms
for k = y1.srcs.keys
    if isKey(srcs, k)
        % data is present in both sets, and perfectly correlated
        vx = x1.srcs(k);
        vy = y1.srcs(k);
        srcs(k) = srcs(k) ...
                + (f.*log(x1.val)).^2.*vy ...
                + f.*f.*2.0.*y1.val./x1.val.*log(x1.val).*sqrt(vx.*vy);
    else
        % data only in y set
        srcs(k) = f.*f.*log(x1.val).^2.*y1.srcs(k);
    end
end

% create the output object
obj = UncVal.UncValInt(f, srcs);
end