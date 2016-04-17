function [prin_t,final_t] = dec_t(ecg, escala4, qrs,fs )
periodo = 0.5*fs;
j=1;
largoqrs = length(qrs);
while j <= largoqrs
    if qrs(j) + periodo > length(ecg),
        ventana = escala4( qrs(j) + round(0.032*fs)  : end );
    else
        ventana = escala4( qrs(j) + round(0.032*fs)  : qrs(j) + periodo );
    end
    ventana = ventana/max(abs(ventana));
    k = qrs(j) + round(0.032*fs);
    deriv1Ven = [0 diff(ventana,1)];
    Sderiv1Ven = sign(deriv1Ven);
    crucesxcero(1:length(Sderiv1Ven)) = 0;
    for cont = round(0.032*fs) : length(Sderiv1Ven) - round(0.02*fs)
        if Sderiv1Ven(cont) == 1 && Sderiv1Ven(cont + 1) == -1
            crucesxcero(cont) = 1;
        elseif Sderiv1Ven(cont) == -1 && Sderiv1Ven(cont + 1) == 1
            crucesxcero(cont) = -1;
        end
    end
    unos = find(crucesxcero == 1);
    munos = find(crucesxcero == -1);
    if length(unos) > 1 
        ampl = ventana(unos);
        [~,pmaxi] = max(ampl);
        crucesxcero(unos) = 0;
        crucesxcero(unos(pmaxi)) = 1;
    end
    if length(munos) > 1
        ampl = ventana(munos);
        [~,pmaxi] = min(ampl);
        crucesxcero(munos) = 0;
        crucesxcero(munos(pmaxi)) = -1;
    end
    unos = find(crucesxcero == 1);
    munos = find(crucesxcero == -1);
    if unos > munos
        if unos - munos > round(0.08*fs)
            prin_p(j) = munos - round(0.028*fs);
            final_p(j) = unos + round(0.02*fs);
        else
            prin_p(j) = munos-round(0.044*fs);
            final_p(j) = unos+round(0.04*fs);
        end
    elseif unos < munos
        if munos - unos > round(0.08*fs)
            prin_p(j) = unos - round(0.028*fs);
            final_p(j) = munos + round(0.02*fs);
        else
            prin_p(j) = unos-round(0.044*fs);
            final_p(j) = munos+round(0.04*fs);
        end
    elseif unos
        prin_p(j) = unos - round(0.06*fs);
        final_p(j) = unos + round(0.044*fs);
    elseif munos
        prin_p(j) = munos - round(0.06*fs);
        final_p(j) = munos + round(0.044*fs);
    else
        unos = length(ventana)/2;
        munos = length(ventana)/2 - 1;
        prin_p(j) = munos;
        final_p(j) = unos;
    end
    prin_t(j) = prin_p(j) + k;
    final_t(j) = final_p(j) + k;
    j = j+1;
    crucesxcero = [];
end