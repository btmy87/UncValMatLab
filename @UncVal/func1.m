function y = func1(x, f)
%FUNC propagate uncertainty through a numeric function of 1 variable
%
% INPUTS:
%   varargin = arguments to function
%   f = function handle to a numeric function

arguments
    x UncVal
    f (1, 1) function_handle
end


% call function at nominal values 
x0 = x.val;
y0 = f(x0);

% get the slope
dx = 1e6*eps(x0) + 1e-8;
dy = f(x0+dx) - y0;
dydx = dy./dx;

% transform to source sensitivities.
y = x;
y.id = UncVal.calcId;
y.uncType = UncVal.calcType;
y.val = y0;
for k = y.srcs.keys'
    y.srcs(k).sens = dydx.*y.srcs(k).sens;
end

end

