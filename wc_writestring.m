function size = wc_writestring(fid, str, htype)
% size = wc_writestring(fid, str, [htype='uint32'])
%
% Given a valid file identifier (fid),the function writes str to the binary.
% The function writes a byte with the length of the string and then the string itself.
% The type of the header byte can be specified with htype (default: 'uint32');

    if nargin < 3
        htype = 'uint32';
    end
    
    size = numel(str);
    wc_writebyte(fid, size, htype);
    fprintf(fid, '%s', str);
end