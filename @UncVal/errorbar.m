function h = errorbar(varargin)
%ERRORBAR errorbar plot for UncVal objects, automatically configures 95%
%error bars.
% One additional argument is supported beyond the normal errorbar
% functionality.  For cases where both `x` and `y` are UncVal objects, pass
% SDE=false to get normal x-y errorbars.  Defaults to SDE=true, which will
% draw a standard devaite ellipse illustrating the correlation.


%% parse input arguments
i = 1;
if nargin > 0 && all(ishghandle(varargin{1}))
    ha = varargin{1};
    i = i + 1;
else
    ha = gca;
end

% check if y is supplied or x and y
yOnly = nargin < (i+1) ...
      || ~(isnumeric(varargin{i+1}(1)) || isa(varargin{i+1}(1), "UncVal"));
if yOnly
    % just y, let's make a default x
    y = varargin{i};
    x = 1:length(y);
    i = i + 1;
else
    % x and y are given
    x = varargin{i};
    y = varargin{i+1};
    i = i + 2;
end
extraArgs1 = varargin(i:end);

% extract new arguments
SDE = true;
i = 1;
extraArgs = {};
while i <= length(extraArgs1)
    if (ischar(extraArgs1{i}) || isstring(extraArgs1{i})) ...  %must be string like
            && string(extraArgs1{i}) == "SDE" ... % and be equal to the SDE option name
            && i < length(extraArgs1) ... % and there must be an element for the value of the object
            && ~extraArgs1{i+1}
        SDE = false;
        i = i + 2;
    else
        extraArgs = [extraArgs, extraArgs1(i)]; %#ok<AGROW>
        i = i + 1;
    end
end

%% Make plot
if isnumeric(x)
    % only y is an UncVal
    h = errorbar(ha, x, y.val, 2.*y.unc(), "vertical", extraArgs{:});
elseif isnumeric(y)
    % only x is an UncVal
    h = errorbar(ha, x.val, y, 2.*x.unc(), "horizontal", extraArgs{:});
elseif ~SDE
    % both x and y are UncVals, but user doesn't want correlated SDE
    % they may have different uncertainties, so we use the expanded form
    h = errorbar(ha, x.val, y.val, 2.*y.unc(), 2.*y.unc(), ...
        2.*x.unc(), 2.*x.unc(), extraArgs{:});
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


    r = sqrt(-2*log(1-0.95)); % scaling to enclose 95% of values, 
                              % TODO: let user override
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

    h = patch(xp2, yp2, ha.ColorOrder(ha.ColorOrderIndex, :), ...
        extraArgs{:});
    
end

end

function [x, y] = unit_circle(n)
% return x-y coordinates of unit circle with n vertices
arguments
    n (1, 1) {mustBeNumeric} = 40;
end

% angle theta / pi
thetaQpi = linspace(0, 2, n+1)';

x = cospi(thetaQpi(1:n));
y = sinpi(thetaQpi(1:n));
end

