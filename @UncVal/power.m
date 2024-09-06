function obj = power(x, y)
% power raises one UncVal to the power of another

x1 = UncVal.makeUncVal(x);
if isa(y, "UncVal")
    
    % f(a) = x(a).^y(a)
    % df/da = (y*x^(y-1))*dx/da + (x^y)*ln(x)*dy/da
    %         -----------         -----------
    %            Cx                   Cy
    
    y1 = y;
    f = x1.val.^y1.val;
    Cx = y1.val.*x1.val.^(y1.val-1.0);
    if x1.val > 0.0
        Cy = f.*log(x1.val);
    elseif x1.val == 0.0
        % avoid nan at x = 0
        % L'Hopital's rule on (x^y)./(1/ln(x))
        Cy = 0.0;
    else
        error("UncVal:NotSupported", ...
            "Negative `x` values are not supported with `UncVal` exponents");
    end
else
    % specialization for numeric y
    f = x1.val.^y;
    Cx = y.*x1.val.^(y-1.0);
    Cy = 0.0;
    y1 = UncVal.makeUncVal(y);

end
srcs = UncVal.propagate(x1.srcs, y1.srcs, Cx, Cy);

% create the output object
obj = UncVal.UncValInt(f, srcs);
end