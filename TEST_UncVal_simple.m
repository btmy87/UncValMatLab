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
% % https://www.geol.lsu.edu/jlorenzo/geophysics/uncertainties/Uncertaintiespart2.html
% % This example is incorrect, doesn't appropriately add uncertainty in
% % last step.
% w = UncVal(4.52, 0.02, "w");
% x = UncVal(2.0, 0.2, "x");
% y = UncVal(3.0, 0.6, "y");
% v = w.*x;
% y2 = y.^2;
% z = w.*x + y.^2;
% 
% assert(abs(z.val-18.0)<0.1)
% assert(abs(z.unc()-4.5)<0.1)

%% Test Sum, vector
x = UncVal(1, 0.1, "x");
y = UncVal(2, 0.1, "y");
temp = [x, y];
z = sum([x, y]);
assertClose(z.val, 3);
assertClose(var(z), 0.02);
assert(numEntries(z.srcs), 2);

%% Test transpose
x = UncVal([1, 2], 0.1, "x");
z = x.';
assertClose(z.val, [1; 2]);
assertClose(var(z), [0.01; 0.01]);
assert(all(size(z)==[2,1]));

%% Test ctranspose
x = UncVal([1, 2], 0.1, "x");
z = x';
assertClose(z.val, [1; 2]);
assertClose(var(z), [0.01; 0.01]);
assert(all(size(z)==[2,1]));

%% Test matrix multiplication
x = UncVal([1, 0; 0, 1], 0.1, "x");
y = UncVal([1, 2; 3, 4], 0.1, "y");
z = x*y;
assertClose(z.val, [1, 2; 3, 4]);
% no idea what this means in an uncertainty world

%% Test mtimes with 2 UncVal Scalars
x = UncVal(2.0, 0.1, "x");
y = UncVal(3.0, 0.2, "y");
z = x*y;
assertClose(z.val, 6.0);
assertClose(var(z), 0.25);
assert(numEntries(z.srcs) == 3);

%% Test mrdivide by Scalar
x = UncVal(2.0, 0.1, "x");
z = x/2;
assertClose(z.val, 1.0);
assertClose(var(z), 0.0025);
assert(numEntries(z.srcs) == 2);

%% Test mpower with scalar
% should see single value in srcs
x = UncVal(3.0, 0.1, "x");
z = x^2;
assertClose(z.val, 9.0);
assertClose(var(z), 0.36);
assert(numEntries(z.srcs) == 2);

%% Test exponentials and logs
x = UncVal(1.0, 0.1, "x");
y1 = log(x);
y2 = log10(x);
y3 = exp(x);

y4 = exp(log(x));
assertClose(y4.val, 1.0);
assertClose(var(y4), 0.01);

y5 = log10(10.^x);
assertClose(y5.val, 1.0);
assertClose(var(y5), 0.01);
% TODO: add some real tests

%% Test trig
x = UncVal(1.0, 0.1, "x");
y1 = sin(x);
y2 = cos(x);
y3 = tan(x);
y3check = sin(x)./cos(x);
y4 = sin(x).^2 + cos(x).^2;

assertClose(y3.val, y3check.val);
assertClose(var(y3), var(y3check));
assertClose(y4.val, 1.0);
assertClose(var(y4), 0.0);

%% Test trig in degrees
x = UncVal(25.0, 0.1, "x");
y1 = sind(x);
y2 = cosd(x);
y3 = tand(x);
y3check = sind(x)./cosd(x);
y4 = sind(x).^2 + cosd(x).^2;

assertClose(y3.val, y3check.val);
assertClose(var(y3), var(y3check));
assertClose(y4.val, 1.0);
assertClose(var(y4), 0.0);


%% Test problem 3.50 phys431
% from https://courses.washington.edu/phys431/propagation_errors_UCh.pdf
x = UncVal(10.0, 2.0, "x");
y = UncVal(7.0, 1.0, "y");
thetad = UncVal(40.0, 3.0, "thetad");

theta = thetad*pi/180.0;
q = (x+2)./(x+y.*cos(4.0*theta));

assert(abs(q.val-3.5)<0.1);
assert(abs(q.unc()-sqrt(3.3))<0.02);

%% Test problem E4 from NIST-TN-1900
% https://nvlpubs.nist.gov/nistpubs/TechnicalNotes/NIST.TN.1900.pdf
% don't even match the nominal calc??????
dp = UncVal(1.993e3, 25.0/2 , "dp"); % pa
r = 287.058;
t = UncVal(292.8, 0.11/2, "t"); % K
p = UncVal(101.4e3, 2.1e3/2, "p"); % pa
dens = p./(r.*t);
% v = sqrt(2.*dp.*r.*t./p);
v = sqrt(2*dp./dens);

% assert(abs(v.val-40.64)<0.02);
% assert(abs(v.unc-0.25)<0.01);

%% chemistry example
% example 1 from https://chem.libretexts.org/Bookshelves/Analytical_Chemistry/Supplemental_Modules_(Analytical_Chemistry)/Quantifying_Nature/Significant_Digits/Propagation_of_Error

c = UncVal(13.7, 0.3, "c");
l = UncVal(1.0, 0.1, "l");
A = UncVal(0.172807, 0.000008, "A");

e1 = A./(l.*c);
assert(abs(e1.val-0.013)<0.001);
assert(abs(e1.unc()./e1.val-0.10237)<0.001);

%% example from https://123.physics.ucdavis.edu/week_0_files/ErrorPropagation2A.pdf
x = UncVal(5.75, 0.08, "x");
q = x.^3;
assert(abs(q.val-190)<1);
assert(abs(q.unc()-7.93)<0.02);