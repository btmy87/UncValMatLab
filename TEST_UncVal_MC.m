% T
classdef TEST_UncVal_MC < matlab.unittest.TestCase
    
    properties (Constant)
        NUM_MC = 1e6; % number of points for MC propagation
        ABS_TOL = 1e-5;
        REL_TOL = 1e-5;
    end
    
    properties (TestParameter)
        s = {1e-5}

        % unary functions to test over a range
        % `x` is a normalized number, that will walk from min to max
        x = num2cell(linspace(0, 1, 11));
        
        % each element of fun is a cell array with 3 items
        %  1. a function handle to a unary function
        %  2. min value for testing
        %  3. max value for testing
        % this way we have a common test function and vector, but can avoid
        % discontinuties in functions.
        fun = { {@asin                        , -0.9 , 0.9     }, ...
                {@asind                       , -0.9 , 0.9     }, ...
                {@acos                        , -0.9 , 0.9     }, ...
                {@acosd                       , -0.9 , 0.9     }, ...
                {@atan                        , -2   , 2       }, ...
                {@atand                       , -2   , 2       }, ...
                {@cos                         , -10  , 10      }, ...
                {@cosd                        , -10  , 10      }, ...
                {@cot                         , 0.5  , 2.5     }, ...
                {@cotd                        , 0.5  , 2.5     }, ...
                {@csc                         , 0.5  , 2.5     }, ...
                {@cscd                        , 0.5  , 2.5     }, ...
                {@deg2rad                     , -1000, 1000    }, ...
                {@exp                         , -1000, log(500)}, ...
                {@log                         ,  0.1 , 1000    }, ...
                {@log10                       ,  0.1 , 1000    }, ...
                {@rad2deg                     , -10  , 10      }, ...
                {@sec                         , -1   , 1       }, ...
                {@secd                        , -1   , 1       }, ...
                {@sin                         , -10  , 10      }, ...
                {@sind                        , -10  , 10      }, ...
                {@sqrt                        ,  0.1 , 1000    }, ...
                {@tan                         , -1   , 1       }, ...
                {@tand                        , -1   , 1       }, ...
                {@uminus                      , -1000, 1000    }, ...
                {@uplus                       , -1000, 1000    }, ...
                {@(x) x + 1                   , -1000, 1000    }, ...
                {@(x) x.*2                    , -1000, 1000    }, ...
                {@(x) x./2                    , -1000, 1000    }, ...
                {@(x) x*2                     , -1000, 1000    }, ...
                {@(x) x/2                     , -1000, 1000    }, ...
                {@(x) x.^2                    , 0.1  , 10      }, ... % will fail MC check right at zero
                {@(x) (x-1)./(x+1)            , -0.5 , 5       }, ...
                {@(x) sqrt(x.^3+3.*x+3)       , 0.1  , 10      }, ...
                {@(x) sqrt(tan(x.^2).^3)      , 0.1  , 1       }, ...
                {@(x) x.*x                    , 0.1  , 10      }, ...
                {@(x) x./x                    , 0.1  , 10      }, ...
              };

        % test cases for binary functions
        % fun2 is a cell array of cell arrays, each element has 5 pieces
        % 1. binary function handl3
        % 2. xmin
        % 3. xmax
        % 4. ymin
        % 5. ymax
        y = num2cell(linspace(0, 1, 11));
        fun2 = {...
            {@(x,y) x+y        , -10, 10, -10, 10}, ...
            {@(x,y) x-y        , -10, 10, -10, 10}, ...
            {@(x,y) x.*y       , 0.1, 10, 0.1, 10}, ... % expect zero might be trouble
            {@(x,y) x./y       , -10, 10, 0.1, 10}, ...
            {@(x,y) x.^y       , 0.1, 10, 0.1, 5 }, ...
          };
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
        
        function testMC(tc, fun, x, s)
            f = fun{1};
            x0 = fun{2} + x.*(fun{3}-fun{2});

            % first propagate uncertainty linearly
            x1 = UncVal(x0, s, "x1");
            y1 = f(x1);

            % then propagate uncertainty with MC
            x2 = x1.val + randn([1, 1e6]).*s;
            y2 = f(x2);

            % check average and variance
            tc.verifyTrue(tc.isClose(y1.val, mean(y2)));
            tc.verifyTrue(tc.isClose(var(y1), var(y2)));
            tc.verifyTrue(tc.isClose(unc(y1), std(y2)));
            tc.verifyInstanceOf(string(y1), "string");
    
        end

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
            tc.verifyTrue(tc.isClose(z1.val, mean(z2)));
            tc.verifyTrue(tc.isClose(var(z1), var(z2)));
            tc.verifyTrue(tc.isClose(unc(z1), std(z2)));
            tc.verifyInstanceOf(string(z1), "string");
    
        end

    end
    
end