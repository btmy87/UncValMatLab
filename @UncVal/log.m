function obj = log(x)
% log natural logarithm for UncVal objects
obj = x;
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
obj.val = log(x.val);
for k = obj.srcs.keys'
    % note value already contains the exponential
    obj.srcs(k).sens = obj.srcs(k).sens./x.val;
end
end

