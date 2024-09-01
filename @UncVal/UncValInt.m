function obj = UncValInt(val, srcs)
% internal use constructor for UncVal
% creates unc val from variance and srcs dictionary

obj = UncVal(val);
obj.srcs = srcs;
obj.id = UncVal.calcId;
obj.uncType = UncVal.calcType;

% force array expansion in all sources
for k = obj.srcs.keys'
    obj.srcs(k).sens = obj.srcs(k).sens + zeros(size(val));
    obj.srcs(k).xvar = obj.srcs(k).xvar + zeros(size(val));
end
end