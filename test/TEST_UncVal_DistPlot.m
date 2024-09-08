% test UncVal plots for PDF and CDF
if exist("UncVal", "class") < 1
    % need to add path to parent folder
    dir = string(fileparts(mfilename("fullpath")));
    addpath(fullfile(dir, ".."));
end
%% Test distribution plot
x = UncVal(0, 1, "x"); % Standard normal disturbution
[yp, xp] = pdf(x);
[yc, xc] = cdf(x);

figure(Name="Distribution Plots");
ha = axes;hold on;
yyaxis left
xlabel("x");
ylabel("PDF");
plot(xp, yp);

yyaxis right
ylabel("CDF");
plot(xc, yc);

ha.YAxis(1).Limits = [0, 0.4];
ha.YAxis(1).TickValues = 0:0.1:0.4;
ha.YAxis(2).Limits = [0, 1];
ha.YAxis(2).TickValues = 0:0.25:1;