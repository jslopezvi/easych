function [NewpicosRI,Last_R_peak] = adjust_r_peaks(picosRI,ECGleadI,Fs,Last_R_peak)
% AjustePicoR Buscar maximos locales basados en candidatos de picosR.
%
%   A partir de la ubicacion de los picos R propuestos, realizar una
%   busqueda de maximos locales en el intervalo de 0.012*Fs. Al final se
%   podran obtener coordenadas picos R con una mayor precision.
    tamano = floor(0.012*Fs);
    NewpicosRI = zeros(1, size(picosRI,2));
    
    % Buscar en los candidatos de picos R.
    for k = 1:size(picosRI,2),
        ventana = (picosRI(1,k)-tamano : picosRI(1,k)+tamano);
        [~, ind] = max(ECGleadI(ventana));
        NewpicosRI(1,k) = ventana(ind);
    end
    
    % Buscar maximos locales segun el ultimo pico R candidato.
    ventana = (Last_R_peak-tamano : Last_R_peak+tamano);
    [~, ind] = max(ECGleadI(ventana));
    Last_R_peak = ventana(ind);
end