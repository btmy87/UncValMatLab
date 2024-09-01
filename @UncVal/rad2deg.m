function obj = rad2deg(obj)
% rad2deg convert radians to degrees
c = 180.0./pi;
obj.val = c.*obj.val;
obj.id = UncVal.calcId;
for k = obj.srcs.keys'
    obj.srcs(k).sens = c.*obj.srcs(k).sens;
end
end

