% filename = 'RT-5kHz-04-uh.csv';% 5kHz
filename = 'RF-10.csv'; % Frequency test 1 @ 5kHz
% filename = 'RF-11.csv'; % Frequency test 2 @ 5kHz
% filename = 'RF-101.csv'; % Frequency test 3 @ 5kHz
% filename = 'RF-500Hz-01.csv'; % Frequency test @ 500Hz
% filename = 'RT-5kHz-01.csv'; % Healthy Dynamic test @ 5kHz
% filename = 'RT-5kHz-02.csv'; % Healthy Dynamic test @ 5kHz
% filename = 'RT-5kHz-04-uh.csv'; % Unhealthy dynamic test @ 5kHz
% filename = 'RT-5kHz-05-uh.csv'; % Unhealthy dynamic test @ 5kHz

[z, p, k] = butter(50, 1/2.5e3, 'high');
sos = zp2sos(z, p, k);
fvtool(sos,'Analysis','freq')
metadata = readmatrix(filename);
figure(3)
