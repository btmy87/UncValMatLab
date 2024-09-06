function obj = asinh(x)
%ASINH inverse hyperbolic sin function for UncVal objects
obj = x;
obj.val = asinh(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = 1.0./sqrt(1+x.val.^2).*obj.srcs(k).sens;
end
end

