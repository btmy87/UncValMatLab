function obj = acot(x)
%ACOT inverse cotangent function for UncVal objects
obj = x;
obj.val = acot(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = -1.0./(1.0+x.val.^2).*obj.srcs(k).sens;
end
end

