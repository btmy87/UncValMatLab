% example for github readme
%% normal usage
x = UncVal(1.0, 0.1./2.0, "x"); % create values with standard uncertaities
y = UncVal(2.0, 0.2./2.0, "y"); % give values unique id's
z = sqrt(x.^2 + y.^2); % error is propagated through calculations

string(z)

z.var_srcs % display sources of variance

%% dependence
x = UncVal(1.0, 0.1/2.0, "x");
y = UncVal(1.0, 0.1/2.0, "y");
z1 = sin(x).^2 + cos(y).^2; % has uncertainty with independent inputs
string(z1)

z2 = sin(x).^2 + cos(x).^2; % identically equals 1 if inputs are correlated
string(z2)