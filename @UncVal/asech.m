function obj = asech(x)
%ASECH inverse hyperbolic secant function for UncVal objects
obj = x;
obj.val = asech(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = -1.0./x.val./sqrt(1-x.val.^2).*obj.srcs(k).sens;
end
end

