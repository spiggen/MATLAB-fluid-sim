function dy_di = fft_derive(y)
    
L = height(y);         % Length of signal
freqs = (-L/2:L/2-1)';

y_f = fftshift(fft(y));
dfy_dt = y_f.*freqs*2*pi*1i;

% Filter
dfy_dt(1:round(L/3),:) = 0;
dfy_dt(end-round(L/3):end,:) = 0;
%


dy_di = real(ifft(ifftshift(dfy_dt)));

% Second filter
maxval = max(abs(dy_di));
dy_di(abs(dy_di) < maxval*0.2) = 0;

end