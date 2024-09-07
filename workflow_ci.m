% workflow_ci
% using this script instead of default test workflow
% want more control over reporting the results

% start fresh
close all;
clear classes; %#ok<CLCLS>
clc

% add path
% test running seems to run from within the test folder
addpath(pwd); 

% make a directory for test results
if ~exist("test-results", "dir")
    mkdir("test-results");
end

% set these outputs up top incase anything fails catastrophically
out = struct();
out.CI_TEST_PASSED = "Not Run";
out.CI_COVERAGE = "Not Run";
out.CI_WARNINGS = "Not Run";
out.CI_ERRORS = "Not Run";

import matlab.unittest.TestRunner;
import matlab.unittest.plugins.TestReportPlugin
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.XMLPlugin;
import matlab.unittest.plugins.codecoverage.CoberturaFormat;

% create a test suite and runner
suite = testsuite([".", "test"]);
runner = TestRunner.withTextOutput();

% add test report plugin
reportPlugin = XMLPlugin.producingJUnitFormat('test-results/results.xml');
runner.addPlugin(reportPlugin);

% add code coverage plugin
format = CoberturaFormat("test-results/coverage.xml");
coveragePlugin = CodeCoveragePlugin.forFolder("@UncVal", ...
    IncludingSubfolders=true, ...
    Producing=format);
runner.addPlugin(coveragePlugin);

% Run tests
results = runner.run(suite);
display(results);

% save test result info to environment variables for dynamic badge
totalPass = sum([results.Passed]);
totalFail = sum([results.Failed] | [results.Incomplete]);
out.CI_TEST_PASSED = totalPass + " of " + length(results);

% save coverage result to environment variable for dynamic badge
c = readstruct("test-results/coverage.xml");
covRate = c.line_rateAttribute*100.0;
out.CI_COVERAGE = sprintf("%.1f%%", covRate);

% look for code issues and update structure
issues = codeIssues();
numWarnings = sum(issues.Issues.Severity == "warning" ...
                      | issues.Issues.Severity == "info");
numErrors = sum(issues.Issues.Severity == "error");
out.CI_WARNINGS = sprintf("%.0f", numWarnings);
out.CI_ERRORS = sprintf("%.0f", numErrors);

display(issues);

%writestruct(out, "test-results/summary.json", PrettyPrint=false);

% print out summary info for the GitHub Actions log
display(matlabRelease)
disp(out);

% maybe we don't want to show workflow as failed
assertSuccess(results);