function obj = parenDelete(obj,indexOp)
% need to index into value, xvar, and each object in srcs

obj.val.(indexOp) = [];
for k = obj.srcs.keys'
    obj.srcs(k).xvar.(indexOp) = [];
    obj.srcs(k).sens.(indexOp) = [];
end
end

