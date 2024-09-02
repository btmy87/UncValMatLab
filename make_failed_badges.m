% make_failed_badges
% we'll store copies of failing badges in the resources
% we'll default to these badges unless overwritten by other artifacts

arch = ["GLNXA64", "PCWIN64"];
vers = ["R2024a", "R2022b"];
badges = ["coverage", "tests", "errors", "warnings"];
labels = ["Coverage", "Tests Passed", "Errors", "Warnings"];
color = "#A2142F";
msg = "Not Run";

if ~exist("resources", "dir")
    mkdir("resources");
end
if ~exist("resources/failed", "dir")
    mkdir("resources/failed");
end
if ~exist("resources/success", "dir")
    mkdir("resources/success");
end

for i1 = 1:length(arch)
    for i2 = 1:length(vers)
        for i3 = 1:length(badges)
            filename = sprintf("resources/failed/%s-%s-%s.svg", ...
                arch(i1), vers(i2), badges(i3));
            get_badge(labels(i3), msg, color, filename);
        end
    end
end

get_badge("CI", "Workflow Failed", color, "resources/failed/ci.svg");
get_badge("CI", "Workflow Completed", "#77AC30", "resources/success/ci.svg");
