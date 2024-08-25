function varargout = size(obj, varargin)
%SIZE return size of UncVal
sz = size(obj.val, varargin{:});
if nargout <= 1
    varargout{1} = sz;
else
    for i = 1:nargout
        varargout{i} = sz(i); %#ok<AGROW>
    end
end
end

