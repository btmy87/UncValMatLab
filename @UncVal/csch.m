function obj = csch(x)
%CSCH hyperbolic cosecant function for UncVal objects
obj = x;
obj.val = csch(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = -csch(x.val).*coth(x.val).*obj.srcs(k).sens;
end
end

