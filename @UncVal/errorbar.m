function h = errorbar(varargin)
%ERRORBAR errorbar plot for UncVal objects, automatically configures 95%
%error bars.


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
extraArgs = varargin(i:end);

%% Make plot
if isnumeric(x)
    % only y is an UncVal
    h = errorbar(ha, x, y.val, 2.*y.unc(), "vertical", extraArgs{:});
elseif isnumeric(y)
    % only x is an UncVal
    h = errorbar(ha, x.val, y, 2.*x.unc(), "horizontal", extraArgs{:});
else
    % both x and y are UncVals
    % they may have different uncertainties, so we use the expanded form
    h = errorbar(ha, x.val, y.val, 2.*y.unc(), 2.*y.unc(), ...
        2.*x.unc(), 2.*x.unc(), extraArgs{:});
end

end

