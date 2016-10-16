function AnalizarResultados( Modelo, Cmax, it, T, str )
% An�lisis de resultados
%Calcula la DESVIACI�N MEDIA
    % Ver "A Genetic-Local Search Algorithm Approach for RCPSP". Kadam &
    % Mane [2015].
    
global sumDev;

if ~isempty(Modelo.opt) && ~isempty(Modelo.instances)
    opt = Modelo.opt;
    
    % s: Mejor soluci�n encontrada hasta la actualidad
    Dev_i = (Cmax - opt) / opt;
    disp(['* DEVi = ',num2str(Dev_i),'   MC(',num2str(it),')=',num2str(Cmax)]);
    
    if Cmax < opt
        disp(['MEJOR SOLUCI�N (',num2str(it),')!!!']);
    end

    if it < T
        sumDev = sumDev + Dev_i;
    else
        if strcmp(str,'j30')
            Dev_avg = (sumDev + Dev_i) / 480;
        elseif strcmp(str,'j60')
            Dev_avg = (sumDev + Dev_i) / 450;
        elseif strcmp(str,'j90')
            Dev_avg = (sumDev + Dev_i) / 445;
        elseif strcmp(str,'j120')
            Dev_avg = (sumDev + Dev_i) / 600;
        else
            disp('Librer�a PSPLIB no encontrada.');
            Dev_avg = '-';
        end
        disp(['* DEVavg = ',num2str(Dev_avg)]);
    end
else
    disp('* El modelo analizado no pertenece al dataset PSPLIB.');
end
end

