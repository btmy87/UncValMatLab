function obj = log10(x)
% log10, base-10 logarithm for UncVal objects
obj = x;
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;
obj.val = log10(x.val);
c = log(10.0);
for k = obj.srcs.keys'
    % note value already contains the exponential
    obj.srcs(k).sens = obj.srcs(k).sens./(x.val.*c);
end
end

