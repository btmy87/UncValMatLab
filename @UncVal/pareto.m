function [charts, ax] = pareto(obj, varargin)
%PARETO Helper function for pareto plots
% y and x filled in automatically, other arguments passed to pareto
srcs = obj.var_srcs();
[charts, ax] = pareto(srcs.var, srcs.name, varargin{:});
end

