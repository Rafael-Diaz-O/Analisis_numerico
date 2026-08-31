function [root, k, table_data] = my_newton_function_Rafael_Diaz(fun, p0, der, criterion)
% MY_NEWTON_FUNCTION Aproxima una raíz usando el método de Newton-Raphson.
% Muestra en consola una tabla con k, x_k, f(x_k), f'(x_k) y |x_k - x_{k-1}|.
%
% Entradas:
%   fun       : Function handle f(x)
%   p0        : Punto inicial de búsqueda
%   der       : Function handle de la derivada f'(x)
%   criterion : Si es < 1 es tolerancia de error; si es >= 1 es número de iteraciones

if criterion < 1
    tol = criterion;
    max_iter = 1000;
else
    tol = 0;
    max_iter = criterion;
end

x_curr = p0;
table_data = [];

% Encabezado de la tabla formateada
fprintf('\n%-5s %-15s %-15s %-15s %-15s\n', 'k', 'x_k', 'f(x_k)', 'f''(x_k)', '|x_k - x_{k-1}|');
fprintf('---------------------------------------------------------------------------\n');

for k = 0:max_iter
    fx = fun(x_curr);
    dfx = der(x_curr);

    if k == 0
        change_str = 'N/A';
        change = NaN;
    else
        change = abs(x_curr - x_prev);
        change_str = sprintf('%.8e', change);
    end

    fprintf('%-5d %-15.8f %-15.6e %-15.6e %-15s\n', k, x_curr, fx, dfx, change_str);

    table_data = [table_data; k, x_curr, fx, dfx, change];

    % Criterio de parada por tolerancia
    if k > 0 && tol > 0 && change < tol
        break;
    end

    if dfx == 0
        error('La derivada se anuló en x = %f', x_curr);
    end

    x_prev = x_curr;
    x_curr = x_curr - fx / dfx; % Actualización de Newton-Raphson
end

root = x_curr;
end