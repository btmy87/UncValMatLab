function obj = transpose(obj)
%TRANSPOSE transpose UncVal
obj.val = obj.val.';
for k = obj.srcs.keys'
    obj.srcs(k).xvar = obj.srcs(k).xvar.';
    obj.srcs(k).sens = obj.srcs(k).sens.';
end

end

