%%example_UncVal_1
% flow through a venturi
% consider flow of water through a venturi
% we measure pressure and temperature upstream of the venturi, and the
% throat pressure of the venturi
% we neglect any Cd effects

%% Calculations
% take the upstream diameter as 0.5±0.01 (take all uncertainties as 95%)
% and the throat diameter as 0.1±0.005
d1in = UncVal(0.5, 0.01/2, "d1"); % divide by two to provide 1-sigma unc.
d2in = UncVal(0.1, 0.005/2, "d2");

% convert to ft, we'll use a slug-ft-s system
d1 = d1in./12;
d2 = d2in./12;

% calculate areas
a1 = pi./4.*d1.^2;
a2 = pi./4.*d2.^2;

% we use the temperature to calculate density
t1 = UncVal(70, 4/2, "t1"); % degF
rho_lbm = 62.36 + (52.22-62.36)./(80-60).*(t1 - 60);
rho = rho_lbm/32.174; % convert to slugs/ft3

% calculate volumetric flow from our pressure measurements
p1_psi = UncVal(60.0, 0.5/2, "p1");
p2_psi = UncVal(50.0, 0.5/2, "p2");
p1 = p1_psi*144; % convert to psf
p2 = p2_psi*144;
q = a2.*sqrt(2.*(p1-p2)./rho./(1-(a2./a1).^2));

% convert to mass flow
w = q*rho;

% and into normal units
w_lbm = w*32.174;
fprintf("w = %.3f ± %.3f lbm/s\n", w_lbm, 2*w_lbm.unc()); % printing 95% confidence

% print a table with the sources of variance and their relative
% contributions
fprintf("\nRelative sources of variance:\n");
srcs = w_lbm.var_srcs();
disp(srcs);

% and we can make a pareto plot of these variances
figure;
w_lbm.pareto(1);
title("Sources of Variance")