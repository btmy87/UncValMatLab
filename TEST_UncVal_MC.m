
classdef TEST_UncVal_MC < matlab.unittest.TestCase
    % Test cases for single-variable Monte-Carlos
    
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
        
        % each element of fun is a cell array with 3 items
        %  1. a function handle to a unary function
        %  2. min value for testing
        %  3. max value for testing
        % this way we have a common test function and vector, but can avoid
        % discontinuties in functions.
        fun = { {@asin                        , -0.9 , 0.9     }, ...
                {@asind                       , -0.9 , 0.9     }, ...
                {@asinh                       , -3   , 3       }, ...
                {@acos                        , -0.9 , 0.9     }, ...
                {@acosd                       , -0.9 , 0.9     }, ...
                {@acosh                       , 1.5  , 3.0     }, ...
                {@acosh                       , -3.0 , -1.5    }, ...
                {@acoth                       , -3.0 , -1.2    }, ...
                {@acoth                       ,  1.2 ,  3.0    }, ...
                {@acsch                       , -3.0 , -0.2    }, ...
                {@acsch                       ,  0.2 ,  3.0    }, ...
                {@asech                       , -0.9 , -0.2    }, ...
                {@asech                       ,  0.2 ,  0.9    }, ...
                {@atan                        , -2   , 2       }, ...
                {@atand                       , -2   , 2       }, ...
                {@atanh                       , -0.8 , 0.8     }, ...
                {@atanh                       , 1.5  , 3.0     }, ...
                {@cos                         , -10  , 10      }, ...
                {@cosd                        , -10  , 10      }, ...
                {@cosh                        , -3   , 3       }, ...
                {@cospi                       , -2   , 2       }, ...
                {@cot                         , 0.5  , 2.5     }, ...
                {@cotd                        , 0.5  , 2.5     }, ...
                {@coth                        , 0.5  , 2.5     }, ...
                {@csc                         , 0.5  , 2.5     }, ...
                {@cscd                        , 0.5  , 2.5     }, ...
                {@csch                        , 0.5  , 2.5     }, ...
                {@deg2rad                     , -1000, 1000    }, ...
                {@exp                         , -1000, log(500)}, ...
                {@log                         ,  0.1 , 1000    }, ...
                {@log10                       ,  0.1 , 1000    }, ...
                {@rad2deg                     , -10  , 10      }, ...
                {@sec                         , -1   , 1       }, ...
                {@secd                        , -1   , 1       }, ...
                {@sech                        , -3   , 3       }, ...
                {@sin                         , -10  , 10      }, ...
                {@sind                        , -10  , 10      }, ...
                {@sinh                        , -3   , 3       }, ...
                {@sinpi                       , -2   , 2       }, ...
                {@sqrt                        ,  0.1 , 1000    }, ...
                {@tan                         , -1   , 1       }, ...
                {@tand                        , -1   , 1       }, ...
                {@tanh                        , -3   , 3       }, ...
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

    end

    
    methods(TestClassSetup)
        % Shared setup for the entire test class
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
        
        function testMC(tc, fun, x, s)
            f = fun{1};
            x0 = fun{2} + x.*(fun{3}-fun{2});
            tc.onFailure(sprintf("testMC failed with %s at x0=%.14g", ...
                func2str(f), x0));

            % first propagate uncertainty linearly
            x1 = UncVal(x0, s, "x1");
            y1 = f(x1);

            % then propagate uncertainty with MC
            x2 = x1.val + randn([1, 1e6]).*s;
            y2 = f(x2);

            % check average and variance
            tc.verifyClose(mean(y1), mean(y2));
            tc.verifyClose(var(y1), var(y2));
            tc.verifyClose(unc(y1), std(y2));
            tc.verifyInstanceOf(string(y1), "string");
            
            % confirm we set calcId on all calculations
            tc.verifyTrue(y1.id == UncVal.calcId);
    
        end

    end
    
end