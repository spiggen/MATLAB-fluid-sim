function y = relu(x, x_max)
y = arrayfun(@internal, x);
    function y = internal(x)
    b1 = ( -x_max<x);
    b2 = ( x<x_max );
    y = x.*(b1 & b2) + x_max.*(1 - b2) - x_max.*(1 - b1);
    end
end