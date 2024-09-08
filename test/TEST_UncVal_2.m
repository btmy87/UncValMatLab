%example_UncVal_2
% plot some UncVals
% the regular 'plot' command just plots the values
% the errorbar command automatically plots error bars at ±2*x.unc()
if exist("UncVal", "class") < 1
    % need to add path to parent folder
    dir = string(fileparts(mfilename("fullpath")));
    addpath(fullfile(dir, ".."));
end
%% Test 2
x = UncVal(linspace(0, 1, 8), 0.02, "x");
y = x.^2 + UncVal(0, 0.04, "y");

figure("defaultErrorBarLineWidth", 1.5, ...
    "Units", "in", "Position", [1,1,6,4]);
t = tiledlayout("flow");
title(t, "UncVal Plotting Options");
nexttile;hold on;xlabel("x");ylabel("y");
title("plot command", FontWeight="normal");
plot(x, y);

t.Title.Color = get(gca, "XColor"); % I have some funny defaults

ha = nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, x-only", FontWeight="normal")
errorbar(x, y.val, Marker="o", MarkerFaceColor=ha.Color);

nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, y-only", FontWeight="normal")
errorbar(x.val, y, Marker="d", MarkerFaceColor=ha.Color);

nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, x and y", FontWeight="normal")
errorbar(x, y);
