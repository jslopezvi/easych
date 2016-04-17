%% Calcular w y wl 
% w ---- Es la ventana que contiene las muestras existentes entre el pico R
%        y el inicio de la onda P + un delay de muestras.
% wl --- Contiene las muestras desde el inicio del vector w hasta el final
%        del registro.
function [wl, w] = estimate_delay(picoR,Pon,senal,lastR,Fcardiacas)
    senal = senal';
    Inc    = 50;           % Latidos en el incremento
    last_R = max(picoR);
    last_P = max(Pon);
    Int_RP = last_R - last_P;
    delay  = floor(((mean(Fcardiaca,1) + Inc)*(Int_RP))/ mean(Fcardiaca,1));
    
    w  = delay;
    wl = senal((lastR-w):end,1); 
    %wl1 = senal((lastR-w):length(senal),1);
end