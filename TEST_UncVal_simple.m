% Test_UncVal_simple
% simple script based unit tests for UncVal
% runtests("TEST_UncVal_simple")
close all
clear
clc

relTol = 1e-10;
absTol = 1e-10;
isClose = @(x, y) abs(x-y) < (relTol.*abs(x) + absTol);
assertClose = @(x, y) assert(all(isClose(x, y)));

%% Test Plus with 2 UncVals
x = UncVal(1.0, 0.1, "x");
y = UncVal(2.0, 0.2, "y");
z = x + y;
assertClose(z.val, 3.0);
assertClose(z.xvar, 0.05);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 2);

%% Test Plus with scalar
x = UncVal(1.0, 0.1, "x");
z = x + 2;
assertClose(z.val, 3.0);
assertClose(z.xvar, 0.01);
assertClose(z.xvar, sum(z.srcs.values));

%% Test Plus with same UncVal
% capture correlation
x = UncVal(1.0, 0.1, "x");
z = x + x;
assertClose(z.val, 2.0);
assertClose(z.xvar, 0.04);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 1);


%% Test Minus with 2 UncVals
x = UncVal(2.0, 0.1, "x");
y = UncVal(1.0, 0.2, "y");
z = x - y;
assertClose(z.val, 1.0);
assertClose(z.xvar, 0.05);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 2);

%% Test Minus with scalar
x = UncVal(2.0, 0.1, "x");
z = x - 1;
assertClose(z.val, 1.0);
assertClose(z.xvar, 0.01);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 2);

%% Test Minus with same UncVal
x = UncVal(2.0, 0.1, "x");
z = x - x;
assertClose(z.val, 0.0);
assertClose(z.xvar, 0.0);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 1);

%% Test Unary Plus
x = UncVal(1.0, 0.1, "x");
z = +x;
assertClose(z.val, 1.0);
assertClose(z.xvar, 0.01);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 1);

%% Test Unary Minus
x = UncVal(1.0, 0.1, "x");
z = -x;
assertClose(z.val, -1.0);
assertClose(z.xvar, 0.01);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 1);

%% Test Times with Scalar
x = UncVal(1.0, 0.1, "x");
z = 2.*x;
assertClose(z.val, 2.0);
assertClose(z.xvar, 0.04);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 2);

%% Test Times with 2 UncVals
x = UncVal(2.0, 0.1, "x");
y = UncVal(3.0, 0.2, "y");
z = x.*y;
assertClose(z.val, 6.0);
assertClose(z.xvar, 0.25);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 2);

%% Test Times with repeated UncVal
% should see single value in srcs
x = UncVal(3.0, 0.1, "x");
z = x.*x;
assertClose(z.val, 9.0);
assertClose(z.xvar, 0.36);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 1);

%% Test Divide by Self

x = UncVal(3.0, 0.1, "x");
z = x./x;
assertClose(z.val, 1.0);
assertClose(z.xvar, 0.0);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 1);

%% Test power with scalar
% should see single value in srcs
x = UncVal(3.0, 0.1, "x");
z = x.^2;
assertClose(z.val, 9.0);
assertClose(z.xvar, 0.36);
assertClose(z.xvar, sum(z.srcs.values));
assert(numEntries(z.srcs) == 2);
