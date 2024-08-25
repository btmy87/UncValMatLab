function out = var_srcs(obj)
% var_srcs returns table with names and sources of variance for object
names = obj.srcs.keys;

sens = [obj.srcs.values.sens]';
xvars = [obj.srcs.values.xvar]';
vars = sens.^2.*xvars;

out = table();
out.name = names;
out.var = vars;
out.var_frac = out.var./sum(out.var);
out.src_var = xvars;
out.sens = sens;
out = sortrows(out, "var", "descend");