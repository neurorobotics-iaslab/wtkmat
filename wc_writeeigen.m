function [dim1, dim2] = wc_writeeigen(fid, mat, type, htype)
% [dim1, dim2] = wc_writeeigen(fid, mat, type, [htype='uint32'])
%
% Given a valid file identifier (fid),the function writes matrix to the binary accordingly to format type.
% If the matrix has 3 dimensions, the function convert it in 2 dimensions [column-major order]
% The function writes 2 bytes with the dimension 1 and 2 of the matrix and then the matrix itself.
% The type of the header byte can be specified with htype (default: 'uint32');

    if nargin < 4
        htype = 'uint32';
    end
    
    if ndims(mat) == 3
        mat = wc_3dTo2d(mat);
    elseif ndims(mat) > 3
        error('chk:data', 'Data input can have maximum 3 dimensions');
    end
    
    dim1 = size(mat, 1);
    dim2 = size(mat, 2);
    wc_writebyte(fid, dim1, htype);
    wc_writebyte(fid, dim2, htype);
    fwrite(fid, mat, type);
end