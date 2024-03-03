function y = fft_filter(y)
    
L = height(y);


y_f = fftshift(fft(y));

% Filter
y_f(1:round(L/60),:) = 0;
y_f(end-round(L/60):end,:) = 0;
%


y = real(ifft(ifftshift(y_f)));

% Second filter
%maxval = max(abs(y));
%y(abs(y) < maxval*0.01) = 0;

end