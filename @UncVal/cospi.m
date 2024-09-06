function obj = cospi(x)
%COSPI cos function for UncVal objects
obj = x;
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
obj.val = cospi(x.val);
for k = obj.srcs.keys'
    obj.srcs(k).sens = -pi.*sinpi(x.val).*obj.srcs(k).sens;
end
end

