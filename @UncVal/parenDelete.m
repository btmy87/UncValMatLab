function obj = parenDelete(obj,indexOp)
% need to index into value, xvar, and each object in srcs

obj.val.(indexOp) = [];
obj.xvar.(indexOp) = [];
for k = obj.srcs.keys'
    obj.srcs{k}.(indexOp) = [];
end
end

