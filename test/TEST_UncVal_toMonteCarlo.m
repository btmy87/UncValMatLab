% TEST_UncVal_toMonteCarlo
% test cases for the toMonteCarlo function
% runtests("TEST_UncVal_toMonteCarlo")

% we need much looser tolerances for MonteCarlo work
relTol = 1e-2;
absTol = 1e-2;
isClose = @(x, y) abs(x-y) < (relTol.*abs(x) + absTol);
assertClose = @(x, y) assert(all(isClose(x, y), 'all'));

if exist("UncVal", "class") < 1
    % need to add path to parent folder
    dir = string(fileparts(mfilename("fullpath")));
    addpath(fullfile(dir, ".."));
end

%% Test toMonteCarlo scalars
rng("default");

x = UncVal(0, 1, "x");
y = UncVal(0, 2, "y");
x = x.toMonteCarlo();
y = y.toMonteCarlo();
z = x + y;

assert(isa(x, "double"))
assert(isa(y, "double"));
assert(all(size(x) == [1e5, 1]));
assert(all(size(y) == [1e5, 1]));

assertClose(mean(x), 0);
assertClose(mean(y), 0);
assertClose(mean(z), 0);

assertClose(std(x), 1);
assertClose(std(y), 2);
assertClose(std(z), sqrt(5));

%% Test toMonteCarlo, rowVectors
rng("default");

x = UncVal([0, 1, 2], 1, "x");
y = UncVal([0, 2, 4], 2, "y");
x = x.toMonteCarlo();
y = y.toMonteCarlo();
z = x + y;

assert(isa(x, "double"))
assert(isa(y, "double"));
assert(all(size(x) == [1e5, 3]));
assert(all(size(y) == [1e5, 3]));

assertClose(mean(x), [0, 1, 2]);
assertClose(mean(y), [0, 2, 4]);
assertClose(mean(z), [0, 3, 6]);

assertClose(std(x), [1, 1, 1]);
assertClose(std(y), [2, 2, 2]);
assertClose(std(z), [1, 1, 1].*sqrt(5));

%% Test toMonteCarlo, column vectors
rng("default");

x = UncVal([0; 1; 2], 1, "x");
y = UncVal([0; 2; 4], 2, "y");
x = x.toMonteCarlo();
y = y.toMonteCarlo();
z = x + y;

assert(isa(x, "double"))
assert(isa(y, "double"));
assert(all(size(x) == [3, 1e5]));
assert(all(size(y) == [3, 1e5]));

assertClose(mean(x, 2), [0; 1; 2]);
assertClose(mean(y, 2), [0; 2; 4]);
assertClose(mean(z, 2), [0; 3; 6]);

assertClose(std(x, 0, 2), [1; 1; 1]);
assertClose(std(y, 0, 2), [2; 2; 2]);
assertClose(std(z, 0, 2), [1; 1; 1].*sqrt(5));

%% Test toMonteCarlo, 2D arrays
rng("default");

x = UncVal([0, 1; 2, 3], 1, "x");
y = UncVal([0, 2; 4, 6], 2, "y");
x = x.toMonteCarlo();
y = y.toMonteCarlo();
z = x + y;

assert(isa(x, "double"))
assert(isa(y, "double"));
assert(all(size(x) == [2, 2, 1e5]));
assert(all(size(y) == [2, 2, 1e5]));

assertClose(mean(x, 3), [0, 1; 2, 3]);
assertClose(mean(y, 3), [0, 2; 4, 6]);
assertClose(mean(z, 3), [0, 3; 6, 9]);

assertClose(std(x, 0, 3), ones(2, 2).*1);
assertClose(std(y, 0, 3), ones(2, 2).*2);
assertClose(std(z, 0, 3), ones(2, 2).*sqrt(5));

%% Test toMonteCarlo, uniform
rng("default");
x = UncVal(0, 1, "x", uncType="uniform");
x = x.toMonteCarlo();

assertClose(min(x), -1);
assertClose(max(x), 1);


