function [Frq_f, Amp_f, Arc_f, Ftt_f, filter_sig] = FRF_term(filename, Fs)
    Fc = 5; % cutoff frequency
    Fss = Fs /2; %
    T = 1/Fs;
    ca = 0.1286;
    metadata = readmatrix(filename);
    L = size(metadata, 1);
    times = T*(1:1:L)';

    % Choose data from whole time stream
    Use = 3;
    data1 = metadata(:, Use)*ca;
    duration = 10;
    FStart = times(data1==max(data1))-0.02; % select start
    FEnd = FStart + duration; % select end time
    data_slc = data1(times<FEnd&times>FStart);
    times_slc = times(times<FEnd&times>FStart) ;
    ll = size(data_slc, 1);
    avr = mean(data_slc);
    data_slc = data_slc - avr; % eliminate bias

    % design a butterworth filter
    Win=1000;
    winfir = fir1(Win, Fc/Fss, 'high', kaiser(Win+1,2.5));
    filter_sig = filter(winfir, 1, data_slc);
    [Frq_f, Amp_f, Arc_f, Ftt_f] = Freq_Amp(times_slc, filter_sig, 1);
end