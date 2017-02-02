clear all;
close all;

matfile = '/home/ltonin/Git/Codes/smr/analysis/smr-inc/psd/b4.20160301.155605.offline.mi_hfr.mat';;
hd5file = '/home/ltonin/Git/Codes/whitoolkit/wtkapp/bin/processing/test1.gdf.psd';

psdref = load(matfile);
psdmat = psdref.psd;
evtmat.typ = psdref.analysis.event.TYP;
evtmat.pos = psdref.analysis.event.POS;
evtmat.dur = psdref.analysis.event.DUR;

psdhd5 = wtkmat_load(hd5file);
psdcpp = psdhd5.psd; 
psdcpp = permute(psdcpp, [2 1 3]);
evtcpp.typ = psdhd5.evttyp;
evtcpp.pos = psdhd5.evtpos;
evtcpp.dur = psdhd5.evtdur;

%% Checking dimensions
fprintf('Checking dimensions...');
NumSamplesMat = size(psdmat, 1);
NumSamplesCpp = size(psdcpp, 1) - 1;

if(isequal(NumSamplesMat, NumSamplesCpp) == false)
    error('chk:dim', 'Different number of samples');
end

NumFreqsMat = size(psdmat, 2);
NumFreqsCpp = size(psdcpp, 2);

if(isequal(NumFreqsMat, NumFreqsCpp) == false)
    error('chk:dim', 'Different number of frequencies');
end

NumChansMat = size(psdmat, 3);
NumChansCpp = size(psdcpp, 3);

if(isequal(NumChansMat, NumChansCpp) == false)
    error('chk:dim', 'Different number of channels');
end

fprintf('OK!\n');

%% Checking PSD 
fprintf('Checking PSD signals...\n');
gdf = zeros(NumChansMat, NumFreqsMat);

for chId = 1:NumChansMat
    for fId = 1:NumFreqsMat
        gdf(chId, fId) = goodnessOfFit(psdmat(1:NumSamplesMat, fId, chId), psdcpp(1:NumSamplesCpp, fId, chId), 'NMSE');
    end
end

figure;
imagesc(gdf);
ylabel('Channels');
xlabel('Frequencies');
set(gca, 'CLim', [-100 1]);
colorbar;
title('Goodness of Fit - NMSE [-Inf 1]');

%% Checking events structure
fprintf('Checking event types...');
if(isequal(evtmat.typ, evtcpp.typ) == true)
    fprintf('OK!\n');
else
    fprintf('NO!!!\n');
end

fprintf('Checking event positions...');
if(isequal(evtmat.pos, evtcpp.pos) == true)
    fprintf('OK!\n');
else
    fprintf('NO!!!\n');
end
    
fprintf('Checking event durations...');
if(isequal(evtmat.dur, evtcpp.dur) == true)
    fprintf('OK!\n');
else
    fprintf('NO!!!\n');
end

