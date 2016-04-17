function [Brate] = estimate_respiratory_rate(fiducial_points,ECGlead,fs,algorithm)
    if(strcmp(algorithm, 'RR') == 1),
        t = (0:length(ECGlead)-1)/fs;
        % Inicializacion de vectores
        nRR = numel(fiducial_points.Rpeak);
        RR  = zeros(1,nRR-1);
        % Intervalos RR
        for k = 1:nRR-1,
            RR(1,k) = ECGlead(fiducial_points.Rpeak(1,k+1)) - ECGlead(fiducial_points.Rpeak(1,k));
        end
        % Normalización
        RR = (RR-mean(RR))/(max(RR));
        % Interpolación Lineal
        z = InterLineal(RR,floor(length(ECGlead)/size(RR,2)));
    elseif(strcmp(algorithm, 'RS') == 1),
        % Inicialización
        t = (0:length(ECGlead)-1)/fs;
        nRR = numel(fiducial_points.Rpeak);
        Rampl = fiducial_points.Rpeak;
        for k = 1:nRR
            Sampl(1,k) = min(ECGlead(fiducial_points.Rpeak(1,k):fiducial_points.Soff(1,k)));
            ampl(1,k) = ECGlead(Rampl(1,k)) - Sampl(1,k);
        end
        % Normalización
        ampl = (ampl-mean(ampl))/(max(ampl)); 
        % Interpolación lineal
        z = InterLineal(ampl,round(size(ECGlead,2)/size(ampl,2)));
    else
        fprintf('Unsupported algorithm %s! Supported algorithms are RR and RS.\n', algorithm);
        Brate = 0;
        return;
    end
        
    % Ubicación de picos máximos
    peakLoc = peakfinder(z); 
    % Intervalos de tiempo entre picos
    m = t(peakLoc);
    if length(m) == 1
        cal = m;
    else
        for k = 2:length(m)
            cal(1,k-1) = m(1,k)-m(1,k-1);   
        end
    end
    % Cálculo de la frecuencia respiratoria
    Brate = floor(60/((mean(cal)))-1);
end