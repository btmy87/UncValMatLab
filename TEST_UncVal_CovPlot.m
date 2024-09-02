% example for plotting 2D correlated variables

%% Test Plot correlated variables
x = UncVal(1, 0.2, "x");
y = UncVal(2, 0.1, "y");
z = x + 1.5.*y;
z2 = x - 1.5.*y;

xmc = x.val + randn(1, 2e3).*x.unc();
ymc = y.val + randn(size(xmc)).*y.unc();
zmc = xmc + 1.5.*ymc;
z2mc = xmc - 1.5.*ymc;

figure(Name="CovPlot", Units="in", Position=[1,1,9,4]);
tiledlayout("flow")
ha = nexttile;hold on;
xlabel("x"); ylabel("y");
scatter(xmc, ymc, "filled", ...
    MarkerFaceAlpha=50/255, ...
    MarkerEdgeColor="none");
errorbar(x, y, SDEpatch=true); 

nexttile;hold on;
xlabel("y");ylabel("z");
scatter(ymc, zmc, "filled", ...
    MarkerFaceAlpha=50/255, ...
    MarkerEdgeColor="none");
errorbar(y, z); 

nexttile;hold on;
xlabel("y");ylabel("z2");
scatter(ymc, z2mc, "filled", ...
    MarkerFaceAlpha=50/255, ...
    MarkerEdgeColor="none");
errorbar(y, z2); 

nexttile;hold on;
xlabel("x");ylabel("x");
scatter(xmc, xmc, "filled", ...
    MarkerFaceAlpha=50/255, ...
    MarkerEdgeColor="none");
errorbar(x, x , LineWidth=2); 

%% Test PDF2

x = UncVal(1, 0.2, "x");
y = UncVal(2, 0.1, "y");
z = x + 1.5.*y;
xmc = x.val + randn(1, 2e3).*x.unc();
ymc = y.val + randn(size(xmc)).*y.unc();
zmc = xmc + 1.5.*ymc;

[p, yi, zi] = pdf2(y, z);

figure(Name="PDF2", Units="in", Position=[1,1,9,4]);
t = tiledlayout("flow");
ha = nexttile;hold on;
xlabel("y"); ylabel("z");
scatter(ymc, zmc, "filled", ......
    MarkerFaceAlpha=50/255, ...
    MarkerEdgeColor="none");
c = 0.5*ha.Color + 0.5*ha.ColorOrder(3, :);
contour(yi, zi, p, 8, Color=c);
errorbar(y, z, Color=ha.ColorOrder(2, :), LineStyle="--"); 

ha = nexttile; hold on;
xlabel("y"); ylabel("z"); zlabel("p");
surf(yi, zi, p, FaceAlpha=0.5);
view(3);

linkaxes(t.Children, "xy");