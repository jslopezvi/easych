function [tuple TotalPon TotalPoff TotalQon TotalRpeak TotalSoff TotalTon TotalToff Brate_RR] = CheckandSend(flag2, TotalPon, TotalPoff ,TotalQon, TotalRpeak, TotalSoff, TotalTon, TotalToff, Fcardiaca, flag3,tambuffer,Y,X,Brate_RR,Brate_RS,Ton,Toff,Qon,Rpeak,Soff,fs,buffer)

    [Exist Type]= Alarms_Module(Brate_RR,Brate_RS,Fcardiaca,fs,Ton,Toff,Qon,Rpeak,Soff,buffer);
    
    if Exist == 1 || flag2 == 1  || length(Y)  >= length(X)
        
        tuple.Alarm = 1;
        
        tuple.Pon   = TotalPon;
        tuple.Poff  = TotalPoff;
        tuple.Qon   = TotalQon;
        tuple.Rpeak = TotalRpeak;
        tuple.Soff  = TotalSoff;
        tuple.Ton   = TotalTon;
        tuple.Toff  = TotalToff;
        
        tuple.Heart_rate = round(mean(Fcardiaca));
        
        tuple.Respiratory_rate1 = round(mean(Brate_RR));
        tuple.Respiratory_rate2 = round(mean(Brate_RS));
        
        % Módulo de Alarmas
        
        tuple.AlarmType = Type;
        
        TotalPon    = [];
        TotalPoff   = [];
        TotalQon    = [];
        TotalRpeak  = [];
        TotalSoff   = [];
        TotalTon    = [];
        TotalToff   = [];
        %Brate_RR    = [];
        
        fprintf('Envio %d\n',1)
    else
        tuple = 0;
    
    end
    


end