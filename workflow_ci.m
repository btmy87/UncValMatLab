% workflow_ci
% using this script instead of default test workflow
% want more control over reporting the results

% make a directory for test results
mkdir('test-results');

% set these outputs up top incase anything fails catastrophically
out = struct();
out.CI_TEST_PASSED = "Not Run";
out.CI_TEST_COLOR = "#A2142F";
out.CI_COVERAGE = "Not Run";
out.CI_COVERAGE_COLOR = "#A2142F";
out.CI_WARNINGS = "Not Run";
out.CI_ERRORS = "Not Run";
out.CI_WARNINGS_COLOR = "#A2142F";
out.CI_ERRORS_COLOR = "#A2142F";
writestruct(out, "test-results/summary.json", PrettyPrint=false);

import matlab.unittest.TestRunner;
import matlab.unittest.plugins.TestReportPlugin
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.XMLPlugin;
import matlab.unittest.plugins.codecoverage.CoberturaFormat;

% create a test suite and runner
suite = testsuite();
runner = TestRunner.withTextOutput();

% add test report plugin
reportPlugin = XMLPlugin.producingJUnitFormat('test-results/results.xml');
runner.addPlugin(reportPlugin);

% add code coverage plugin
format = CoberturaFormat('test-results/coverage.xml');
coveragePlugin = CodeCoveragePlugin.forFolder({'@UncVal'}, ...
    'IncludingSubfolders', true, ...
    'Producing', format);
runner.addPlugin(coveragePlugin);

% Run tests
results = runner.run(suite);
display(results);

% save test result info to environment variables for dynamic badge
totalPass = sum([results.Passed]);
totalFail = sum([results.Failed] | [results.Incomplete]);
out.CI_TEST_PASSED = totalPass + " of " + length(results);

tempColor = "#D95319"; % red
if totalPass == length(results)
    tempColor = "#77AC30"; % green
end
out.CI_TEST_COLOR = tempColor;

% save coverage result to environment variable for dynamic badge
c = readstruct("test-results/coverage.xml");
covRate = c.line_rateAttribute*100.0;
out.CI_COVERAGE = sprintf("%.1f%%", covRate);

tempColor = "#77AC30"; % green
if covRate < 70
    tempColor = "#D95319"; % red
elseif covRate < 90
    tempColor = "#EDB120"; % yellow
end
out.CI_COVERAGE_COLOR = tempColor;

% look for code issues and update structure
issues = codeIssues();
numWarnings = sum(issues.Issues.Severity == "warning" ...
                      | issues.Issues.Severity == "info");
numErrors = sum(issues.Issues.Severity == "error");
out.CI_WARNINGS = sprintf("%.0f", numWarnings);
if numWarnings > 0
    out.CI_WARNINGS_COLOR = "#EDB120"; % yellow
else
    out.CI_WARNINGS_COLOR = "#77AC30"; % green
end

out.CI_ERRORS = sprintf("%.0f", numErrors);
if numErrors > 0
    out.CI_ERRORS_COLOR = "#D95319"; % red
else
    out.CI_ERRORS_COLOR = "#77AC30"; % green
end

% convert errors and warnings to strings


writestruct(out, "test-results/summary.json", PrettyPrint=false);

assertSuccess(results);