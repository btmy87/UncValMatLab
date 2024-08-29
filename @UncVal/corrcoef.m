function R = corrcoef(a, b)
%corrcoeff correlation coefficient for UncVal objects
% R = corrcoef(A, B)
% only scalar UncVal's are supported
% no other syntax options are supported

assert(isscalar(a) && isscalar(b), "UncVal:NotSupported", ...
    "`corrcoef` for UncVal objects only supports scalar inputs");

assert(isa(a, "UncVal") && isa(b, "UncVal"), "UncVal:NotSupported", ...
    "`corrcoef` inputs must both be `UncVal` objects");

c = cov(a, b)./a.unc()./b.unc();
R = [1, c(1, 2); c(2, 1), 1]

end