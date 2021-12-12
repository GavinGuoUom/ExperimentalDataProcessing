% figure(1);
% openfig('FFT.fig');
load Frq_f.mat Frq_f;
load Ftt_f.mat Ftt_f;
load Amp_f.mat Amp_f;
load W.mat W;

% now start lsq curve fit for FRF
% define prolem

Wn = size(W, 2);
ReFtt = real(Ftt_f);
ImFtt = imag(Ftt_f);
Fn = size(Frq_f, 2);
funfrf_l = cell([Wn, 1]);
funfrf = @(X) 0;
funre_l = cell(Wn);
funim_l = cell(Wn);
funre = @(X) 0;
% X: Phi1, Phi2... Phin, Zeta1, Zeta2, ... Zeta n
for ii = 1:Wn
     funfrf_l{ii} = @(X) X(ii) .* ...
     ((Frq_f.^2 - W(ii).^2).^2+0.1.^2.*Frq_f.^2).^-1/2;
     % funfrf = @(X) funfrf(X) + funfrf_l{ii}(X);
end
% funfrf = @(X) sum(funfrf(X));
funfrf = @(X) funfrf_l{1}(X)+ ...
            funfrf_l{2}(X)+ ...
            funfrf_l{4}(X)+ ...
            funfrf_l{5}(X)+ ...
            funfrf_l{6}(X)+ ...
            funfrf_l{7}(X)+ ...
            funfrf_l{8}(X)+ ...
            funfrf_l{9}(X)+ ...
            funfrf_l{10}(X)+ ...
            funfrf_l{11}(X)+ ...
            funfrf_l{12}(X);

resfrf = @(X) funfrf(X) - Amp_f;
% aimfun = @(X) abs(resfrf(X));

% condunct least square method
x0 = zeros([1, Wn]);

Phi__ = lsqnonlin(resfrf, x0);

funim = @(X) 0;
for ii = 1:Wn
    funim_l{ii} = @(X) W(ii) .* Phi__(ii) .* X(ii) .* Frq_f-ImFtt';
    funim = @(X) funim(X) + funim_l{ii}(X);
end

Zeta__ = lsqnonlin(funim, x0);
Resp__ = FRF(Frq_f, Phi__, Zeta__, W);
AbsResp__ = abs(Resp__);
figure(1)
hold off
loglog(Frq_f, Amp_f)
hold on
loglog(Frq_f, AbsResp__, 'b:')

function Resp = FRF(frq, phi, zeta, wr)

    fnn = size(frq, 2);
    Resp = zeros([fnn, 1]);
    for ii = 1:fnn
        Resp(ii) = sum(phi.* (frq(ii).^2 - wr.^2).^-1+2 .*1i .* frq(ii) .* wr .* zeta);
    end
end