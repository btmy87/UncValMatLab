function obj = power(x, y)
% power raises one UncVal to the power of another
x1 = UncVal.makeUncVal(x);
y1 = UncVal.makeUncVal(y);

% f(a) = x(a).^y(a)
% df/da = (y*x^(y-1))*dx/da + (x^y)*ln(x)*dy/dx
%         -----------         -----------
%            Cx                   Cy

f = x1.val.^y1.val;
Cx = y1.val.*x1.val.^(y1.val-1.0);
Cy = f.*log(x1.val);

srcs = UncVal.propagate(x1.srcs, y1.srcs, Cx, Cy);

% create the output object
obj = UncVal.UncValInt(f, srcs);
end