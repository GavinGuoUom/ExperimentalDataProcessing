% filename = '/Test/Freq-11.csv'; % Frequency test 1
% filename = '/Test/Freq-12.csv'; % Frequency test 2
% filename = '/Test/Freq-13.csv'; % Frequency test 3
ca = 0.1286;
filen_l = {'/Test/Freq-11.csv', '/Test/Freq-12.csv', '/Test/Freq-13.csv'};
Amp_l = [];
Ftt_l = [];
Acr_l = [];
Fs = 5000;
figure(1);
hold off
for ii = 1:3
    leg = sprintf('Test %d', ii);
    [Frq, Amp_l(:,ii), Arc_l(:, ii), Ftt_l(:, ii), filter_sig] = FRF_term(filen_l{ii}, Fs);
    subplot(2,1,1)
    loglog(Frq, Amp_l(:,ii), ':', 'LineWidth',0.1, 'DisplayName', leg)
    hold on
    subplot(2,1,2)
    semilogx(Frq, Arc_l(:, ii), ':', 'LineWidth', 0.1, 'DisplayName', leg)
    hold on
end

Amp_avr = mean(Amp_l, 2);
Arc_avr = mean(Arc_l, 2);
% figure(1)
% subplot(2,1,1)
% semilogx(Frq, Amp_avr, 'LineWidth', 1)
% xlim([min(Frq),max(Frq)]);
% grid on
% hold off
% subplot(2,1,2)
% semilogx(Frq, Arc_avr, 'LineWidth', 1)
% xlim([min(Frq),max(Frq)]);
grid on
hold on
save ./Data/Amp_avr.mat Amp_avr -mat
save ./Data/Frq.mat Frq -mat
save ./Data/Acr_avr.mat Arc_avr -mat
% savefig './Figures/FRF_avr.fig'

smoothfrf = smoothdata(Amp_avr, 'loess');
save ./Data/Amp_smth smoothfrf
logx = log10(Frq(2:end));
logy = log10(Amp_avr(2:end));
figure(2)
hold off
plot(logx, smoothfrf(2:end));
hold on
[Ampn, Wn_loc] = findpeaks(smoothfrf(2:end), logx, 'NPeaks', 20, 'MinPeakHeight', 3.5*ca, 'MinPeakDistance', 0.0469);
plot(Wn_loc, Ampn, 'o')
hold off
grid on
Wn = 10.^Wn_loc';
Natfrq = [Wn Ampn];
save ./Data/Wn.mat Natfrq -mat

figure(3)
loglog(Frq, Amp_avr, 'g:', 'LineWidth', 0.2)
hold on
loglog(Frq, smoothfrf, 'b-', 'LineWidth',1)

grid on
loglog(Wn, Ampn, 'ro')
hold off
savefig './Figures/SmoothAmpLog.fig'

figure(1)
subplot(2,1,1)
loglog(Frq, smoothfrf, 'b-', 'LineWidth',1, 'DisplayName', 'Average')
grid on
loglog(Wn, Ampn, 'ro', 'DisplayName', 'Peaks')
hold off
% xlabel('Frequency')
ylabel('$H(\omega)$','Interpreter','latex')
% legend
subplot(2,1,2)
semilogx(Frq, Arc_avr,'b', 'DisplayName', 'Average')
legend
xlabel('Frequency (Hz)')
ylabel('Phase(rad)')
hold off
savefig './Figures/FRF_avr.fig'