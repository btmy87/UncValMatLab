function obj = cosh(x)
%COSH hyperbolic cosine function for UncVal objects
obj = x;
obj.val = cosh(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = sinh(x.val).*obj.srcs(k).sens;
end
end

