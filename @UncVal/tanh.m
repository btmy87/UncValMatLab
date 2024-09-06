function obj = tanh(x)
%TANH hyperbolic tangent function for UncVal objects
obj = x;
obj.val = tanh(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = sech(x.val).^2.*obj.srcs(k).sens;
end
end

