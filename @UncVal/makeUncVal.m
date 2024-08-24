function obj = makeUncVal(objIn)

if isa(objIn, "UncVal")
    obj = objIn;
else
    obj = UncVal(objIn, 0.0, UncVal.constId);
end
end