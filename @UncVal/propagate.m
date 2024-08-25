function srcs = propagate(xSrcs, ySrcs, Cx, Cy)
%PROPAGATE propagate uncertainty for a binary operation 
% output sensitivity = Cx*dx + Cy*dy

% start with the uncertainty from x, and modify
srcs = xSrcs;
for k = srcs.keys'
    srcs(k).sens = Cx.*xSrcs(k).sens;
end

% then add in y terms
for k = ySrcs.keys'
    xsens = 0.0;
    if isKey(srcs, k)
        % data is present in both sets
        xvarEqual = xSrcs(k).xvar == ySrcs(k).xvar;
        sensZero = (xSrcs(k).sens == 0.0) | (ySrcs(k).sens == 0.0);
        assert(all(xvarEqual | sensZero, "all"), ...
            "UncVal:InconsistentVariance", ...
            "Inconsitent variance for id: '%s' %g vs %g", ...
            k, xSrcs(k).xvar, ySrcs(k).xvar);

        % if variance was zeros in x, start with the y stuff
        if all(xSrcs(k).xvar == 0.0, "all")
            srcs(k).xvar = ySrcs(k).xvar;
        end
        xsens = srcs(k).sens;
    else
        % data present in y only, copy the structure directly from y
        srcs(k) = ySrcs(k);
    end
    srcs(k).sens = xsens + Cy.*ySrcs(k).sens;
end

end

