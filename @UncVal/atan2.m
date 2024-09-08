function out = atan2(Y, X)
%ATAN2 Four quadrant arctangent for UncVal objects

y1 = UncVal.makeUncVal(Y);
x1 = UncVal.makeUncVal(X);
out = atan(y1./x1);

if x1.val < 0 && y1.val > 0
    % real answer in 2nd quadrant, but atan output in 4th quadrant
    out = out + pi;
elseif x1.val < 0 && y1.val < 0
    % real anser in 3rd quadrant, but atan output in 1st quadrant
    out = out - pi;
end
end

