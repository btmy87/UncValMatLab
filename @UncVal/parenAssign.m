function obj = parenAssign(obj,indexOp,varargin)
% Ensure object instance is the first argument of call.
if isempty(obj)
    obj = varargin{1};
end
if isscalar(indexOp)
    assert(nargin==3);
    rhs = varargin{1};
    origSize = size(obj.val);
    obj.val.(indexOp) = rhs.val;
    obj.xvar.(indexOp) = rhs.xvar;

    % may need to create new keys, initialize with zeros
    newKeys = setdiff(rhs.srcs.keys, obj.srcs.keys);
    for k = newKeys'
        obj.srcs{k} = zeros(origSize);
    end

    % need to make sure all the old keys are on the rhs argument
    oldKeys = setdiff(obj.srcs.keys, rhs.srcs.keys);
    for k = oldKeys'
        rhs.srcs{k} = zeros(size(rhs.val));
    end

    % now add in new data
    for k = rhs.srcs.keys'
        obj.srcs{k}.(indexOp) = rhs.srcs{k};
    end
    return;
end
[obj.(indexOp(2:end))] = varargin{:};
end

