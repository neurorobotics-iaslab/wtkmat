function [hdr, beta, W, P] = wc_read_bayesian_lda(fid)

    hdr = wc_readheader(fid);

    hdr.subject     = wc_readstring(fid);
    hdr.nclasses    = wc_readbyte(fid, 'uint32');
    hdr.classlbs    = wc_readvector(fid, 'uint32');
    hdr.nfeatures   = wc_readbyte(fid, 'uint32');
    
    hdr.idchan = wc_readvector(fid, 'uint32');
    hdr.nprob = wc_readbyte(fid, 'uint32');
    
    beta = wc_readbyte(fid, 'double');
    W = wc_readeigen(fid, 'double'); 
    P = wc_readeigen(fid, 'double');
end

