function obj = sin(x)
%SIN sin function for UncVal objects
obj = x;
obj.val = sin(x.val);
for k = obj.srcs.keys'
    obj.srcs(k).sens = cos(x.val).*obj.srcs(k).sens;
end
end

