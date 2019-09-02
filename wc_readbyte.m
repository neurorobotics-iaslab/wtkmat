function var = wc_readbyte(fid, type)
% var = wc_readbyte(fid, type)
%
% Given a valid file identifier (fid),the function reads the data from the binary
% file according to the type argument.

    if nargin < 2
        type = 'uint32';
    end
    var  = fread(fid, 1, type);
end