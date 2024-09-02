% Test_UncVal_simple
% simple script based unit tests for UncVal
% runtests("TEST_UncVal_simple")
% close all
% clear classes %#ok<CLCLS>
% clc

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
y1 = log(x); %#ok<NASGU>
y2 = log10(x); %#ok<NASGU>
y3 = exp(x); %#ok<NASGU>

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
y3check = y1./y2;
y4 = sin(x).^2 + cos(x).^2;

assertClose(y3.val, y3check.val);
assertClose(var(y3), var(y3check));
assertClose(y4.val, 1.0);
assertClose(var(y4), 0.0);

%% Test csc
x = UncVal(1.0, 0.1, "x");
y = csc(x) - 1.0./sin(x);
assertClose(y.val, 0.0);
assertClose(var(y), 0.0);

%% Test cscd
x = UncVal(18, 1, "x");
y = cscd(x) - 1.0./sind(x);
assertClose(y.val, 0.0);
assertClose(var(y), 0.0);

%% Test sec
x = UncVal(1.0, 0.1, "x");
y = sec(x) - 1.0./cos(x);
assertClose(y.val, 0.0);
assertClose(var(y), 0.0);

%% Test secd
x = UncVal(18, 1, "x");
y = secd(x) - 1.0./cosd(x);
assertClose(y.val, 0.0);
assertClose(var(y), 0.0);

%% Test cot
x = UncVal(1.0, 0.1, "x");
y = cot(x) - 1.0./tan(x);
assertClose(y.val, 0.0);
assertClose(var(y), 0.0);

%% Test cotd
x = UncVal(18, 1, "x");
y = cotd(x) - 1.0./tand(x);
assertClose(y.val, 0.0);
assertClose(var(y), 0.0);

%% Test asin
x = UncVal(0.3, 0.01, "x");
y = asin(x);
z = sin(y);
assertClose(z.val, x.val);
assertClose(var(z), var(x));

%% Test asind
x = UncVal(18, 1, "x");
y = asind(x);
z = sind(y);
assertClose(z.val, x.val);
assertClose(var(z), var(x));

%% Test acos
x = UncVal(0.3, 0.01, "x");
y = acos(x);
z = cos(y);
assertClose(z.val, x.val);
assertClose(var(z), var(x));

%% Test acosd
x = UncVal(18, 1, "x");
y = acosd(x);
z = cosd(y);
assertClose(z.val, x.val);
assertClose(var(z), var(x));

%% Test atan
x = UncVal(0.3, 0.01, "x");
y = atan(x);
z = tan(y);
assertClose(z.val, x.val);
assertClose(var(z), var(x));

%% Test atand
x = UncVal(18, 1, "x");
y = atand(x);
z = tand(y);
assertClose(z.val, x.val);
assertClose(var(z), var(x));

%% Test trig in degrees
x = UncVal(25.0, 0.1, "x");
y1 = sind(x);
y2 = cosd(x);
y3 = tand(x);
y3check = y1./y2;
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

%% Test string conversion
x = UncVal(1, 0.1/2, "x");
y = UncVal([1, 2; 3, 4], 0.1/2, "y");

xstr = string(x);
ystr = string(y);
assert(xstr == "UncVal (id=x): 1 ± 0.1 (2-sigma)");
assert(ystr == "UncVal (id=y): [2x2 double]")

%% Test double conversion
x = UncVal(1, 0.1, "x");
assert(double(x) == x.val);

%% Test ldivide with scalar
x = UncVal(1, 0.1, "x");
y = UncVal(2, 0.2, "y");

z1 = x./y;
z2 = y.\x;
assertClose(z1.val, z2.val);
assertClose(var(z1), var(z2));

%% Test covariance, uncorrelated
x = UncVal(1, 0.1, "x");
y = UncVal(2, 0.2, "y");
assertClose(cov(x, y), [var(x), 0.0; 0.0, var(y)]);

%% Test coveriance, perfectly correlated
x = UncVal(1, 0.1, "x");
y = x;
assertClose(cov(x, y), var(x).*[1,1;1,1]);


%% Test covariance, perfectly correlated multiple sources
x1 = UncVal(1, 0.1, "x1");
x2 = UncVal(2, 0.2, "x2");
x3 = UncVal(3, 0.3, "x3");
y1 = x1.^2 + sin(x2) + sqrt(x3);
y2 = x1.^2 + sin(x2) + sqrt(x3);
assertClose(cov(y1, y2), var(y1).*[1,1;1,1]);

%% Test covariance, partially correlated

x1 = UncVal(1, 0.1, "x1");
x2 = UncVal(2, 0.2, "x2");
y1 = 2*x1 + x2;

rng("default"); % want repeatability for testing
x1mc = x1.val + x1.unc()*randn(1, 1e6);
x2mc = x2.val + x2.unc()*randn(size(x1mc));
y1mc = 2*x1mc + x2mc;

covLin = cov(x1, y1);
covMc = cov(x1mc, y1mc);
covErr = abs(covLin-covMc)./covMc;
assert(all(covErr(:)< 5e-3));

%% Test covariance, partially correlated, negative

x1 = UncVal(1, 0.1, "x1");
x2 = UncVal(2, 0.2, "x2");
y1 = -2*x1 + x2;

rng("default"); % want repeatability for testing
x1mc = x1.val + x1.unc()*randn(1, 1e6);
x2mc = x2.val + x2.unc()*randn(size(x1mc));
y1mc = -2*x1mc + x2mc;

covLin = cov(x1, y1);
covMc = cov(x1mc, y1mc);
covErr = abs(covLin-covMc)./covMc;
assert(all(covErr(:)< 5e-3));

%% Test normal display
x = UncVal(1, 0.1, "x");
disp(x);

%% Test reshape
x = UncVal([1, 2, 3, 4], 0.1.*[1,2,3,4], "x");
y1 = reshape(x, 4, 1);
assertClose(y1.val, [1;2;3;4]);
assertClose(y1.srcs("x").xvar, (0.1.*[1;2;3;4]).^2);
assert(all(size(y1)==[4,1]));
assert(all(size(y1.srcs("x").sens)==[4, 1]))


y1 = reshape(x, [], 2);
assertClose(mean(y1), [1,3;2,4]);
assertClose(y1.srcs("x").xvar, (0.1.*[1,3;2,4]).^2);
assert(all(size(y1)==[2, 2]));
assert(all(size(y1.srcs("x").sens)==[2, 2]));

%% Test std function
x = UncVal(1, 0.1, "x");
assertClose(std(x), 0.1);

%% Test pdf
x = UncVal(0, 1, "x");
assertClose(x.pdf([-inf, 0, inf]), [0, 1/sqrt(2*pi), 0]);

xs = linspace(-8, 8, 1e5+1);
assertClose(trapz(xs, x.pdf(xs)), 1.0);

% single input form
[y, xs] = pdf(x);
assert(length(y) == 91);
assert(length(xs) == 91);
assertClose(y(46), 1/sqrt(2*pi));

%% Test cdf
x = UncVal(0, 1, "x");
assertClose(x.cdf([-inf, 0, inf]), [0, 0.5, 1]);

xs = linspace(-4, 4, 1e6+1);
y1 = x.cdf(xs(1)) + cumtrapz(xs, x.pdf(xs));
y2 = x.cdf(xs);
assertClose(y1, y2);

% single input form
[y, xs] = cdf(x);
assert(length(y) == 91);
assert(length(xs) == 91);
assertClose(y(46), 0.5);

%% Test corrcoeff
x = UncVal(0, 1, "x");
y = UncVal(1, 0.1, "y");

assertClose(corrcoef(x, x), [1, 1; 1, 1]);
assertClose(corrcoef(x, y), [1, 0; 0, 1]);

%% Test quantile
x = UncVal(0, 1, "x");
assertClose(quantile(x, 0.5), 0);

% don't have table to full tolernace
qm3 = quantile(x, 0.00135);
qm2 = quantile(x, 0.02275);
qm1 = quantile(x, 0.15866);
qp1 = quantile(x, 0.84134);
qp2 = quantile(x, 0.97725);
qp3 = quantile(x, 0.99865);
assert(abs(qm3+3)<5e-5);
assert(abs(qm2+2)<2e-5);
assert(abs(qm1+1)<2e-5);
assert(abs(qp1-1)<2e-5);
assert(abs(qp2-2)<2e-5);
assert(abs(qp3-3)<5e-5);

% test with evenly spaced quantiles
y = quantile(x, 3);
y0 = [-0.675, 0, 0.675];
assert(all(abs(y - y0)<2e-3));

%% Test parenListLength
x = UncVal(0, 1, "x");
assertClose(x(1).srcs("x").xvar, 1);

%% Test uncertainty at non-standard levels
x = UncVal(0, 1, "x");

% test at the 1-sigma, 2-sigma, and 3-sigma levels
% values from wikipedia
p = [0.68268949213, 0.954499736104, 0.997300203937];
assertClose(unc(x, p), [1, 2, 3]);

% test with shifted value
y = UncVal(5, 1, "y");
assertClose(unc(y, p), [1, 2, 3]);

%% Test other uncertainty input types
% these should both yield a standard uncertainty of 1.0
x = UncVal(0, 2      , "x", uncType="2-sigma");
y = UncVal(0, sqrt(3), "y", uncType="uniform");

assertClose(std(x), 1.0);
assertClose(std(y), 1.0);

