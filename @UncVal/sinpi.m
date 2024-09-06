function obj = sinpi(x)
%SINPI sin function for UncVal objects
obj = x;
obj.val = sinpi(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = pi.*cospi(x.val).*obj.srcs(k).sens;
end
end

