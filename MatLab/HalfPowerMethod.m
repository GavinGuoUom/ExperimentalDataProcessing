function [dissp] = HalfPowerMethod(Wn, Frq, Amp)
    wn = len(Wn);
    dissp = zeros([wn, 1]);
    for i = 1:wn
        
        amp = Amp(Frq==Wn(i));
        hp = amp/sqrt(2);

    end
end