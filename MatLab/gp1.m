% filename = 'RT-5kHz-04-uh.csv';% 5kHz
% filename = 'RF-10.csv'; % Frequency test 1 @ 5kHz
filename = 'RF-11.csv'; % Frequency test 2 @ 5kHz
% filename = 'RF-101.csv'; % Frequency test 3 @ 5kHz
% filename = 'RF-500Hz-01.csv'; % Frequency test @ 500Hz
% filename = 'RT-5kHz-01.csv'; % Healthy Dynamic test @ 5kHz
% filename = 'RT-5kHz-02.csv'; % Healthy Dynamic test @ 5kHz
% filename = 'RT-5kHz-04-uh.csv'; % Unhealthy dynamic test @ 5kHz
% filename = 'RT-5kHz-05-uh.csv'; % Unhealthy dynamic test @ 5kHz
metadata = readmatrix(filename);
figure(3)
plot(metadata(1, :), metadata(2, :))
% data1 = metadata;
data1 = metadata(:, metadata(1, :)<1&metadata(1, :)>0.72);
Fs = 5000;
T = 1/Fs;
L = size(data1, 2);
avr = sum(data1(2, :))/L;
sig = data1(2,:) - ones([1, L]) * avr;
Y = fft(sig);
time = data1(1,:);
figure(1)
plot(time, sig)
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
figure(2)
plot(f,P1)

