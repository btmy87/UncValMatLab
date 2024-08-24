function idStr = makeId()
% makeid makes a unique id string if the user didn't supply one
% please supply your own id's

persistent count;
if isempty(count)
    count = 0;
else
    count = count + 1;
end

idStr = sprintf("PleaseNameMe%04d", count);
end

