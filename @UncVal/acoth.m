function obj = acoth(x)
%ACOTH inverse hyperbolic cotangent function for UncVal objects
obj = x;
obj.val = acoth(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = 1.0./(1.0-x.val.^2).*obj.srcs(k).sens;
end
end

