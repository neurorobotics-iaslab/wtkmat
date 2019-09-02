function [hdr, M, C] = wc_load_classifier(ifile, type)

    if nargin < 3
        type = 'cnbi-gaussian';
    end

    fid = fopen(ifile, 'r+');
    
    switch lower(type)
        case 'cnbi-gaussian'
            %disp(['Loading cnbi gaussian classifier from ' ifile]); 
            [hdr, M, C] = read_gaussian_cnbi(fid);
 
        
        otherwise
            error('chk:typ', 'Classifier type not recognized');
    end
        
    
    fclose(fid);
end


function [hdr, M, C] = read_gaussian_cnbi(fid)

    hdr = wc_readheader(fid);

    hdr.subject     = wc_readstring(fid);
    hdr.nclasses    = wc_readbyte(fid, 'uint32');
    hdr.classlbs    = wc_readvector(fid, 'uint32');
    hdr.nprototypes = wc_readbyte(fid, 'uint32');
    hdr.nfeatures   = wc_readbyte(fid, 'uint32');
    hdr.shrdcov     = wc_readbyte(fid, '*char');
    hdr.mimean      = wc_readbyte(fid, 'float');
    hdr.micov       = wc_readbyte(fid, 'float');
    
    hdr.idchan = wc_readvector(fid, 'uint32');
    hdr.idfreq = wc_readvector(fid, 'uint32');
    
    D = wc_readeigen(fid, 'double');
    M = extractdata_gaussian_cnbi(D, [hdr.nfeatures hdr.nprototypes hdr.nclasses]);
    M = permute(M, [3 2 1]);
    
    D = wc_readeigen(fid, 'double');
    C = extractdata_gaussian_cnbi(D, [hdr.nfeatures hdr.nprototypes hdr.nclasses]);
    C = permute(C, [3 2 1]);
end

function P = extractdata_gaussian_cnbi(D, dim)
    P = zeros(dim);
    for dId = 1:dim(3)
        P(:, :, dId) = D((dId - 1)*dim(1) + 1:dId*dim(1), :);
    end
end

%%
function [hdr, beta, W, P] = read_bayesian_lda(fid)

    hdr = wc_readheader(fid);

    hdr.subject     = wc_readstring(fid);
    hdr.nclasses    = wc_readbyte(fid, 'uint32');
    hdr.nfeatures   = wc_readbyte(fid, 'uint32');
    hdr.classlbs    = wc_readvector(fid, 'uint32');
    
    hdr.idchan = wc_readvector(fid, 'uint32');
    hdr.nprob = wc_readbyte(fid, 'uint32');
    
    beta = wc_readbyte(fid, 'double');
    W = wc_readeigen(fid, 'double'); 
    P = wc_readeigen(fid, 'double');
end