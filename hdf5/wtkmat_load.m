function varargout = wtkmat_load(filename)

    info = hdf5info(filename);
    
    NumDatasets = length(info.GroupHierarchy.Datasets);
    
    for dId = 1:NumDatasets
        cname = info.GroupHierarchy.Datasets(dId).Name(2:end);
        cdata = hdf5read(filename, cname);
        
        
        if nargout == 0
            assignin('base', cname, cdata);
        else
            eval(['data.' cname '= cdata;']);
        end
    end

    if nargout ~= 0
        varargout{1} = data;
    end
end