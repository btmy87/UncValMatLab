function obj = UncValInt(val, srcs)
% internal use constructor for UncVal
% creates unc val from variance and srcs dictionary

obj = UncVal(val);
obj.xvar = sum(srcs.values);
obj.srcs = srcs;
obj.id = UncVal.calcId;

end