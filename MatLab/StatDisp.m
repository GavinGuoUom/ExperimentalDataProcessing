% filename = '/Test/Freq-11.csv'; % Frequency test 1
% filename = '/Test/Freq-12.csv'; % Frequency test 2
% filename = '/Test/Freq-13.csv'; % Frequency test 3
% filename = '/Test/TestRot-Healthy-03.csv'; % Unhealthy test 1
% filename = '/Test/Rot-Healthy-04-42hz.csv'; % Unhealthy test 2
filename = '/Test/Rot-ac-healthy-03-30hz.csv'; % Healthy test 1
% filename = '/Test/Rot-ac-healthy-04-42hz.csv'; % Healthy test 2
Fs = 5000;
T = 1/Fs;
metadata = readmatrix(filename);
L = size(metadata, 1);
times = T*(1:1:L)';
figure1 = figure(1);
subplot(3,1,1)
plot(times, metadata(:, 3), ':', 'LineWidth',0.25, 'DisplayName', 'Channel 1')
hold on
plot(times, metadata(:, 2), 'DisplayName', 'Channel 0')
% hold off
ylim([-2000, 2000])
legend
% xlabel('Time(s)')
ylabel('12-bit ADC Amplitute')
subplot(3,1,2)
rate_t = metadata(:, 3)./metadata(:, 2);
plot(times, rate_t) % this list contains inf!!!!
xlabel('Time(s)')
ylabel('Gain')
% hold off
% savefig('./Figures/Datacollection.fig')
% saveas(figure1, './Figures/DAQ1.png')
% Analyse the gain rate, is it out of range?
% remove inf
rate = rate_t(~isinf(rate_t));
% rate_mean = mean(rate_C);
nbins = 100;
subplot(3,1,3)
hisg=histogram(rate, nbins,'Normalization','probability');
hold on
% hisg.BinEdges=[min(rate): max(rate)];
ratex = min(rate):0.001:max(rate);
pd_nm = fitdist(rate, 'Normal');
norm_disp = pdf(pd_nm, ratex);
plot(ratex, norm_disp, 'r')
xlabel('Gain')
ylabel('Probability')
grid on
% So far we know how we can trust our data.
subplot(3,1,2)
ub = pd_nm.mu+3*pd_nm.sigma;
lb = pd_nm.mu-3*pd_nm.sigma;
hh = yline(pd_nm.mu+3*pd_nm.sigma);
hm = yline(pd_nm.mu);
hl = yline(pd_nm.mu - 3*pd_nm.sigma);
% fill(hl, hh, 'r');
hold off

% start calibrating
nn = length(rate_t);
for i = 1:nn
    if rate_t(i) > ub || rate_t(i) < lb
        metadata(i, 3) = pd_nm.mu * metadata(i, 2);
    end
end

% plot calibrated
figure(1)
subplot(3,1,1)
hold on
plot(times, metadata(:, 3))
hold off
save ./Data/metadata_test.mat metadata

% save calibration parameter
cal = 1/(2048 * pd_nm.mu);
% save ./Data/cal.mat cal
