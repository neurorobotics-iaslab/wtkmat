function wc_invert_classifier(src, dst)
% Save the .mat gaussian classifier with flipped classes

    current = load(src);
    
    dimension = size(current.analysis.tools.net.gau.M);
    M = zeros(dimension);
    C = zeros(dimension);
    
    M(2, :, :) = current.analysis.tools.net.gau.M(1, :, :);
    M(1, :, :) = current.analysis.tools.net.gau.M(2, :, :);
    C(2, :, :) = current.analysis.tools.net.gau.C(1, :, :);
    C(1, :, :) = current.analysis.tools.net.gau.C(2, :, :);
    
    current.analysis.tools.net.gau.M = M;
    current.analysis.tools.net.gau.C = C;
    current.analysis.settings.task.classes =  fliplr(current.analysis.settings.task.classes);
    current.analysis.settings.task.classes_old =  fliplr(current.analysis.settings.task.classes_old);

    save(dst, '-struct', 'current', 'analysis');
end