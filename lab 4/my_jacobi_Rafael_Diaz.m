function [x, iterationTable] = my_jacobi_Rafael_Diaz(A, b, x0, tol, maxIter)
% MY_JACOBI_FIRSTNAME_LASTNAME
% Metodo iterativo de Jacobi.e
%
% [x,iterationTable] = my_jacobi_firstname_lastname(A,b,x0,tol,maxIter)
%
% Entradas:
%   A       : matriz n x n
%   b       : vector n x 1
%   x0      : vector inicial n x 1
%   tol     : tolerancia sobre la distancia euclidiana entre iteraciones
%   maxIter : numero maximo de iteraciones
%
% Salidas:
%   x              : solucion final
%   iterationTable : tabla con k, x1..xn, distance, residual

    n = length(b);
    b  = b(:);
    x0 = x0(:);

    if size(A,1) ~= n || size(A,2) ~= n
        error('A debe ser n x n y del mismo tamano que b.');
    end
    if any(diag(A) == 0)
        error('No se puede aplicar Jacobi: hay un elemento diagonal igual a cero.');
    end

    xOld = x0;
    history = zeros(maxIter, n+3); % k, x1..xn, distance, residual
    k = 0;

    while k < maxIter
        k = k + 1;
        xNew = zeros(n,1);
        for i = 1:n
            s = A(i,:)*xOld - A(i,i)*xOld(i);
            xNew(i) = (b(i) - s) / A(i,i);
        end

        distance = norm(xNew - xOld);
        residual = norm(A*xNew - b);

        history(k,:) = [k, xNew', distance, residual];

        xOld = xNew;

        if distance < tol
            break;
        end
    end

    history = history(1:k,:);
    x = xOld;

    varNames = [{'k'}, arrayfun(@(i) sprintf('x%d',i), 1:n, 'UniformOutput', false), ...
                {'distance'}, {'residual'}];
    iterationTable = array2table(history, 'VariableNames', varNames);

end