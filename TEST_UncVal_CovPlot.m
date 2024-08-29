% example for plotting 2D correlated variables

%% Test Plot correlated variables
x = UncVal(1, 0.2, "x");
y = UncVal(2, 0.1, "y");
z = x + 1.5*y;

xmc = x.val + randn(1, 2e3).*x.unc();
ymc = y.val + randn(size(xmc)).*y.unc();
zmc = xmc + 1.5.*ymc;

figure(Units="in", Position=[1,1,9,4]);
tiledlayout("flow")
ha = nexttile;hold on;
xlabel("x"); ylabel("y");
scatter(xmc, ymc, "filled", ...
    MarkerFaceAlpha=50/255, ...
    MarkerEdgeColor="none");
errorbar(x, y, ...
    FaceAlpha=0.3, ...
    FaceColor=ha.ColorOrder(2, :), ...
    EdgeColor=ha.ColorOrder(2, :)); 
% axis equal

nexttile;hold on;
xlabel("y");ylabel("z");
scatter(ymc, zmc, "filled", ...
    MarkerFaceAlpha=50/255, ...
    MarkerEdgeColor="none");
errorbar(y, z, ...
    FaceAlpha=0.3, ...
    FaceColor=ha.ColorOrder(2, :), ...
    EdgeColor=ha.ColorOrder(2, :)); 
% axis equal

