function [mat, rows, cols] = wc_readeigen(fid, type, htype)
% mat = wc_readeigen(fid, type, [htype='uint32'])
%
% Given a valid file identifier (fid),the function reads a 2D matrix from the binary according to format type.
% It assumes 2 bytes preceding matrix data and indicating the dimension 1 and dimension 2, respectively. The
% type of the header bytes can be specified with htype (default: 'uint32');

    if nargin < 3
        htype = 'uint32';
    end
    
    rows = wc_readbyte(fid, htype);
    cols = wc_readbyte(fid, htype);
    mat = fread(fid, [rows cols], type);
end

