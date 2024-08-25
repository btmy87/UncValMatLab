function xvar = var(obj)
%VAR returns variance from UncVal

xvar = zeros(size(obj.val));
for src = obj.srcs.values'
    xvar = xvar + src.sens.^2.*src.xvar;
end
end

