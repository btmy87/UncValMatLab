function out = string(obj)
% string convert uncval to string

if isscalar(obj)
    out = sprintf("UncVal (id=%s): %g ± %g (2-sigma)", ...
        obj.id, obj.val, 2.0.*obj.unc());
else
    strSz = strjoin(string(size(obj)), "x");
    out = sprintf("UncVal (id=%s): [%s %s]", ...
        obj.id, strSz, class(obj.val));
end
end

