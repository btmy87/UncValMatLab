function obj = deg2rad(obj)
% deg2rad convert radians to degrees
c = pi./180.0;
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
obj.val = c.*obj.val;
for k = obj.srcs.keys'
    obj.srcs(k).sens = c.*obj.srcs(k).sens;
end
end
