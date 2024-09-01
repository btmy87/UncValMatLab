function x = toMonteCarlo(obj, nSamples)
%TOMONTECARLO convert an UncVal to a set of Monte Carlo samples
% intended for use on UncVal objects created directly by the user.
% It will work on any UncVal, but is only useful for statistically
% independent UncVals.
%
% x = toMonteCarlo(obj) generate default Monte Carlo samples
%
% x = toMonteCarlo(obj, nSamples) generate specified number of Monte Carlo
% samples

arguments
    obj UncVal
    nSamples (1, 1) {mustBePositive} = 1e5;
end

% Generate samples prior to scaling, need to reshape prior to scaling
if obj.uncType == "uniform"
    z = rand(1, nSamples).*2.0 - 1.0;
else
    z = randn(1, nSamples);
end

% Reshape z so we can use array expansion, we'll use the first singleton
% dimension, or the next dimension if none are singleton
idim = find(size(obj)==1, 1);
if isempty(idim)
    idim = ndims(obj) + 1;
end

sz = ones(1, max([ndims(obj), idim]));
sz(idim) = nSamples;
z = reshape(z, sz);

% scale z to get the real delta
if obj.uncType == "uniform"
    dx = z.*std(obj).*sqrt(3);
else
    dx = z.*std(obj);
end

% apply deltas
x = obj.val + dx;

end

