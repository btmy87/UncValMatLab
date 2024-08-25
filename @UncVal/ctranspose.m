function obj = ctranspose(obj)
%CTRANSPOSE ctranspose UncVal
obj.val = obj.val';
for k = obj.srcs.keys'
    obj.srcs(k).xvar = obj.srcs(k).xvar';
    obj.srcs(k).sens = obj.srcs(k).sens';
end

end

