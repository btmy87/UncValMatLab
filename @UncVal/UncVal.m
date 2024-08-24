classdef UncVal
    %UNCVAL Calculations with uncertainty
    %   Perform standard matlab calculations with uncertainty
    %   Propagates uncertainty with derivatives using an autodiff like
    %   method
    
    properties
    end
    properties(SetAccess=private)
        val double % value
        xvar double % variance in value
        srcs % dictionary of sources of variance
        id string % string id
    end
    properties (Constant, Hidden)
        calcId = "calc" % ID used for results of calculations
        constId = "const" % ID used for constants
    end
    
    methods
        function obj = UncVal(val, unc, id)
            %UncVal construct an uncertain value
            %   UncVal(val, unc, id) returns an UncVal object with the given
            %   value, uncertainty, and id

            arguments
                val = nan
                unc double {mustBeNonnegative} = 0.0
                id (1, 1) string = ""
            end

            assert(id~=UncVal.calcId, "UncVal:InvalidId", ...
                "UncVal id '%s' cannot be used. This is reserved for internal use.", ...
                UncVal.calcId);
            assert(~(id==UncVal.constId && unc > 0.0), "UncVal:InvalidId", ...
                "UncVal id '%s' cannot be used. This is reserved for internal use.", ...
                UncVal.constId);

            % make an id if the user didn't supply one
            if id == ""
                id = UncVal.makeId();
            end

            % expand the uncertainty to match the size of val in case
            % the user gives a scalar unc and an array val
            obj.val = val;
            obj.xvar = unc.*unc + zeros(size(val));
            obj.id = id;

            % create dictionary to track srcs of variance.
            obj.srcs = configureDictionary("string", "cell");
            obj.srcs{id} = obj.xvar;
        end
        
    end
    methods (Static=true)
        obj = UncValInt(val, xvar, srcs); % internal use constructor
        obj = makeUncVal(val);
        str = makeId();
    end
end

