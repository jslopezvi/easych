function  [pico_rF , inicio_qrs , final_qrs] = dec_qrs2(escala,posiciones ,fs)
clear pos maximo posmax maxi minimo posmin_izq ventana posmin_der;
long = length(posiciones);
w=1;
kk=1;
c=1;
while w <= long  
    pico_r=posiciones(w);
    der = 0.1*fs;
    der = round(der);
    izq = 0.1*fs;
    izq = round(izq);
    
    if (pico_r -izq)<0
        [a b c]    = find(posiciones == pico_r);
        posiciones = posiciones(1,b+1:end);
        pico_r     = posiciones(w);
        long       = long-1;
    end
    
    try 
        ventana1 = escala(pico_r - izq:pico_r + der); 
        Flag = 0;
    catch
        Flag = 1;
        w = w+1;
        continue;
    end
    [valMax,posMax] = max(ventana1);
    [valMin,posMin] = min(ventana1);
    posMax = pico_r - izq + posMax;
    posMin = pico_r - izq + posMin;
    if (posMin - izq >1 && posMax + der <length(escala)) && Flag == 0
        if posMax > posMin
           ventana = escala(posMin - izq : posMax + der);
           iniventana = posMin - izq;
        else
           ventana = escala(posMax - izq : posMin + der);
           iniventana = posMax - izq;
        end
        deriv1Ven = [0 diff(ventana)];
        cxc = sign(deriv1Ven);
        contador = 0;
        valorMax = max(valMax,abs(valMin));
        limMax = 0.4*valorMax;                
        for cont = 1:length(deriv1Ven)-1,
            if sign(deriv1Ven(cont)) ~= sign(deriv1Ven(cont+1)), 
                if abs(ventana(cont)) > limMax 
                    contador = contador + 1;
                end
            end
        end
        contador = 1; % TO REVIEW: Que hace esta linea aca? Omite el for anterior basicamente.
        if contador <= 10,
             [~,posMax] = max(ventana);
             [~,posMin] = min(ventana);
           % annot(kk) = Annot(w);
            if posMax > posMin
                [pico , inicio, final] = dec_onda(posMax,posMin,ventana,0);
%                 plot(posMin+ iniventana, ventana(posMin), 'x');
%                 plot(posMax+ iniventana, ventana(posMax), 'd');
%                 plot(pico+ iniventana, ventana(pico), 's');
%                 plot(inicio+ iniventana, ventana(inicio), '^');
%                 plot(final+ iniventana, ventana(final), '*');
                pico_rF(kk) = pico + iniventana;
                inicio_qrs(kk) = inicio + iniventana;
                final_qrs(kk) = final + iniventana;
                w =  w+1;
                kk = kk+1;
            elseif posMax < posMin
                [pico , inicio, final] = dec_onda(posMax,posMin,ventana,1);
                pico_rF(kk) = pico + iniventana;
                inicio_qrs(kk) = inicio + iniventana;
                final_qrs(kk) = final + iniventana;
                w = w+1;
                kk = kk+1;
            else
                w = w+1;
            end
        else
               w = w+1;
        end
    else
        w = w+1;
    end
end
