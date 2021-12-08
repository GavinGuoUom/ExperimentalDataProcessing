% filename = '/Test/Rot-ac-healthy-03-30hz.csv';% 5kHz
filename = '/Test/Freq-11.csv'; % Frequency test 1
% filename = '/Test/Freq-12.csv'; % Frequency test 2
% filename = '/Test/Freq-13.csv'; % Frequency test 3
% filename = '/Test/TestRot-Healthy-03.csv'; % Unhealthy test 1
% filename = '/Test/Rot-Healthy-04-42hz.csv'; % Unhealthy test 2
% filename = '/Test/Rot-ac-healthy-03-30hz.csv'; % Healthy test 1
% filename = '/Test/Rot-ac-healthy-04-42hz.csv'; % Healthy test 2
Fc = 30; % cutoff frequency
Fs = 5000; % sampling frequency
Fss = Fs /2; %
T = 1/Fs;
metadata = readmatrix(filename);
L = size(metadata, 1);
times = T*(1:1:L)';
% Choose data from whole time stream
Use = 3;
data1 = metadata(:, Use);
duration = 5;
FStart = times(data1==max(data1))-0.05; % select start
FEnd = FStart + duration; % select end time
data_slc = data1(times<FEnd&times>FStart);
times_slc = times(times<FEnd&times>FStart) ;
ll = size(data_slc, 1);
avr = mean(data_slc);
data_slc = data_slc - avr; % eliminate bias
% Plot this data and its FFT curve
figure(1)
subplot(2,1,1);
plot(times_slc, data_slc)
subplot(2,1,2);
[Frq_1, Amp_1] = Freq_Amp(times_slc, data_slc, 1);
plot(Frq_1, Amp_1)

% design a butterworth filter

winfir = fir1(51, Fc/Fss, 'high');
[z,p,k] = butter(100, Fc/Fss, 'high');
sos2 = tf2sos(winfir, 1);
sos = zp2sos(z, p, k);
% fvtool(sos,'Analysis','freq')
fvtool(sos2,'Analysis','freq')
[b, a] = zp2tf(z, p, k);
filter_sig = filter(winfir, 1, data_slc);
subplot(2,1,1);
plot(times_slc, filter_sig);
[Frq_f, Amp_f] = Freq_Amp(times_slc, filter_sig, 1);
subplot(2,1,2);
plot(Frq_f, Amp_f)
