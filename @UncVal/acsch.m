function obj = acsch(x)
%ACSCH inverse hyperbolic cosecant function for UncVal objects
obj = x;
obj.val = acsch(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = -1.0./abs(x.val)./sqrt(1+x.val.^2).*obj.srcs(k).sens;
end
end

