function wc_save_filters(src, dst, fieldpath, type)

    if nargin < 4
        type = 'cnbi-csp';
    end

    if ischar(src) 
        srcst = load(src);
    elseif isstruct(src)
        srcst = src;
    end
    
    fid = fopen(dst, 'w');
    if(fid < 0)
        error('chk:file', 'Invalid destination path');
    end
    
    switch lower(type)
        case 'cnbi-csp'
            disp('Saving cnbi CSP filter to binary'); 
            write_csp_cnbi(fid, fieldpath, srcst);
        case 'cnbi-bankcsp'
            disp('Saving cnbi CSP bank filter to binary'); 
            write_bankcsp_cnbi(fid, fieldpath, srcst);
 
        
        otherwise
            error('chk:typ', 'Filter type not recognized');
    end
        
    
    fclose(fid);
    
end


function write_csp_cnbi(fid, fieldpath, srcst)
    
    format   = 'WHITK';
    version  = '1.0';
    type     = 'filter';
    label    = 'cnbi-csp';
    
    subject  = srcst.settings.info.subject;

    nchannels   = size(getfield(srcst, fieldpath{:}, 'indcsp'), 1);
    nfilters    = 1;


    wc_writeheader(fid, format, version, type, label);
    wc_writestring(fid, subject);

    wc_writebyte(fid, nchannels, 'uint32');
    wc_writebyte(fid, nfilters, 'uint32');

    wc_writeeigen(fid, getfield( srcst, fieldpath{:}, 'coeffcsp'), ...
        'double');
    wc_writevector(fid, getfield( srcst, fieldpath{:}, 'indcsp'), ...
        'uint32');
end

function write_bankcsp_cnbi(fid, fieldpath, srcst)
    
    format   = 'WHITK';
    version  = '1.0';
    type     = 'filter';
    label    = 'cnbi-bankcsp';
    
    subject  = srcst.settings.info.subject;

    nchannels   = size(getfield(srcst, fieldpath{:}, 'indcsp'), 1);
    nfilters    = size(getfield(srcst, fieldpath{:}, 'indcsp'), 2);


    wc_writeheader(fid, format, version, type, label);
    wc_writestring(fid, subject);

    wc_writebyte(fid, nchannels, 'uint32');
    wc_writebyte(fid, nfilters, 'uint32');

    wc_writeeigen(fid, getfield( srcst, fieldpath{:}, 'coeffcsp'), ...
        'double');
    wc_writeeigen(fid, getfield( srcst, fieldpath{:}, 'indcsp'), ...
        'uint32');
end
