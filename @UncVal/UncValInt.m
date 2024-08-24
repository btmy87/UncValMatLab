function obj = UncValInt(val, srcs)
% internal use constructor for UncVal
% creates unc val from variance and srcs dictionary

obj = UncVal(val);
obj.xvar = 0.0;
for i = 1:length(srcs.values)
    obj.xvar = obj.xvar + srcs.values{i};
end
obj.srcs = srcs;
obj.id = UncVal.calcId;

% force array expansion in all sources
for k = obj.srcs.keys'
    obj.srcs{k} = obj.srcs{k} + zeros(size(val));
end
end