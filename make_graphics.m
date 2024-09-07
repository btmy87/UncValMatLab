% make_graphics.m
% makes graphics for readme file.
close all
clear
clc

x = UncVal(linspace(0, 1, 8), 0.02, "x");
y = x.^2 + UncVal(0, 0.04, "y");

%% Make light plot
hf = figure(Name="light", ...
    Color="w", ...
    defaultAxesColor="w", ...
    defaultAxesXColor=[0.15, 0.15, 0.15], ...
    defaultAxesYColor=[0.15, 0.15, 0.15], ...
    defaultAxesGridColor=[0.15, 0.15, 0.15], ...
    defaultAxesXGrid="on", ...
    defaultAxesYGrid="on", ...
    defaultAxesBox="on", ...
    defaultTextColor=[0.15, 0.15, 0.15], ...
    defaultAxesFontSize=11, ...
    defaultErrorBarLineWidth=1.5, ...
    defaultLineLineWidth=1.5, ...
    defaultLineMarkerFaceColor="w", ...
    defaultAxesLineWidth=1.5, ...
    defaultAxesGridLineWidth=1.0, ...
    defaultAxesGridAlpha=0.3, ...
    defaultTextFontName="FixedWidth", ...
    defaultAxesFontName="FixedWidth", ...
    Units="pixels", ...
    Position=[10, 10, 800, 500]);

t = tiledlayout("flow", padding="compact", TileSpacing="compact");
title(t, "UncVal Plotting Options");
nexttile;hold on;xlabel("x");ylabel("y");
title("plot command", FontWeight="normal");
plot(x, y);

t.Title.Color = get(gca, "XColor"); % I have some funny defaults
t.Title.FontName = get(gca, "FontName");

ha = nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, x-only", FontWeight="normal")
errorbar(x, y.val, Marker="o", MarkerFaceColor=ha.Color);

nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, y-only", FontWeight="normal")
errorbar(x.val, y, Marker="d", MarkerFaceColor=ha.Color);

nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, x and y", FontWeight="normal")
errorbar(x, y);

if ~exist("resources", "dir")
    mkdir("resources");
end
% hf.Color = "none";
% set(findobj(hf, "Type", "Axes"), "Color", "none");
% print(hf, "resources/light.svg", "-dsvg");

delete("resources/opaque.svg");
print(hf, "resources/opaque.svg", "-dsvg");
opaqueLines = readlines("resources/opaque.svg");
lightLines = regexprep(opaqueLines, "fill:white", "fill:none");
writelines(lightLines, "resources/light.svg", WriteMode="overwrite");

% write_png(hf, "resources/light.png");
% saveas(hf, "resources/opaque.png");
% 
% hf.Color = "none";
% set(findobj(hf, "Type", "Axes"), "Color", "none");


%% Make dark plot
hf = figure(Name="dark", ...
    Color=[0, 0, 0], ...
    defaultAxesColor=[0, 0, 0], ...
    defaultAxesXColor=[1,1,1].*230/255, ...
    defaultAxesYColor=[1,1,1].*230/255, ...
    defaultAxesGridColor=[1,1,1].*230/255, ...
    defaultAxesXGrid="on", ...
    defaultAxesYGrid="on", ...
    defaultAxesBox="on", ...
    defaultTextColor=[1,1,1].*230/255, ...
    defaultAxesFontSize=14, ...
    defaultErrorBarLineWidth=1.5, ...
    defaultLineLineWidth=1.5, ...
    defaultLineMarkerFaceColor=[1,1,1].*20/255, ...
    defaultAxesLineWidth=1.5, ...
    defaultAxesGridLineWidth=1.0, ...
    defaultAxesGridAlpha=0.3, ...
    defaultTextFontName="FixedWidth", ...
    defaultAxesFontName="FixedWidth", ...
    InvertHardcopy="off", ...
    Units="pixels", ...
    Position=[10, 10, 800, 500]);

t = tiledlayout("flow", padding="compact", TileSpacing="compact");
title(t, "UncVal Plotting Options", FontSize=14);
nexttile;hold on;xlabel("x");ylabel("y");
title("plot command", FontWeight="normal");
plot(x, y);

t.Title.Color = get(gca, "XColor"); % I have some funny defaults
t.Title.FontName = get(gca, "FontName");

ha = nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, x-only", FontWeight="normal")
errorbar(x, y.val, Marker="o", MarkerFaceColor=ha.Color);

nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, y-only", FontWeight="normal")
errorbar(x.val, y, Marker="d", MarkerFaceColor=ha.Color);

nexttile;hold on;xlabel("x");ylabel("y");
title("errorbar, x and y", FontWeight="normal")
errorbar(x, y);

% write_png(gcf, "resources/dark.png");
delete("resources/dark.svg");
print(hf, "resources/dark.svg", "-dsvg");
tempLines = readlines("resources/dark.svg");
darkLines = regexprep(tempLines, "fill:black", "fill:none");
writelines(darkLines, "resources/dark.svg", WriteMode="overwrite");

%% Utility function
function write_png(hf, filename)
% function to write a png with a transparent figure background
% ideal for publishing to github

imdata = getframe(hf);
a = double(imdata.cdata)./255.0;
cref = reshape(hf.Color, [1, 1, 3]);
alpha = ones(size(a, [1, 2]));
idx = all(a == cref, 3);
alpha(idx) = 0;

imwrite(a, filename, Alpha=alpha);

end
