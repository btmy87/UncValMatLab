function obj = reshape(obj, varargin)
%RESHAPE reshape function for UncVal class

obj.val = reshape(obj.val, varargin{:});
for k = obj.srcs.keys'
    obj.srcs(k).sens = reshape(obj.srcs(k).sens, varargin{:});
    obj.srcs(k).xvar = reshape(obj.srcs(k).xvar, varargin{:});
end
end

