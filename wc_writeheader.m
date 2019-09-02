function wc_writeheader(fid, format, version, strtype, strlabel)
% wc_writeheader(fid, format, version, strtype, strlabel)
%
% Given a valid file identifier, the function write the header for WHITK
% binary files. The header is composed by:
%
%   string FORMAT
%   string VERSION
%   string TYPE
%   string LABEL


    wc_writestring(fid, format);
    wc_writestring(fid, version);
    wc_writestring(fid, strtype);
    wc_writestring(fid, strlabel);
    
end