function obj = sinh(x)
%SINH hyperbolic sine function for UncVal objects
obj = x;
obj.val = sinh(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = cosh(x.val).*obj.srcs(k).sens;
end
end

