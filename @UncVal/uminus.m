function obj = uminus(x)
% uminus uninary minus for UncVal object
obj = x;
obj.val = -obj.val;
obj.id = UncVal.calcId;
for k = obj.srcs.keys'
    obj.srcs(k).sens = -obj.srcs(k).sens;
end
end