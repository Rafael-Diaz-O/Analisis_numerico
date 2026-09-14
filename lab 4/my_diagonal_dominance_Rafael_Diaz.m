%1.a 


function [Aord, bord, dominanceTable] = my_diagonal_dominance_Rafael_Diaz(A, b)
% MY_DIAGONAL_DOMINANCE_FIRSTNAME_LASTNAME 
% Reordena las filas de A (y las mismas filas de b) para intentar que la
% matriz resultante sea estrictamente diagonalmente dominante por filas.
%
% [Aord,bord,dominanceTable] = my_diagonal_dominance_firstname_lastname(A,b)
%
% Entradas:
%   A : matriz cuadrada n x n
%   b : vector columna n x 1
%
% Salidas:
%   Aord           : A con las filas reordenadas
%   bord           : b con el mismo reordenamiento de filas
%   dominanceTable : tabla con rowOrder, diagonal, otherSum, dominant

n = size(A,1);
if size(A,2) ~= n
    error('A debe ser una matriz cuadrada.');
end
if numel(b) ~= n
    error('b debe tener la misma cantidad de filas que A.');
end
b = b(:);

absA   = abs(A);
rowSum = sum(absA,2);            % suma de |a_ij| de toda la fila

% qualify(r,i) = true si la fila r puede ir en la posicion i
% (es decir, |A(r,i)| > suma del resto de esa fila)
qualify = false(n,n);
for r = 1:n
    for i = 1:n
        otherSum = rowSum(r) - absA(r,i);
        qualify(r,i) = absA(r,i) > otherSum;
    end
end

% Busqueda por backtracking de una asignacion fila -> posicion
% que use unicamente pares permitidos (qualify = true) y sea biyectiva.
p    = zeros(1,n);
used = false(1,n);
found = backtrack(1);

if ~found
    error(['No se encontro un orden de filas que haga la matriz ' ...
        'estrictamente diagonalmente dominante.']);
end

Aord = A(p,:);
bord = b(p);

rowOrder = p(:);
diagonal = zeros(n,1);
otherSumV = zeros(n,1);
dominant = false(n,1);
for i = 1:n
    diagonal(i)  = abs(Aord(i,i));
    otherSumV(i) = sum(abs(Aord(i,:))) - diagonal(i);
    dominant(i)  = diagonal(i) > otherSumV(i);
end

dominanceTable = table(rowOrder, diagonal, otherSumV, dominant, ...
    'VariableNames', {'rowOrder','diagonal','otherSum','dominant'});

% ---- funcion anidada de backtracking ----
    function ok = backtrack(i)
        if i > n
            ok = true;
            return;
        end
        ok = false;
        for r = 1:n
            if ~used(r) && qualify(r,i)
                used(r) = true;
                p(i) = r;
                if backtrack(i+1)
                    ok = true;
                    return;
                end
                used(r) = false;
                p(i) = 0;
            end
        end
    end

end