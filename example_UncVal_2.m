%example_UncVal_2
% plot some UncVals
% the regular 'plot' command just plots the values
% the errorbar command automatically plots error bars at ±2*x.unc()

x = UncVal(linspace(0, 1, 11), 0.05/2, "x");
y = x.^2;

figure("defaultErrorBarLineWidth", 1.5);
t = tiledlayout("flow");
title(t, "UncVal Plotting Options");
nexttile;hold on;xlabel("x");ylabel("y");
title("plot command", FontWeight="normal");
plot(x, y);

t.Title.Color = get(gca, "XColor"); % I have some funny defaults

ha = nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, x-only")
errorbar(x, y.val, Marker="o", MarkerFaceColor=ha.Color);

nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, y-only")
errorbar(x.val, y, Marker="d", MarkerFaceColor=ha.Color);

nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, x and y")
errorbar(x, y, CapSize=4);