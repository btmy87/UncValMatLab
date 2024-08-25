function out = cat(dim,varargin)
numX = nargin-1;

% force everything to UncVal objects
x = cell(1, numX);
for i = 1:numX
    x{i} = UncVal.makeUncVal(varargin{i});
end

% concatenate the values
vals = cell(numX,1);
for i = 1:numX
    vals{i} = x{i}.val;
end
val = cat(dim, vals{:});

% get a list of all the fields
fields = string([]);
for i = 1:numX
    fields = [fields; x{i}.srcs.keys]; %#ok<AGROW>
end
allfields = unique(fields);

% we force the srcs field in each x to have the same fields
for i = 1:numX
    for k = allfields'
        if ~isKey(x{i}.srcs, k)
            x{i}.srcs{k} = zeros(size(x{i}.val));
        end
    end
end

% now we need to concatenate each field in srcs
srcs = dictionary();
% srcs = configureDictionary("string", "cell"); % >=2023b
for k = allfields'
    temp = cell(numX, 1);
    for i = 1:numX
        temp{i} = x{i}.srcs{k};
    end
    srcs{k} = cat(dim, temp{:});
end

% and finally, we make our object
out = UncVal.UncValInt(val, srcs);
end

