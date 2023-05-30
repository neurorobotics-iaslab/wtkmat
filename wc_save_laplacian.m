function wc_save_laplacian(src, dst)


    format   = 'WHITK';
    version  = '1.0';
    type     = 'laplacian';
    label    = '';
    
    if nargin < 2
        [path, name] = fileparts(src);
        dst = fullfile(path, [name '.dat']);
    end

    lapdata = load(src);
    
    fid = fopen(dst, 'w');
    if(fid < 0)
        error('chk:file', 'Invalid destination path');
    end
    
    wc_writeheader(fid, format, version, type, label);
    wc_writeeigen(fid, lapdata.lapmask, 'double');
    
    fclose(fid);
    