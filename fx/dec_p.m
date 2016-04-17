function [prin_p , final_p] = dec_p(escala4, qrs, fs )
izq = fs*0.2;
j=1;
while j <= length(qrs), % Iterar sobre las coordenadas de los complejos QRS
    if j == 1 && qrs(j) < izq + floor(0.02*fs),
        ventana = escala4(1 : qrs(j));
    else
        if (qrs(j)- izq - floor(0.02*fs)) == 0
            ventana = escala4(qrs(j)- izq - floor(0.02*fs)+1 : qrs(j));
        else
            ventana = escala4(qrs(j)- izq - floor(0.02*fs) : qrs(j));
        end
        
    end
    k = qrs(j) - izq - floor(0.02*fs);
    [~,posMax] = max(ventana);
    [~,posMin] = min(ventana);
%     figure;
%     plot(ventana, 'b');    
    deriv1Ven = [0 diff(ventana)];    
%     hold on; 
%     plot(deriv1Ven, 'r');
    Sderiv1Ven = sign(deriv1Ven);
%     hold on; 
%     plot(Sderiv1Ven, 'm');
    crucesxcero(1:length(Sderiv1Ven)) = 0;
    for cont = floor(0.032*fs):length(Sderiv1Ven) - floor(0.02*fs)
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
        if unos - munos > floor(0.08*fs)
            prin_p(j) = munos;
            final_p(j) = unos + floor(0.02*fs);
        else
            prin_p(j) = munos-floor(0.016*fs);
            final_p(j) = unos+floor(0.04*fs);
        end
    elseif unos < munos 
        if munos - unos > floor(0.08*fs)
            prin_p(j) = unos;
            final_p(j) = munos + floor(0.02*fs);
        else
            prin_p(j) = unos-floor(0.016*fs);
            final_p(j) = munos+floor(0.04*fs);
        end
    elseif unos 
        prin_p(j) = unos - floor(0.032*fs);
        final_p(j) = unos + floor(0.044*fs);
    elseif munos
        prin_p(j) = munos - floor(0.032*fs);
        final_p(j) = munos + floor(0.044*fs);
    else 
        unos = length(ventana)/2;
        munos = length(ventana)/2 - 1;
        prin_p(j) = munos;
        final_p(j) = unos;
    end
    prin_p(j) = prin_p(j) + k;
    final_p(j) = final_p(j) + k;
    j = j+1;
    crucesxcero = [];
end