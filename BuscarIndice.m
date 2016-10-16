%% BUSCAR INDICE
function [idxPos] = BuscarIndice(Pred,Sucs,Q)
n = numel(Q);
if Pred == 0 && Sucs == n+1
    % La tarea se puede mover en cualquier parte
    pos = randi([1 n],1);
    idxPos = find(Q == pos);
elseif Pred == 0
    % No hay l�mite por izquierda
    pos = randi([1 Sucs],1);
    idxPos = find(Q == pos);
elseif Sucs == n+1
    % No hay l�mite por derecha
    pos = randi([Pred n],1);
    idxPos = find(Q == pos);
else
    % No hay problema con los l�mites
    pos = randi([Pred Sucs],1);
    idxPos = find(Q == pos);
end
end