function obj = sec(x)
% sec secant function for unc vals
obj = x;
obj.val = sec(x.val);
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
for k = obj.srcs.keys'
    obj.srcs(k).sens = sec(x.val).*tan(x.val).*obj.srcs(k).sens;
end

end

