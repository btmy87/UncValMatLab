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

    % may need to create new keys, initialize with zeros
    newKeys = setdiff(rhs.srcs.keys, obj.srcs.keys);
    init = zeros(origSize);
    for k = newKeys'
        obj.srcs(k) = struct("xvar", init, ...
                             "sens", init);
    end

    % need to make sure all the old keys are on the rhs argument
    oldKeys = setdiff(obj.srcs.keys, rhs.srcs.keys);
    init2 = zeros(size(rhs.val));
    for k = oldKeys'
        rhs.srcs(k) = struct("xvar", init2, ...
                             "sens", init2);
    end

    % now add in new data
    for k = rhs.srcs.keys'
        obj.srcs(k).xvar.(indexOp) = rhs.srcs(k).xvar;
        obj.srcs(k).sens.(indexOp) = rhs.srcs(k).sens;
    end
    return;
end
[obj.(indexOp(2:end))] = varargin{:};
end

