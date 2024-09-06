function obj = acsc(x)
%ACSC inverse cosecant function for UncVal objects
obj = x;
obj.val = acsc(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = -1.0./abs(x.val)./sqrt(x.val.^2 - 1.0).*obj.srcs(k).sens;
end
end

