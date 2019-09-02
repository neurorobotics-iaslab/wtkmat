function [s, h] = wc_load(src, type, dtype, format, version)

    if nargin < 5
        format = 'WHITK';
        version = '1.0';
    end
    
    if nargin < 4
        format = 'WHITK';
    end

    fid = fopen(src, 'r+');
    if(fid < 0)
        error('chk:file', 'Invalid source path');
    end
    
    h = wc_readheader(fid);

    if (strcmp(format, h.format) == false)
        error('chk:hdr', 'Format of data not recognized');
    end
    
    if (strcmp(version, h.version) == false)
        error('chk:hdr', 'Version of data not allowed');
    end
    
    switch(type)
        case 'string'
            s = wc_readstring(fid);
        case 'eigen'
            s = wc_readeigen(fid, dtype);
        case 'vector'
            s = wc_readvector(fid, dtype);
        otherwise
            error('chk:type', 'Type not supported');
    end
    
    h.data.rows = size(s, 1);
    h.data.cols = size(s, 2);

end