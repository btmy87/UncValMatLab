function obj = cos(x)
%COS cos function for UncVal objects
obj = x;
obj.id = UncVal.calcId;
obj.val = cos(x.val);
for k = obj.srcs.keys'
    obj.srcs(k).sens = -sin(x.val).*obj.srcs(k).sens;
end
end

