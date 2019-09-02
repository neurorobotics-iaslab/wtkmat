function [vec, size] = wc_readvector(fid, type, htype)
% [vec, size] = wc_readvector(fid, type, [htype='uint32'])
%
% Given a valid file identifier (fid),the function reads a vector from the binary according to format type.
% It assumes 1 byte preceding matrix data and indicating the size. The
% type of the header byte can be specified with htype (default: 'uint32');

    if nargin < 3
        htype = 'uint32';
    end
    
    size = wc_readbyte(fid, htype);
    vec = fread(fid, size, type);
end

