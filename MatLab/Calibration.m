function [metadata, coeff, pd] = Calibration(metadata)
%CALIBRATION Summary of this function goes here
%   Detailed explanation goes here
rate_t = metadata(:, 3)./metadata(:, 2);
% Analyse the gain rate, is it out of range?
% remove inf
rate = rate_t(~isinf(rate_t));
% ratex = [min(rate):0.001:max(rate)];
pd = fitdist(rate, 'Normal');
% norm_disp = pdf(pd_nm, ratex);
% So far we know how we can trust our data.
ub = pd.mu+3*pd.sigma;
lb = pd.mu-3*pd.sigma;
% start calibrating
nn = length(rate_t);
for i = 1:nn
    if rate_t(i) > ub || rate_t(i) < lb
        metadata(i, 3) = pd.mu .* metadata(i, 2);
    end
end
% save calibration parameter
coeff = 100*9.8/(2048 * pd.mu);
end

