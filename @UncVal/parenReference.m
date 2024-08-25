function varargout = parenReference(obj, indexOp)
% need to index into value, xvar, and each object in srcs

obj.val = obj.val.(indexOp(1));
obj.xvar = obj.xvar.(indexOp(1));
for k = obj.srcs.keys'
    obj.srcs{k} = obj.srcs{k}.(indexOp(1));
end
if isscalar(indexOp)
    varargout{1} = obj;
    return;
end
[varargout{1:nargout}] = obj.(indexOp(2:end));
end