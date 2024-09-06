function obj = acosh(x)
%ACOSH inverse hyperbolic cosine function for UncVal objects
obj = x;
obj.val = acosh(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = 1.0./sqrt(x.val.^2-1).*obj.srcs(k).sens;
end
end

