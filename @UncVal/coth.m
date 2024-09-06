function obj = coth(x)
%COTH hyperbolic cotangent function for UncVal objects
obj = x;
obj.val = coth(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = -csch(x.val).^2.*obj.srcs(k).sens;
end
end

