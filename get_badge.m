function out = get_badge(lbl, msg, color, filename)
% get_badge returns a shields.io badge svg

arguments
    lbl (1, 1) string
    msg (1, 1) string
    color (1, 1) string = "blue" % html color or HEX
    filename (1, 1) string = ""
end

baseUrl = "https://img.shields.io/badge/";

% replace single hyphen with double in lbl and msg
lbl = strrep(lbl, "-", "--");
msg = strrep(msg, "-", "--");

% replace singel underscores with double underscores
lbl = strrep(lbl, "_", "__");
msg = strrep(msg, "_", "__");

% replace spaces with underscores
lbl = strrep(lbl, " ", "_");
msg = strrep(msg, " ", "_");

% replace % with %25
lbl = strrep(lbl, "%", "%25");
msg = strrep(msg, "%", "%25");

% replace # in color with %23
color = strrep(color, "#", "%23");

fullUrl = baseUrl + lbl + "-" + msg + "-" + color;

opts = weboptions(contentType="text");
out = webread(fullUrl, opts);

if filename ~= ""
    fid = fopen(filename, "w+");
    fprintf(fid, "%s", out);
    fclose(fid);
end
