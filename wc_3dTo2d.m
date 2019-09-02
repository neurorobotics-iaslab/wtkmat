function Dout = wc_3dTo2d(Din, order)
    if nargin < 2
        order = 'column-major';
    end

    if ndims(Din) ~= 3
        error('chk:dim', 'Data input must have 3 dimensions');
    end
    
    
    Dout = [];   
    if strcmpi(order, 'column-major')
        for sliceId = 1:size(Din, 3)
            Dout = cat(1, Dout, Din(:, :, sliceId));
        end
    else
        error('chk:ord', 'Order not implemented');
    end
end