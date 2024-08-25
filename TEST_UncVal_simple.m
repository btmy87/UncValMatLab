% Test_UncVal_simple
% simple script based unit tests for UncVal
% runtests("TEST_UncVal_simple")
close all
clear classes %#ok<CLCLS>
clc

relTol = 1e-10;
absTol = 1e-10;
isClose = @(x, y) abs(x-y) < (relTol.*abs(x) + absTol);
assertClose = @(x, y) assert(all(isClose(x, y), 'all'));

%% Test Plus with 2 UncVals
x = UncVal(1.0, 0.1, "x");
y = UncVal(2.0, 0.2, "y");
z = x + y;
assertClose(z.val, 3.0);
assertClose(var(z), 0.05);
assert(numEntries(z.srcs) == 2);

%% Test Plus with scalar
x = UncVal(1.0, 0.1, "x");
z = x + 2;
assertClose(z.val, 3.0);
assertClose(var(z), 0.01);
assert(numEntries(z.srcs) == 2);

%% Test Plus with same UncVal
% capture correlation
x = UncVal(1.0, 0.1, "x");
z = x + x;
assertClose(z.val, 2.0);
assertClose(var(z), 0.04);
assert(numEntries(z.srcs) == 1);


%% Test Minus with 2 UncVals
x = UncVal(2.0, 0.1, "x");
y = UncVal(1.0, 0.2, "y");
z = x - y;
assertClose(z.val, 1.0);
assertClose(var(z), 0.05);
assert(numEntries(z.srcs) == 2);

%% Test Minus with scalar
x = UncVal(2.0, 0.1, "x");
z = x - 1;
assertClose(z.val, 1.0);
assertClose(var(z), 0.01);
assert(numEntries(z.srcs) == 2);

%% Test Minus with same UncVal
x = UncVal(2.0, 0.1, "x");
z = x - x;
assertClose(z.val, 0.0);
assertClose(var(z), 0.0);
assert(numEntries(z.srcs) == 1);

%% Test Unary Plus
x = UncVal(1.0, 0.1, "x");
z = +x;
assertClose(z.val, 1.0);
assertClose(var(z), 0.01);
assert(numEntries(z.srcs) == 1);

%% Test Unary Minus
x = UncVal(1.0, 0.1, "x");
z = -x;
assertClose(z.val, -1.0);
assertClose(var(z), 0.01);
assert(numEntries(z.srcs) == 1);

%% Test Times with Scalar
x = UncVal(1.0, 0.1, "x");
z = 2.*x;
assertClose(z.val, 2.0);
assertClose(var(z), 0.04);
assert(numEntries(z.srcs) == 2);

%% Test Times with 2 UncVals
x = UncVal(2.0, 0.1, "x");
y = UncVal(3.0, 0.2, "y");
z = x.*y;
assertClose(z.val, 6.0);
assertClose(var(z), 0.25);
assert(numEntries(z.srcs) == 2);

%% Test Times with repeated UncVal
% should see single value in srcs
x = UncVal(3.0, 0.1, "x");
z = x.*x;
assertClose(z.val, 9.0);
assertClose(var(z), 0.36);
assert(numEntries(z.srcs) == 1);

%% Test Divide by Self

x = UncVal(3.0, 0.1, "x");
z = x./x;
assertClose(z.val, 1.0);
assertClose(var(z), 0.0);
assert(numEntries(z.srcs) == 1);

%% Test Divide by Scalar

x = UncVal(2.0, 0.1, "x");
z = x./2;
assertClose(z.val, 1.0);
assertClose(var(z), 0.0025);
assert(numEntries(z.srcs) == 2);

%% Test power with scalar
% should see single value in srcs
x = UncVal(3.0, 0.1, "x");
z = x.^2;
assertClose(z.val, 9.0);
assertClose(var(z), 0.36);
assert(numEntries(z.srcs) == 2);

%% Test same sized arrays
x = UncVal([1.0, 2.0], [0.1, 0.1], "x");
y = UncVal([2.0, 3.0], [0.2, 0.3], "y");
z = x + y;
assertClose(z.val, [3.0, 5.0]);
assertClose(var(z), [0.05, 0.1]);
assert(numEntries(z.srcs) == 2);

%% Test array with scalar
x = UncVal([1.0, 2.0], [0.1, 0.2], "x");
z = 2.*x;
assertClose(z.val, [2.0, 4.0]);
assertClose(var(z), [0.04, 0.16]);
assert(numEntries(z.srcs) == 2);

%% Test Array Expansion
x = UncVal([1.0, 2.0], [0.1, 0.1], "x");
y = UncVal([2.0; 3.0], [0.2; 0.3], "y");
z = x + y;
assertClose(z.val, [3.0, 4.0; ...
                    4.0, 5.0]);
assertClose(var(z), [0.05, 0.05; ...
                     0.10, 0.10]);
assert(numEntries(z.srcs) == 2);

%% Test parenReference for scalar
x = UncVal([1.0, 2.0], [0.1, 0.1], "x");
y = UncVal([2.0; 3.0], [0.2; 0.3], "y");
z = x + y;
z1 = z(2, 1);
assertClose(z1.val, 4.0);
assertClose(var(z1), 0.10);
assert(numEntries(z1.srcs), 2);

%% Test parenReference for range
x = UncVal([1.0, 2.0], [0.1, 0.1], "x");
y = UncVal([2.0; 3.0], [0.2; 0.3], "y");
z = x + y;
z1 = z(1, :);
assertClose(z1.val, [3.0, 4.0]);
assertClose(var(z1), [0.05, 0.05]);
assert(numEntries(z1.srcs), 2);

%% Test parenDelete
x = UncVal([1.0, 2.0], [0.1, 0.1], "x");
y = UncVal([2.0, 3.0], [0.2, 0.3], "y");
z = 2.*x + y;
z(1) = [];
assertClose(z.val, 7.0);
assertClose(var(z), 0.13);
assert(numEntries(z.srcs) == 3);

%% Test cat
x = UncVal([1.0, 2.0], [0.1, 0.1], "x");
y = UncVal([2.0, 3.0], [0.2, 0.3], "y");
z = [x, y];
assertClose(z.val, [1.0, 2.0, 2.0, 3.0]);
assertClose(var(z), [0.01, 0.01, 0.04, 0.09]);
assert(numEntries(z.srcs), 2);

%% Test empty
x = UncVal.empty();
y = UncVal.empty(0, 1);
assert(isempty(x));
assert(isempty(y));

%% Test size
x = UncVal([1,2,3;4,5,6], 0.01, "x");
assert(all(size(x) == [2, 3]));

%% Test parenAssign
x = UncVal([1,2,3], 0.1, "x");
y = UncVal(4.0, 0.2, "y");
x(2) = y;
assertClose(x.val, [1.0, 4.0, 3.0]);
assertClose(var(x), [0.01, 0.04, 0.01]);
assertClose(x.srcs("x").sens, [1, 0, 1]);
assertClose(x.srcs("y").sens, [0, 1, 0]);
assert(numEntries(x.srcs)==2);

%% Test problem 3.47 phys431
% from https://courses.washington.edu/phys431/propagation_errors_UCh.pdf
g = 9.8;
M = UncVal(100, 1, "M");
m = UncVal(50, 1, "m");
a = g.*(M-m)./(M+m);
assert(abs(a.val-3.27)<0.01)
assert(abs(a.unc()-0.097)<0.001)

%% Test problem QuickCheck 3.9 phys431
% from https://courses.washington.edu/phys431/propagation_errors_UCh.pdf
x = UncVal(200, 2, "x");
y = UncVal(50, 2, "y");
z = UncVal(40, 2, "z");
D = y - z;
assertClose(D.val, 10);
assertClose(D.unc(), 2*sqrt(2));

q1 = x./D;
assertClose(q1.val, 20);
assertClose(q1.unc(), 20.*((2/200).^2 + (2*sqrt(2)/10).^2).^0.5);

%% Test Example d from LSU
% https://www.geol.lsu.edu/jlorenzo/geophysics/uncertainties/Uncertaintiespart2.html
w = UncVal(4.52, 0.02, "w");
x = UncVal(2.0, 0.2, "x");
y = UncVal(3.0, 0.6, "y");
z = w.*x + y.^2;
