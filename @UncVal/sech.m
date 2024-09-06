function obj = sech(x)
%SECH hyperbolic secant function for UncVal objects
obj = x;
obj.val = sech(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = -sech(x.val).*tanh(x.val).*obj.srcs(k).sens;
end
end

