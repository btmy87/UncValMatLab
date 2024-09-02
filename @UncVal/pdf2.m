function [p, xi, yi, f] = pdf2(x, y, xi, yi, opts)
%PDF2 Evaluates bivariate probability distribution function
%   Generate a bivariate probability distribution function for two UncVal
%   objects, `x` and `y`.  Evaluate the probability at points `xi` and
%   `yi`.  Optionally return the function handle.
%
% [p, xi, yi] = pdf2(x, y) Evaluate bivariate probability distribution at 
% default points.  Default points form an nd grid in x and y
%
% p = pdf2(x, y, xi, yi) Evaluate bivariate probability distribution at
% given points.
%
% [~, ~, ~, f] = pdf2(x, y) Return function handle that can be used to
% evaluate the bivariate probability distribution.
%
% pdf2( ___ , tol=val) Sets tolerance on correlation coefficient.
% Correlation coefficients with r^2 > 1-tol trigger an error.

arguments
    x (1, 1) UncVal
    y (1, 1) UncVal
    xi double = []
    yi double = []
    opts.tol (1, 1) double {mustBePositive} = 1e-3;
end

% get covariance matrix
c = cov(x, y);
sx = sqrt(c(1, 1));
sy = sqrt(c(2, 2));
r = c(1, 2)./sx./sy; % correlation coefficient
r2 = r.^2;

% trap some common problems
assert(sx > 0 && sy > 0, "UncVal:NotSupported", ...
    "Both x and y must be UncVal objects with positive variance.")
assert(r1 <= (1-opts.tol), "UncVal:NotSupported", ...
    "Variables are correlated, or nearly correlated." + ...
    "Bivariate PDF is only available for non-correlated variables.");

% make function handle
k1 = 1.0./(2.0.*pi.*sx.*sy.*sqrt(1-r2));
k2 = -1.0./(2.0.*(1-r2));
f = @(xi, yi) k1.*exp(k2.*( ((xi-x.val)./sx).^2 ...
    - 2.0.*r.*(xi-x.val).*(yi-y.val)./sx./sy ...
    + ((yi-y.val)./sy).^2));

% evaluate default arguments if we need them
if isempty(xi) && isempty(yi)
    [xi, yi] = ndgrid(linspace(-3, 3, 61).*sx + x.val, ...
                      linspace(-3, 3, 61).*sy + y.val);
end

% evaluate probability along distribution
p = f(xi, yi);

end

