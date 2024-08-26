function obj = csc(x)
% csc cosecant function for unc vals
obj = x;
obj.val = csc(x.val);
for k = obj.srcs.keys'
    obj.srcs(k).sens = -csc(x.val).*cot(x.val).*obj.srcs(k).sens;
end

end

