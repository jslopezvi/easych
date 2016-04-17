% Preproceso para perturbacion de saturacion
function [buffer,media]=filter_ecg(buffer,umbral)
    % Verificar NaN, seleccionar solo elementos que no sean NaN (Not a
    % Number)
    [a,b]  = find(isnan(buffer));
    for i1 = 1:length(a),
        buffer(a(i1,1),b(i1,1)) = buffer(a(i1,1)-1,b(i1,1));
    end

    % Filtro de Mediana
    buffer = medfilt1D(buffer,5);
    % Centralizado
    media = mean(buffer);
    buffer = buffer - mean(buffer);
   
    % Absoluto del buffer
    abs_buffer = abs(buffer);

    if sum(abs_buffer >= umbral) == length(abs_buffer),
        umbral = std(buffer);
    end

    % Comparación
    abs_buffer = abs_buffer';
    buffer = buffer';
    for k = 1: length(abs_buffer)
        if abs_buffer(k,1) >= umbral
            if k == 1
               a = find(abs_buffer <= umbral);
               buffer(k,1) = buffer(a(k,1),1);
            elseif k > 1 && k <= 6
                vent = buffer(1:k-1,1);
                prom = median(vent);
                buffer(k,1) = prom;
            else
                vent = buffer(k-6:k-1,1);
                prom = median(vent);
                buffer(k,1) = prom;
            end
        end
    end
    
    buffer = buffer';
end