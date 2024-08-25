function h = plot(varargin)
%PLOT Plot UncVal, just plot the value

for i = 1:nargin
    if isa(varargin{i}, "UncVal")
        varargin{i} = varargin{i}.val;
    end
end

h = plot(varargin{:});
end

