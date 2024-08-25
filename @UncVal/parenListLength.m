function n = parenListLength(obj,indexOp,ctx)
% no idea what this does, just copied example from help
if numel(indexOp) <= 2
    n = 1;
    return;
end
containedObj = obj.(indexOp(1:2));
n = listLength(containedObj,indexOp(3:end),ctx);
end
