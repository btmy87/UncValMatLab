function obj = tan(x)
%TAN tan function for UncVal objects
obj = x;
obj.val = tan(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = (1.0+obj.val.^2).*obj.srcs(k).sens;
end
end

