function out = cov(a, b)
% cov calculate covariance between two UncVal objects
% only scalar UncVal's are supported

assert(isscalar(a) && isscalar(b), "UncVal:NotSupported", ...
    "`cov` for UncVal objects only supports scalar inputs");

assert(isa(a, "UncVal") && isa(b, "UncVal"), "UncVal:NotSupported", ...
    "`cov` inputs must both be `UncVal` objects");

c = 0.0;
allkeys = union(a.srcs.keys, b.srcs.keys);
for k = allkeys'
    dadx = 0;
    dbdx = 0;
    dx2 = 0; % pulling from either set is fine
    if isKey(a.srcs, k)
        dadx = a.srcs(k).sens;
        dx2 = a.srcs(k).xvar;
    end
    if isKey(b.srcs, k)
        dbdx = b.srcs(k).sens;
        dx2 =  b.srcs(k).xvar;
    end
    c = c + dadx.*dbdx.*dx2;
end
out = [var(a), c; c, var(b)];
% c = c./length(allkeys);
end

