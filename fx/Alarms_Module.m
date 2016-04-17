%% Modulo de alarmas

function [Exist Type]= Alarms_Module(Brate_RR,Brate_RS,Fcardiaca,fs,Ton,Toff,Qon,Rpeak,Soff,buffer)
    
    Exist = 0;
    Type  = [0 0 0 0 0 0 0 0];
    
    % vector de tiempos
    t = (0:length(buffer)-1)/fs;
    
    % Tipo: 1  Frecuencia Cardiaca ALTA > 120 bpm (beats per minute) "TATICARDIA"
    % Tipo: 2  Frecuencia Cardiaca BAJA < 40 bpm "BRADICARDIA"
%     if sum(Fcardiaca >= 120) > 0
%         Exist = 1; Type(1)= 1;
%     elseif sum(Fcardiaca <= 40) > 0
%         Exist = 1; Type(2) = 1;
%     end
    
    % Tipo: 3  Frecuencia Respiratoria ALTA > 30 bpm (breaths per minute) "TAQUIPNEA"
    % Tipo: 4  Frecuencia Respiratoria BAJA < 12 bpm "BRADIPNEA" **REVISAR CON MEDICOS**
%     if sum(Brate_RR & Brate_RS >= 30) > 0
%         Exist = 1; Type(3) = 1;
%     elseif sum(Brate_RR & Brate_RS <= 12) > 0
%         Exist = 1; Type(4) = 1;
%     end

    % Tipo: 5  Arritmia, Pérdida de conducción normal. Segmento QT > 0.5
    % segundos (inicio de Q y final de T)
    
%     QTseg = t(Toff)-t(Qon);
%     if sum(QTseg > 0.5) > 0
%         [val idx] = max(QTseg > 0.5)
%         if Ton(idx+1) < Toff(idx)
%             Type(5) = 0;              % Ausencia de onda P por pérdida de datos.
%         else
%             Exist = 1; Type(5) = 1;
%         end
%         
%     end
    
    % Tipo: 6  Arritmia, Pérdida de conducción normal. Ancho complejo QRS > 0.12 segundos
%     QRScomplex = t(Soff)-t(Qon);
%     if sum(QRScomplex > 0.12) > 0
%         Exist = 1; Type(6) = 1
%     end
    
    % Tipo: 7  Arritmia, Pérdida de conducción normal. Distancia entre latidos > 4 segundos
    RRinterval = zeros(1,size(Rpeak,2)-1);
    % Intervalos RR
    for k  = 1:size(Rpeak,2)-1
        RRinterval(1,k) = t(Rpeak(1,k+1)) - t(Rpeak(1,k)); 
    end
    if sum(RRinterval > 4) > 0 
       Exist = 1; Type(7) = 1; 
    end
    
    % Tipo: 8  Isquemia, Modificación Onda T Invertida.
%     for i = 1:length(Ton)
%         Twave = buffer(Ton(i):Toff(i));
%         [Tpeak ind] = max(Twave);
%         
%         if Twave(ind) > buffer(Ton(i))  % Onda T normal
%            posible(i) = 0;
%         else                        % Onda T invertida
%            posible(i) = 1;
%         end     
%     end
%     
%     if sum(posible) > 0
%         Exist = 1; Type(8) = 1; 
%     end
    
end