function wc_writebyte(fid, var, type)
% wc_writebyte(fid, type)
%
% Given a valid file identifier (fid),the function writes var to the binary
% file according to the type argument.

    if nargin < 3
        type = 'uint32';
    end
   
    fwrite(fid, var, type);
end