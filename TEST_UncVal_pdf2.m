% TEST_UncVal_pdf2.m
% test cases for pdf2

classdef TEST_UncVal_pdf2 < matlab.unittest.TestCase
    properties (Constant)
        ABS_TOL = 1e-4;
        REL_TOL = 1e-4;
    end

    methods
        function verifyClose(testCase, a, b)
            tol = 0.5*(abs(a)+abs(b)).*TEST_UncVal_MC.REL_TOL + TEST_UncVal_MC.ABS_TOL;
            verifyTrue(testCase, all(abs(a-b) < tol)); 
        end
    end

    methods(Test)
        function test_types(tc)
            % test argument types
            x = UncVal(0, 1, "x");
            y = UncVal(0, 2, "y");

            [p, xi, yi, f] = pdf2(x, y);

            tc.verifyClass(p, "double");
            tc.verifyClass(xi, "double");
            tc.verifyClass(yi, "double");
            tc.verifyClass(f, "function_handle");
        end

        function test_basic(tc)
            % test with basic, uncorrelated inputs
            x = UncVal(0, 1, "x");
            y = UncVal(0, 2, "y");

            [~, ~, ~, f] = pdf2(x, y);
            p0 = 1.0./(4.0.*pi);
            tc.verifyClose(f(0, 0), p0);

            p1 = p0.*exp(-0.5*1);
            tc.verifyClose(f( 1,  0), p1);
            tc.verifyClose(f(-1,  0), p1);
            tc.verifyClose(f( 0,  2), p1);
            tc.verifyClose(f( 0, -2), p1);
        end

        function test_offset(tc)
            % test with basic, uncorrelated inputs, non-zero center
            x = UncVal(1, 1, "x");
            y = UncVal(2, 2, "y");

            [~, ~, ~, f] = pdf2(x, y);
            p0 = 1.0./(4.0.*pi);
            tc.verifyClose(f(1, 2), p0);

            p1 = p0.*exp(-0.5*1);
            tc.verifyClose(f( 2,  2), p1);
            tc.verifyClose(f( 0,  2), p1);
            tc.verifyClose(f( 1,  4), p1);
            tc.verifyClose(f( 1,  0), p1);
        end

        function test_corr(tc)
            % test with partially correlated inputs
            % correlation coefficient is 1/sqrt(2)
            x = UncVal(0, 1, "x");
            y = UncVal(0, 1, "y") + x;

            [~, ~, ~, f] = pdf2(x, y);
            p0 = 1.0./(2.0.*pi);
            tc.verifyClose(f(0, 0), p0);

            p1 = p0.*exp(-1);
            tc.verifyClose(f( 1,  0), p1);
            tc.verifyClose(f(-1,  0), p1);
            tc.verifyClose(f( 0,  sqrt(2)), p1);
            tc.verifyClose(f( 0, -sqrt(2)), p1);

        end

        function test_no_variance(tc)
            % should error if no variance
            x = UncVal(0, 1, "x");
            y = UncVal(0, 0, "y");

            tc.verifyError(@() pdf2(x, y), "UncVal:NotSupported");
            tc.verifyError(@() pdf2(y, x), "UncVal:NotSupported");
            tc.verifyError(@() pdf2(y, y), "UncVal:NotSupported");
        end
        function test_perfect_corr(tc)
            % should produce an error if perfectly correlated
            x = UncVal(0, 1, "x");
            y = x;
            tc.verifyError(@() pdf2(x, y), "UncVal:NotSupported");
        end
    end
end