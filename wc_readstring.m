function [str, size] = wc_readstring(fid, htype)
% [str, size] = wc_readstring(fid, [htype='uint32'])
%
% Given a valid file identifier (fid),the function reads the string from the binary.
% It assumes a 1 byte preceding the data and indicating the size. The
% type of the header byte can be specified with htype (default: 'uint32');

    if nargin < 2
        htype = 'uint32';
    end
    
    size = wc_readbyte(fid, htype);
    str = fread(fid, size, '*char')';
end