function hdr = wc_readheader(fid)
% hdr = wc_readheader(fid)
%
% Given a valid file identifier, the function read the header in WHITK
% format. The header is composed by:
%
%   string FORMAT
%   string VERSION
%   string TYPE
%   string LABEL

    hdr.format  = wc_readstring(fid);
    hdr.version = wc_readstring(fid);
    hdr.type    = wc_readstring(fid);
    hdr.label   = wc_readstring(fid);
    
end