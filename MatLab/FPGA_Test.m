% filename = '/Test/Rot-ac-healthy-03-30hz.csv';% 5kHz
filename = '/Test/Freq-11.csv'; % Frequency test 1
% filename = '/Test/Freq-12.csv'; % Frequency test 2
% filename = '/Test/Freq-13.csv'; % Frequency test 3
% filename = '/Test/TestRot-Healthy-03.csv'; % Unhealthy test 1
% filename = '/Test/Rot-Healthy-04-42hz.csv'; % Unhealthy test 2
% filename = '/Test/Rot-ac-healthy-03-30hz.csv'; % Healthy test 1
% filename = '/Test/Rot-ac-healthy-04-42hz.csv'; % Healthy test 2
Fs = 5000;
T = 1/Fs;
metadata = readmatrix(filename);
L = size(data1, 1);
times = T*(1:1:L)';
figure(1)
plot(times, metadata(:, 2))
hold on
plot(times, metadata(:, 3), ':', 'LineWidth',0.25)

% Choose data from whole time stream
Use = 3;
data1 = metadata(:, Use);
duration = 3;
FStart = times(data1==max(data1))-0.05; % select start
FEnd = FStart + duration; % select end time
data_slc = data1(times<FEnd&times>FStart);
times_slc = times(times<FEnd&times>FStart) ;
ll = size(data_slc, 1);
avr = mean(data_slc);
data_slc = data_slc - avr; % eliminate bias
% Plot this data and its FFT curve
figure(2)
subplot(2,1,1);
plot(times_slc, data_slc)
subplot(2,1,2);
[Frq_1, Amp_1] = Freq_Amp(times_slc, data_slc, 1);
plot(Frq_1, Amp_1)

% This data has many noise, so second we analyse the noise
% chose the begin of data as noise source
NStt = 0;
NEnd = NStt + duration;
noise_slc = data1(times<NEnd&times>NStt);
time_ns = times(times<NEnd&times>NStt);
ln = size(noise_slc);
avrn = mean(noise_slc);
noise_slc = noise_slc -avrn;
% plot noise
figure(3)
subplot(2,1,1);
plot(time_ns, noise_slc)
subplot(2,1,2);
[Frq_n, Amp_n] = Freq_Amp(time_ns, noise_slc, 1);
plot(Frq_n, Amp_n)
% FT1 = fft(noise_slc);
% Frq_1 = abs(FT1/ll);
% Frq_1 = Frq_1(1:ll/2+1,1);
% Frq_1(2:end-1,1) = 2*Frq_1(2:end-1,1);
% ff = Fs*linspace(0,1/2, ll/2+1);

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
