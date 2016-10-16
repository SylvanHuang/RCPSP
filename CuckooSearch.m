function [ Sol, MC,MPE ] = CuckooSearch( Modelo,T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Par�metros del algoritmo de Optimizaci�n
% Cuckoo Search

global nSol;
nSol = 25;      % Cantidad de nidos/huevos(= soluciones)
% Probabilidad de EXPLORACI�N/EXPLOTACI�N
global Pa;
Pa = 0.25;       % Tasa de descubrir huevos "infiltrados"
                  % Probabilidad de Abandono de un nido
                  
MaxIt = 400;      % Cantidad de iteraciones m�ximas

mpe = @(F,C) 100 * sum((F - C)./ F) / nSol;
meanRUR = @(RCPSP,Res,C) mean(RUR(RCPSP,Res,C));

%{
%  1) GENERA UNA POBLACI�N INICIAL ALEATORIA.
%}

Pob = CrearSolucionesAleatorias(Modelo,'ActivityList');
% x = CrearSolucionesAleatorias(Modelo,'RandomKey');

MejoresCostos = zeros(MaxIt,1);
MPE = zeros(MaxIt,1);
it = 0;


%% Loop principal

while (it < MaxIt) 
    
    it = it + 1;
    
    %{
    %  2) GENERAR UNA NUEVA SOLUCI�N.
    %}
    NewEgg = GenerarNuevaSolucion(Pob,Modelo);
    
    %{
    %  3) EVAL�A SU CALIDAD.
    %}
    [Cmax, Rk] = MakeSpan(Modelo,NewEgg);
    
    j = randi(nSol);
    Fj = Pob.Fitness(j,:);
    if Cmax < Fj
        % Evito el c�lculo innecesario de RUR().
        Pob.Fitness(j,:) = Cmax;
        Pob.Eggs(j,:) = NewEgg;
    elseif Cmax == Fj
        [~, Rj] = MakeSpan(Modelo,Pob.Eggs(j,:));
        if meanRUR(Modelo,Rk,Cmax) < meanRUR(Modelo,Rj,Fj)
            % En "Best" se guarda la mejor soluci�n entre todas las
            % iteraciones.
            Pob.Fitness(j,:) = Cmax;
            Pob.Eggs(j,:) = NewEgg;
        end
    end
    
    %{
    %  5) DIVERSIFICACI�N.
    %}
    Pob = DescubrirNidos(Pob,Modelo);
    
    %{
    %  6) OBTIENE LA MEJOR SOLUCI�N
    %}
    [Cmax,j] = ObtenerMejorSolucion(Modelo,Pob);
    MPE(it) = mpe(Pob.Fitness,Cmax);
    MejoresCostos(it) = Cmax;
    
    Sol.I = Pob.Eggs(j,:);
    Sol.Cmax = Cmax;
    
    if T == 1
        % Por cada iteraci�n, muestra informaci�n en pantalla
        disp([num2str(it) ' :: Mejor Costo = ' num2str(MejoresCostos(it))]);
    end

    if MPE(it) == 0 
        % Termina en caso de que no haya cambiado la calidad de las
        % soluciones
        break;
    end
    
end
MC = MejoresCostos(1:it);
MPE = MPE(1:it);
end

