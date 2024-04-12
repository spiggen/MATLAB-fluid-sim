% v_x = fft_filter(v_x')';
% v_x = fft_filter(v_x);
% v_y = fft_filter(v_y')';
% v_y = fft_filter(v_y);

v_x = relu(v_x, 4);
v_y = relu(v_y, 4);
smoke = relu(smoke, 0.06);