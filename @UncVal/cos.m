function obj = cos(x)
%COS cos function for UncVal objects
obj = x;
obj.val = cos(x.val);
for k = obj.srcs.keys'
    % note value already contains the exponential
    obj.srcs(k).sens = -sin(x.val).*obj.srcs(k).sens;
end
end

