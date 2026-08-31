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

%test 
% Script principal para la Parte II (Newton-Raphson)
clear; clc; close all;

% 1. Definir función y su derivada
fun = @(x) x.^3 + 13*x.^2 - 287.5*x + 0.00000375*exp(x);
der = @(x) 3*x.^2 + 26*x - 287.5 + 0.00000375*exp(x);

% 2. Elegir puntos iniciales p0 para las tres raíces reales
% La función cúbica se anula aprox en x ≈ -22.39, x ≈ 0 y x ≈ 11.45
p0_list = [-25, 0, 12];
tol = 1e-8;

roots_found = zeros(1, 3);

% 3. Ejecutar Newton-Raphson para cada punto inicial
for i = 1:length(p0_list)
    fprintf('\n=======================================================\n');
    fprintf('BÚSQUEDA DE RAÍZ %d CON P0 = %.2f\n', i, p0_list(i));
    fprintf('=======================================================\n');
    
    [r, ~, ~] = my_newton_function_nombre_apellido(fun, p0_list(i), der, tol);
    roots_found(i) = r;
end

% 4. Resumen final de raíces
fprintf('\n=======================================================\n');
fprintf('RESUMEN DE RAÍCES ENCONTRADAS:\n');
for i = 1:3
    fprintf('Raíz %d: x = %.8f (P0 = %.2f)\n', i, roots_found(i), p0_list(i));
end