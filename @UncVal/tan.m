function obj = tan(x)
%TAN tan function for UncVal objects
obj = x;
obj.val = tan(x.val);
for k = obj.srcs.keys'
    % note value already contains the exponential
    obj.srcs(k).sens = (1.0+obj.val.^2).*obj.srcs(k).sens;
end
end

