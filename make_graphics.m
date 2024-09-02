% make_graphics.m
% makes graphics for readme file.

x = UncVal(linspace(0, 1, 8), 0.02, "x");
y = x.^2 + UncVal(0, 0.04, "y");

%% Make light plot
figure(Name="light", ...
    Color="w", ...
    defaultAxesColor="w", ...
    defaultAxesXColor=[0.15, 0.15, 0.15], ...
    defaultAxesYColor=[0.15, 0.15, 0.15], ...
    defaultAxesGridColor=[0.15, 0.15, 0.15], ...
    defaultAxesXGrid="on", ...
    defaultAxesYGrid="on", ...
    defaultAxesBox="on", ...
    defaultTextColor=[0.15, 0.15, 0.15], ...
    defaultAxesFontSize=14, ...
    defaultErrorBarLineWidth=1.5, ...
    defaultLineLineWidth=1.5, ...
    defaultLineMarkerFaceColor="w", ...
    defaultAxesLineWidth=1.5, ...
    defaultAxesGridLineWidth=1.0, ...
    defaultAxesGridAlpha=0.3, ...
    Units="pixels", ...
    Position=[10, 10, 800, 500]);

t = tiledlayout("flow", padding="compact", TileSpacing="compact");
title(t, "UncVal Plotting Options", FontSize=14);
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

if ~exist("resources", "dir")
    mkdir("resources");
end
write_png(gcf, "resources/light.png");

%% Make dark plot
figure(Name="dark", ...
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
    Units="pixels", ...
    Position=[10, 10, 800, 500]);

t = tiledlayout("flow", padding="compact", TileSpacing="compact");
title(t, "UncVal Plotting Options", FontSize=14);
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

write_png(gcf, "resources/dark.png");

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

% smooth
a = smooth3(a, "box", [3, 3, 1]);
alpha2 = repmat(alpha, 1, 1, 3); % fake in a 3rd dimension
alpha3 = smooth3(alpha2, "box", [3, 3, 1]);
alpha4 = squeeze(alpha3(:, :, 1)); % remove fake dimension

imwrite(a, filename, Alpha=alpha4);

end
