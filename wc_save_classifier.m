function wc_save_classifier(src, dst, type_feature, type)

    if nargin < 4
        type = 'cnbi-gaussian';
    end
    
    if nargin < 3
        type_feature = 'smr';
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
    
    switch lower(type_feature)
        case 'smr'
            switch lower(type)
                case 'cnbi-gaussian'
                    disp('Saving cnbi gaussian classifier to binary');
                    write_gaussian_cnbi(fid, type_feature, srcst);
                    
                otherwise
                    error('chk:typ', 'Classifier type not recognized');
            end
                
        case 'p300'
            switch lower(type)
                case 'bayesian-lda'
                    disp('Saving bayesian lda classifier to binary');
                    write_bayesian_lda(fid, type_feature, srcst);
                    
                otherwise
                    error('chk:typ', 'Classifier type not recognized');
            end
            
        otherwise
            error('chk:typ_ft', 'Features type not recognized');
    end
    
    
    fclose(fid);
    
end

%% Gaussian CNBI
function write_gaussian_cnbi(fid, type_feature, srcst)
    
    format   = 'WHITK';
    version  = '1.0';
    type     = 'classifier';
    label    = 'cnbi-gaussian';
    
    if isfield(srcst, 'analysis')
        subject  = srcst.analysis.info.subject;

        nclasses    = size(srcst.analysis.tools.net.gau.M, 1);
        classlbs    = srcst.analysis.settings.task.classes_old;
        nprototypes = size(srcst.analysis.tools.net.gau.M, 2);
        nfeatures   = size(srcst.analysis.tools.net.gau.M, 3);

        shrdcov = srcst.analysis.settings.classification.gau.sharedcov;
        mimean  = srcst.analysis.settings.classification.gau.mimean;
        micov   = srcst.analysis.settings.classification.gau.micov;

        [idchan, idfreq] = getfeatures_gaussian_cnbi(srcst.analysis.tools.features);

        M = permute(srcst.analysis.tools.net.gau.M, [3 2 1]); 
        C = permute(srcst.analysis.tools.net.gau.C, [3 2 1]); 


        wc_writeheader(fid, format, version, type, label);
        wc_writestring(fid, subject);

        wc_writebyte(fid, nclasses, 'uint32');
        wc_writevector(fid, classlbs, 'uint32');
        wc_writebyte(fid, nprototypes, 'uint32');
        wc_writebyte(fid, nfeatures, 'uint32');

        wc_writebyte(fid, shrdcov, 'char');
        wc_writebyte(fid, mimean, 'float');
        wc_writebyte(fid, micov, 'float');

        wc_writevector(fid, idchan, 'uint32');
        wc_writevector(fid, idfreq, 'uint32');

        wc_writeeigen(fid, M, 'double');
        wc_writeeigen(fid, C, 'double');
    else
        subject  = srcst.settings.info.subject;
        nclasses    = size(getfield(srcst, 'settings', 'bci', ...
            type_feature, 'gau', 'M'), 1);
        classlbs    = getfield(srcst, 'settings', 'bci', ...
            type_feature, 'taskset', 'classes');
        nprototypes = size(getfield(srcst, 'settings', 'bci', ...
            type_feature, 'gau', 'M'), 2);
        nfeatures   = size(getfield(srcst, 'settings', 'bci', ...
            type_feature, 'gau', 'M'), 3);

        shrdcov = getfield(srcst, 'settings', 'modules', ...
            type_feature, 'gau', 'sharedcov');
        mimean  = getfield(srcst, 'settings', 'modules', ...
            type_feature, 'gau', 'mimean');
        micov   = getfield(srcst, 'settings', 'modules', ...
            type_feature, 'gau', 'micov');

        [idchan, idfreq] = getfeatures_gaussian_cnbi(getfield(srcst, ...
            'settings', 'bci', type_feature));

        M = permute(getfield(srcst, 'settings', 'bci', type_feature, ...
            'gau', 'M'), [3 2 1]); 
        C = permute(getfield(srcst, 'settings', 'bci', type_feature, ...
            'gau', 'C'), [3 2 1]); 


        wc_writeheader(fid, format, version, type, label);
        wc_writestring(fid, subject);

        wc_writebyte(fid, nclasses, 'uint32');
        wc_writevector(fid, classlbs, 'uint32');
        wc_writebyte(fid, nprototypes, 'uint32');
        wc_writebyte(fid, nfeatures, 'uint32');

        wc_writebyte(fid, shrdcov, 'char');
        wc_writebyte(fid, mimean, 'float');
        wc_writebyte(fid, micov, 'float');

        wc_writevector(fid, idchan, 'uint32');
        wc_writevector(fid, idfreq, 'uint32');

        wc_writeeigen(fid, M, 'double');
        wc_writeeigen(fid, C, 'double');
    end
end

function [chans, freqs] = getfeatures_gaussian_cnbi(strfeatures)
    
    chans = [];
    freqs = [];
    chIndex = strfeatures.channels;
    for chId = 1:length(chIndex)
        currChId = chIndex(chId);
        freqIndex = strfeatures.bands{currChId};
       
        chans = cat(1, chans, repmat(currChId, length(freqIndex), 1));
        freqs = cat(1, freqs, freqIndex');
    end


end

function P = getdata_gaussian_cnbi(D) 
    P = [];
    for sId = 1:size(D, 3)
        P = cat(1, P, D(:, :, sId));
    end
end

%% Bayesian LDA
function write_bayesian_lda(fid, type_feature, srcst)
    
    format   = 'WHITK';
    version  = '1.0';
    type     = 'classifier';
    label    = 'bayesian-lda';
    
    subject  = srcst.settings.info.subject;
    nclasses    = srcst.settings.bci.p300.protocol.n_classes;
    nfeatures   = ceil(srcst.settings.acq.sf * srcst.settings.bci.p300.train.single_trial_dur....
        / srcst.settings.bci.p300.train.downsampling) * srcst.settings.acq.channels_eeg;
    classlbs    = srcst.settings.acq.classlbs;
    
    idchan = srcst.settings.acq.idchan;
    
    nprob = srcst.settings.bci.nprob;
    
    beta = srcst.settings.bci.p300.classifier.BLDA.beta;
    weights = srcst.settings.bci.p300.classifier.BLDA.weights;
    precision = srcst.settings.bci.p300.classifier.BLDA.precision;
    
    wc_writeheader(fid, format, version, type, label);
    wc_writestring(fid, subject);
    
    wc_writebyte(fid, nclasses, 'uint32');
    wc_writevector(fid, classlbs, 'uint32');
    wc_writebyte(fid, nfeatures, 'uint32');
    
    wc_writevector(fid, idchan, 'uint32');
    
    wc_writebyte(fid, nprob, 'uint32');
    
    wc_writebyte(fid, beta, 'double');
    
    wc_writeeigen(fid, weights, 'double');
    wc_writeeigen(fid, precision, 'double');
    
end
