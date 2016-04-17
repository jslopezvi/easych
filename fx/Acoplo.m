%% Función guardar puntos fiduciales de forma consecutivas entre tramas
function [wl2 lastref refpoint TotalPon TotalPoff TotalQon TotalRpeak TotalSoff TotalTon TotalToff flag2] = Acoplo(tamwl,lbuffer,lastref,tambuffer,longwl,Pon,Poff,Qon,Rpeak,Soff,Ton,Toff,indicador,refpoint,TotalPon, TotalPoff ,TotalQon, TotalRpeak, TotalSoff, TotalTon, TotalToff, flag2,buffer,senal,w,Last_R_peak,flag3)
    
    Numbeats = 20;           % # de latidos a guardar en consecutivo para enviar
    buffer = buffer'; 
    if indicador == 1
        refpoint(1,indicador)   = (tambuffer - longwl) + refpoint + tamwl;
    else
        if indicador > (length(refpoint)+1)
            refpoint(1,length(refpoint)+1)   = (tambuffer - longwl) + refpoint(1,end) + tamwl;
            indicador = length(refpoint)+1;
        else
            refpoint(1,indicador)   = (tambuffer - longwl) + refpoint(1,indicador-1) + tamwl;
        end
    end
    if indicador == 1 
       TotalPon   = Pon;
       TotalPoff  = Poff;
       TotalQon   = Qon;
       TotalRpeak = Rpeak;
       TotalSoff  = Soff;
       TotalTon   = Ton;
       TotalToff  = Toff;
       wl1        = senal((Last_R_peak-w):tambuffer,1);
       wl2        = buffer((Last_R_peak-w):tambuffer,1);
    else
        
            TotalPon   = [TotalPon (Pon + refpoint(1,indicador-1))];
            TotalPoff  = [TotalPoff (Poff + refpoint(1,indicador-1))];
            TotalQon   = [TotalQon (Qon + refpoint(1,indicador-1))];
            TotalRpeak = [TotalRpeak (Rpeak + refpoint(1,indicador-1))];
            TotalSoff  = [TotalSoff (Soff + refpoint(1,indicador-1))];
            TotalTon   = [TotalTon (Ton + refpoint(1,indicador-1))];
            TotalToff  = [TotalToff (Toff + refpoint(1,indicador-1))];
            if flag3 == 0
                wl1        = senal(((Last_R_peak + refpoint(1,indicador-1))-w):(refpoint(1,indicador-1)+length(buffer)),1);
                wl2        = buffer((Last_R_peak-w):(length(buffer)),1);
            else 
                wl1 = [];
            end
    end
    
   
   
    if length(TotalRpeak) >= 20
        flag2 = 1;
    else
        flag2 = 0;
    end
    
   

end