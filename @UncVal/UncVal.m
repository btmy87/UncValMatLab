classdef UncVal
    %UNCVAL Calculations with uncertainty
    %   Perform standard matlab calculations with uncertainty
    %   Propagates uncertainty with derivatives using an autodiff like
    %   method
    
    properties
        val double % value
        xvar double % variance in value
        id string % string id
        srcs % dictionary of sources of variance
    end
    properties (Constant, Hidden)
        calcId = "calc" % ID used for results of calculations
        defaultId = "no_id" % Id used if none is given
        keyType = "string" % key type for srcs dictionary
        valueType = "double" % value type for srcs dictionary
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

            assert(id~=UncVal.calcId, "UncVal id cannot be '" + ...
                UncVal.calcId + "'. This is reserved for internal use.");
            assert(id~=UncVal.defaultId, "UncVal id cannot be '" + ...
                UncVal.defaultId + "'. This is reserved for internal use.");

            % make an id if the user didn't supply one
            if id == ""
                id = UncVal.defaultId;
            end

            % expand the uncertainty to match the size of val in case
            % the user gives a scalar unc and an array val
            obj.val = val;
            obj.xvar = unc.*unc + zeros(size(val));
            obj.id = id;

            % create dictionary to track srcs of variance.
            obj.srcs = configureDictionary(UncVal.keyType, UncVal.valueType);
            obj.srcs(id) = obj.xvar;
        end
        
    end
    methods (Static=true)
        obj = UncValInt(val, xvar, srcs); % internal use constructor
        obj = makeUncVal(val);
        str = makeId();
    end
end

