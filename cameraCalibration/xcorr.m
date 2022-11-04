function [r] = xcorr(x)
%XCORR Summary of this function goes here
%   Detailed explanation goes here

len = length(x);

%# autocorrelation
nfft = 2^nextpow2(2*len-1);
r = ifft( fft(x,nfft) .* conj(fft(x,nfft)) );

%# rearrange and keep values corresponding to lags: -(len-1):+(len-1)
r = [r(end-len+2:end) ; r(1:len)];


end

