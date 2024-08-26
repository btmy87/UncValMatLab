function obj = cot(x)
% cot cotangent function for unc vals
obj = x;
obj.val = cot(x.val);
for k = obj.srcs.keys'
    obj.srcs(k).sens = -csc(x.val).*csc(x.val).*obj.srcs(k).sens;
end

end

