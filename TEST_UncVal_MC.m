% T
classdef TEST_UncVal_MC < matlab.unittest.TestCase
    
    properties (Constant)
        NUM_MC = 1e6;
        ABS_TOL = 1e-5;
        REL_TOL = 1e-5;
        NUM = 20; % number of points for each range
    end
    
    properties (TestParameter)
        s = {1e-5}

        % unary functions to test with MC that are good everywhere
        x = num2cell(linspace(-1e2, 1e2, TEST_UncVal_MC.NUM));
        ufuncs = {@cos, @cosd, @deg2rad, @rad2deg, @sin, @sind};

        % some functions are only good positive
        xpos = num2cell(linspace(0.1, 1e2, TEST_UncVal_MC.NUM));
        ufuncspos = {@log, @log10, @sqrt};

        % for discontinuous trig functions we need test more narrow ranges
        xtan = num2cell(linspace(-1, 1, TEST_UncVal_MC.NUM));
        xsec = num2cell(linspace(-1, 1, TEST_UncVal_MC.NUM));
        xcsc = num2cell(linspace(0.5, 2.5, TEST_UncVal_MC.NUM));
        xcot = num2cell(linspace(0.5, 2.5, TEST_UncVal_MC.NUM));
        xasin = num2cell(linspace(-0.9, 0.9, TEST_UncVal_MC.NUM));
        xacos = num2cell(linspace(-0.9, 0.9, TEST_UncVal_MC.NUM));

        % exponential needs to have a limited range, it gets big fast
        xexp = num2cell(linspace(-1e3, log(500), TEST_UncVal_MC.NUM));
    end

    
    methods(TestClassSetup)
        % Shared setup for the entire test class
    end
    
    methods(TestMethodSetup)
        % Setup for each test
    end

    methods(Static)
        function out = isClose(a, b)
            tol = 0.5*(abs(a)+abs(b)).*TEST_UncVal_MC.REL_TOL + TEST_UncVal_MC.ABS_TOL;
            out = all(abs(a-b) < tol); 
        end
    end
    
    methods(Test)
        % Test methods
        
        function unimplementedTest(testCase)
            testCase.verifyFail("Unimplemented test");
        end
        function testMC(tc, ufuncs, x, s)
            % test functions that are good over a full range of inputs
            % first propagate uncertainty linearly
            x1 = UncVal(x, s, "x1");
            y1 = ufuncs(x1);

            % then propagate uncertainty with MC
            x2 = x + randn([1, 1e6]).*s;
            y2 = ufuncs(x2);

            % check average and variance
            tc.verifyTrue(tc.isClose(y1.val, mean(y2)));
            tc.verifyTrue(tc.isClose(var(y1), var(y2)));
    
        end
        function testPos(tc, ufuncspos, xpos, s)
            % test functions that are only valid for positive values

            % first propagate uncertainty linearly
            x1 = UncVal(xpos, s, "x1");
            y1 = ufuncspos(x1);

            % then propagate uncertainty with MC
            x2 = xpos + randn([1, 1e6]).*s;
            y2 = ufuncspos(x2);

            % check average and variance
            tc.verifyTrue(tc.isClose(y1.val, mean(y2)));
            tc.verifyTrue(tc.isClose(var(y1), var(y2)));
    
        end
        function testTan(tc, xtan, s)
            % first propagate uncertainty linearly
            x1 = UncVal(xtan, s, "x1");
            y1 = tan(x1);

            % then propagate uncertainty with MC
            x2 = xtan + randn([1, 1e6]).*s;
            y2 = tan(x2);

            % check average and variance
            tc.verifyTrue(tc.isClose(y1.val, mean(y2)));
            tc.verifyTrue(tc.isClose(var(y1), var(y2)));
        end
        function testSec(tc, xsec, s)
            % first propagate uncertainty linearly
            x1 = UncVal(xsec, s, "x1");
            y1 = sec(x1);

            % then propagate uncertainty with MC
            x2 = xsec + randn([1, 1e6]).*s;
            y2 = sec(x2);

            % check average and variance
            tc.verifyTrue(tc.isClose(y1.val, mean(y2)));
            tc.verifyTrue(tc.isClose(var(y1), var(y2)));
        end
        function testCsc(tc, xcsc, s)
            % first propagate uncertainty linearly
            x1 = UncVal(xcsc, s, "x1");
            y1 = csc(x1);

            % then propagate uncertainty with MC
            x2 = xcsc + randn([1, 1e6]).*s;
            y2 = csc(x2);

            % check average and variance
            tc.verifyTrue(tc.isClose(y1.val, mean(y2)));
            tc.verifyTrue(tc.isClose(var(y1), var(y2)));
        end
        function testCot(tc, xcot, s)
            % first propagate uncertainty linearly
            x1 = UncVal(xcot, s, "x1");
            y1 = cot(x1);

            % then propagate uncertainty with MC
            x2 = xcot + randn([1, 1e6]).*s;
            y2 = cot(x2);

            % check average and variance
            tc.verifyTrue(tc.isClose(y1.val, mean(y2)));
            tc.verifyTrue(tc.isClose(var(y1), var(y2)));
        end
        function testExp(tc, xexp, s)
            % first propagate uncertainty linearly
            x1 = UncVal(xexp, s, "x1");
            y1 = exp(x1);

            % then propagate uncertainty with MC
            x2 = xexp + randn([1, 1e6]).*s;
            y2 = exp(x2);

            % check average and variance
            tc.verifyTrue(tc.isClose(y1.val, mean(y2)));
            tc.verifyTrue(tc.isClose(var(y1), var(y2)));
        end
    end
    
end