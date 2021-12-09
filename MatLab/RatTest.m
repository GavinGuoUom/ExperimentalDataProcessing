% filename = '/Test/Rot-ac-healthy-03-30hz.csv';% 5kHz
% filename = '/Test/Freq-11.csv'; % Frequency test 1
% filename = '/Test/Freq-12.csv'; % Frequency test 2
% filename = '/Test/Freq-13.csv'; % Frequency test 3
% filename = '/Test/TestRot-Healthy-03.csv'; % Unhealthy test 1
% filename = '/Test/Rot-Healthy-04-42hz.csv'; % Unhealthy test 2
filename = '/Test/Rot-ac-healthy-03-30hz.csv'; % Healthy test 1
% filename = '/Test/Rot-ac-healthy-04-42hz.csv'; % Healthy test 2
Fc = 30; % cutoff frequency
Fs = 5000; % sampling frequency
Fss = Fs /2; %
T = 1/Fs;
metadata = readmatrix(filename);
L = size(metadata, 1);
times = T*(1:1:L)';
figure(1)
plot(times, metadata(:, 2))
hold on
plot(times, metadata(:, 3), ':', 'LineWidth',0.25)

% Choose data from whole time stream
Use = 3;
data1 = metadata(:, Use);
duration = 3;
% FStart = times(data1==max(data1))-0.05; % select start
% FEnd = FStart + duration; % select end time
data_slc = data1;
times_slc = times;
ll = size(data_slc, 1);
avr = mean(data_slc);
data_slc = data_slc - avr; % eliminate bias
% Plot this data and its FFT curve
figure(2)
subplot(2,1,1);
plot(times_slc, data_slc, 'LineStyle','-', 'LineWidth',1, 'Color', 'g')
hold on
subplot(2,1,2);
[Frq_1, Amp_1] = Freq_Amp(times_slc, data_slc, 1);
plot(Frq_1, Amp_1, 'LineStyle','-', 'LineWidth',1, 'Color', 'g')
hold on

% This data has many noise, so second we analyse the noise
% FT1 = fft(noise_slc);
% Frq_1 = abs(FT1/ll);
% Frq_1 = Frq_1(1:ll/2+1,1);
% Frq_1(2:end-1,1) = 2*Frq_1(2:end-1,1);
% ff = Fs*linspace(0,1/2, ll/2+1);

winfir = fir1(51, Fc/Fss, 'high');
[z,p,k] = butter(6, Fc/Fss, 'high');
sos2 = tf2sos(winfir, 1);
sos = zp2sos(z, p, k);
fvtool(sos,'Analysis','freq')
% fvtool(sos2,'Analysis','freq')
[b, a] = zp2tf(z, p, k);
filter_sig = filter(b, a, data_slc);
figure(2)
hold on
subplot(2,1,1);
plot(times_slc, filter_sig, 'Color','r','LineStyle',':', 'LineWidth', 0.1);
hold on
[Frq_f, Amp_f] = Freq_Amp(times_slc, filter_sig, 1);
subplot(2,1,2);
plot(Frq_f, Amp_f, 'Color','r','LineStyle',':', 'LineWidth',0.2)
hold on

% avr = sum(data1(2, :))/L;
% sig = data1(2,:) - ones([1, L]) * avr;
% Y = fft(sig);
% time = data1(1,:);
% figure(1)
% plot(time, sig)
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
% figure(2)
% plot(f,P1)

