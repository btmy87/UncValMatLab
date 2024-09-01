function obj = exp(obj)
% exp exponential for UncVal objects
obj.val = exp(obj.val);
obj.id = UncVal.calcId;
for k = obj.srcs.keys'
    % note value already contains the exponential
    obj.srcs(k).sens = obj.val.*obj.srcs(k).sens;
end
end

