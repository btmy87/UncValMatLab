function obj = makeUncVal(objIn)

if isa(objIn, "UncVal")
    obj = objIn;
else
    obj = UncVal(objIn);
end
end