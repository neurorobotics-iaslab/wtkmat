function Do = wc_2dTo3d(D, dim, order)

    if nargin < 3
        order = 'column-major';
    end

    if ismatrix(D) == false
        error('chk:dim', 'Data input must have 2 dimensions');
    end
    
    Do = zeros(dim);
    for dId = 1:dim(3)
        if strcmpi(order, 'column-major')
            Do(:, :, dId) = D((dId - 1)*dim(1) + 1:dId*dim(1), :);
        else
            error('chk:ord', 'Order not implemented');
        end
    end
end