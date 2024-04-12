function dy_di = fft_derive(y)
    
L = height(y);         % Length of signal
freqs = (-L/2:L/2-1)';

y_f = fftshift(fft(y));
dfy_dt = y_f.*freqs*2*pi*1i;




dy_di = real(ifft(ifftshift(dfy_dt)));


end