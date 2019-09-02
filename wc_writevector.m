function size = wc_writevector(fid, vec, type, htype)
% size = wc_writevector(fid, vec, type, [htype='uint32'])
%
% Given a valid file identifier (fid),the function writes vec to the binary accordingly to format type.
% The function writes a byte with the size of the vector and then the vector itself.
% The type of the header byte can be specified with htype (default: 'uint32');

    if nargin < 4
        htype = 'uint32';
    end
    
    if isvector(vec) == false
        error('chk:data', 'Data input must be a vector');
    end
        
    
    size = numel(vec);
    wc_writebyte(fid, size, htype);
    fwrite(fid, vec, type);
end