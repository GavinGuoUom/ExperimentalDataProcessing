function [frq, amp]=Freq_Amp(times, sig, dim)
nn = size(times, dim);
fs = 1/abs(times(2)-times(1));
avr = mean(sig);
sig = sig - avr;
ft1 = fft(sig);
amp = abs(ft1/nn);
amp = amp(1:nn/2+1);
amp(2:end-1) = amp(2:end-1)*2;
frq = fs*linspace(0,1/2, nn/2+1);
end
