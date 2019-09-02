function wc_save(dst, data, type, dtype, strtype, strlabel)

    if nargin < 5
        strtype = '';
        strlabel = '';
    end
    
    if nargin < 6
        strlabel = '';
    end
    
    
    format = 'WHITK';
    version = '1.0';

    fid = fopen(dst, 'w');
    if(fid < 0)
        error('chk:file', 'Invalid destination path');
    end
    
    wc_writeheader(fid, format, version, strtype, strlabel);
    
    switch(type)
        case 'string'
            wc_writestring(fid, data);
        case 'eigen'
            wc__writeeigen(fid, data, dtype);           
        case 'vector'
            wc_writevector(fid, data, dtype);
    end
    
    fclose(fid);
end