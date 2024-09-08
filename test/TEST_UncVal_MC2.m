
classdef TEST_UncVal_MC2 < matlab.unittest.TestCase
    % Test cases for 2-variable Monte-Carlos
    
    properties (Constant)
        NUM_MC = 1e6; % number of points for MC propagation
        ABS_TOL = 1e-4;
        REL_TOL = 1e-4;
    end
    
    properties (TestParameter)
        s = {1e-5}

        % unary functions to test over a range
        % `x` is a normalized number, that will walk from min to max
        x = num2cell(linspace(0, 1, 11));
    
        % test cases for binary functions
        % fun2 is a cell array of cell arrays, each element has 5 pieces
        % 1. binary function handl3
        % 2. xmin
        % 3. xmax
        % 4. ymin
        % 5. ymax
        y = num2cell(linspace(0, 1, 11));
        fun2 = {...
            {@(x,y) x+y         , -10,  10, -10, 10}, ...
            {@(x,y) x-y         , -10,  10, -10, 10}, ...
            {@(x,y) x.*y        , 0.1,  10, 0.1, 10}, ... % expect zero might be trouble
            {@(x,y) x./y        , -10,  10, 0.1, 10}, ...
            {@(x,y) x.^y        , 0.1,  5 , 0.1, 5 }, ...
            {@(x,y) atan2(y, x) , 0.1,  5 ,  -4, 5 }, ... % y = 0 would be trouble
            {@(x,y) atan2(y, x) , -5 ,-0.1,  -4, 5 }, ...
            {@(x,y) atan2d(y, x), 0.1,  5 ,  -4, 5 }, ... % y = 0 would be trouble
            {@(x,y) atan2d(y, x), -5 ,-0.1,  -4, 5 }, ...
          };
    end

    
    methods(TestClassSetup)
        % Shared setup for the entire test class
        function setup_path(~)
            if exist("UncVal", "class") < 1
                % need to add path to parent folder
                dir = string(fileparts(mfilename("fullpath")));
                addpath(fullfile(dir, ".."));
            end
        end

    end
    
    methods(TestMethodSetup)
        % Setup for each test
    end

    methods
        function verifyClose(testCase, a, b)
            tol = 0.5*(abs(a)+abs(b)).*testCase.REL_TOL + testCase.ABS_TOL;
            msg = "verifyClose failed";
            if isscalar(a) && isscalar(b)
                msg = sprintf("|a-b| = %.14g, tol = %.14g\n" + ...
                        "a=%.14g, b=%.14g", ...
                        abs(a-b), tol, a, b);
            end
            verifyTrue(testCase, all(abs(a-b) < tol), msg); 
        end
    end
    
    methods(Test)
        % Test methods
        
        function testMC2(tc, fun2, x, y, s)
            f = fun2{1};
            x0 = fun2{2} + x.*(fun2{3}-fun2{2});
            y0 = fun2{4} + y.*(fun2{5}-fun2{4});

            % first propagate uncertainty linearly
            x1 = UncVal(x0, s, "x1");
            y1 = UncVal(y0, s, "y1");
            z1 = f(x1, y1);

            % then propagate uncertainty with MC
            x2 = x1.val + randn([1, 1e6]).*s;
            y2 = y1.val + randn([1, 1e6]).*s;
            z2 = f(x2, y2);

            % check average and variance
            tc.verifyClose(z1.val, mean(z2));
            tc.verifyClose(var(z1), var(z2));
            tc.verifyClose(unc(z1), std(z2));
            tc.verifyInstanceOf(string(z1), "string");
    
        end

    end
    
end