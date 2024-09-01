function obj = atan(x)
%ATAN arctangent function for UncVal objects
obj = x;
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
obj.val = atan(x.val);
m = 1.0./(1+x.val.^2);
for k = obj.srcs.keys'
    obj.srcs(k).sens = m.*obj.srcs(k).sens;
end
end

