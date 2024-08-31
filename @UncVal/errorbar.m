function h = errorbar(ha, x, y, opts, erropts)
%ERRORBAR errorbar plot for UncVal objects, automatically configures 95%
%error bars.
% One additional argument is supported beyond the normal errorbar
% functionality.  For cases where both `x` and `y` are UncVal objects, pass
% SDE=false to get normal x-y errorbars.  Defaults to SDE=true, which will
% draw a standard devaite ellipse illustrating the correlation.
%
% INPUTS:
%  ha: optional axes handle
%  x: x coordinates to plot if x and y are both given.  If only one is
%  given, a default x coordinate is generated
%  y: y coordiantes to plot
%  opts: Name-Value pairs specific to UncVal.errorbar
%    .SDE: plot standard-deviational-ellipse for correlated `x` and `y`
%          defaults to true
%    .SDEpatch: if true, plots SDE's as patches.  if false, plots SDE's as
%          lines that form closed ellipses.  defaults to false.
%    .confidence: confidence interval for setting errorbars, set as a
%    fractional confidence in interval [0, 1] defaults to 0.9545 (2-sigma)
%  erropts: Name-Value pairs for standard errorbar call

arguments
    ha
    x  = []
    y = []
    opts.SDE (1, 1) logical = true;
    opts.SDEpatch (1, 1) logical = false;
    opts.confidence double = 0.954499736103642;
    erropts.?matlab.graphics.chart.primitive.ErrorBar;
end

erropts = namedargs2cell(erropts);

%% parse input arguments
% need to figure out if ha was given, if not first argument was x
if ~all(ishghandle(ha))
    % shift arguments back
    y = x;
    x = ha;

    % use current axes
    ha = gca;
end

% if y is not given, generate default x coordinates
if isempty(y)
    y = x;
    x = 1:length(y);
end

%% Make plot
if isnumeric(x)
    % only y is an UncVal
    ry = f_r(y, opts.confidence);
    h = errorbar(ha, x, y.val, ry, "vertical", erropts{:});
elseif isnumeric(y)
    % only x is an UncVal
    rx = f_r(x, opts.confidence);
    h = errorbar(ha, x.val, y, rx, "horizontal", erropts{:});
elseif ~opts.SDE
    % both x and y are UncVals, but user doesn't want correlated SDE
    % they may have different uncertainties, so we use the expanded form
    rx = f_r(x, opts.confidence);
    ry = f_r(y, opts.confidence);
    h = errorbar(ha, x.val, y.val, ry, ry, rx, rx, erropts{:});
else
    % both x and y are UncVals, and we want the ellipse
    % will draw as an array of patch objects, each column of the plot
    % matrices is an ellipse.

    % force x and y to row vectors
    x = x(:)';
    y = y(:)';

    % start with each patch as a unit_circle
    [xp, yp] = unit_circle(); % one circle
    xp = xp + zeros(size(x)); % one circle per point
    yp = yp + zeros(size(y)); 
    xp2 = zeros(size(xp));
    yp2 = zeros(size(yp));

    r = sqrt(-2*log(1-opts.confidence)); % scaling for confidence
    for i = 1:length(x)    
        % axes of ellipse are given by the eigenvectors and eigenvalues of 
        % the covariance matrix
        c = cov(x(i), y(i));
        [v, d] = eig(c, "vector");

        % scale magnitudes based on eigenvalues
        xp(:, i) = xp(:, i).*sqrt(d(1)).*r;
        yp(:, i) = yp(:, i).*sqrt(d(2)).*r;

        % rotate through first eigenvector
        theta = atan2(v(2, 1), v(1, 1));
        xp2(:, i) = xp(:, i).*cos(theta) - yp(:, i).*sin(theta);
        yp2(:, i) = xp(:, i).*sin(theta) + yp(:, i).*cos(theta);
    end
    % shift through nominal values
    xp2 = xp2 + x.val;
    yp2 = yp2 + y.val;

    if opts.SDEpatch
        h = patch(xp2(1:end-1, :), yp2(1:end-1, :), ...
            ha.ColorOrder(ha.ColorOrderIndex, :), ...
            "EdgeColor", ha.ColorOrder(ha.ColorOrderIndex, :), ...
            "FaceAlpha", 0.3, ...
            erropts{:});
        ha.ColorOrderIndex = ha.ColorOrderIndex + 1;
    else
        % collapse into a single line, separating individual ellipses with
        % nans
        xp2(end+1, :) = nan;
        yp2(end+1, :) = nan;
        h = plot(xp2(:), yp2(:), erropts{:});
    end
    
end

end

function [x, y] = unit_circle(n)
% return x-y coordinates of unit circle with n vertices
arguments
    n (1, 1) {mustBeNumeric} = 40;
end

% angle theta / pi
thetaQpi = linspace(0, 2, n+1)';

x = cospi(thetaQpi);
y = sinpi(thetaQpi);
end

function r = f_r(obj, p)
% helper function to return multiplier for double-sided probability

r = quantile(obj, 0.5*p+0.5) - obj.val;
end

